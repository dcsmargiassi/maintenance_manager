import 'package:maintenance_manager/data/battery_cloud_database_operations.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/data/engine_cloud_database_operations.dart';
import 'package:maintenance_manager/data/exterior_cloud_database_operations.dart';
import 'package:maintenance_manager/data/fuel_cloud_database_operations.dart';
import 'package:maintenance_manager/data/vehicle_cloud_database_operations.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';
import 'package:maintenance_manager/models/exterior_detail_records.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';

/// Runs a one-time (or periodic) migration of local-only data to Firestore.
///
/// Backfill order matters because child collections require the parent vehicle
/// to already exist in Firestore:
/// 1) Vehicles
/// 2) Single-per-vehicle details (engine/battery/exterior)
/// 3) Many-per-vehicle records (fuel)
///
/// Rows are selected where isCloudSynced = 0.
/// Successful uploads mark isCloudSynced = 1 and persist cloudId (if created).
class CloudBackfillService {
  CloudBackfillService._internal({
    DatabaseRepository? dbRepository,
    VehicleCloudOperations? vehicleCloud,
    EngineCloudOperations? engineCloud,
    BatteryCloudOperations? batteryCloud,
    ExteriorCloudOperations? exteriorCloud,
    FuelCloudOperations? fuelCloud,
  })  : dbRepository = dbRepository ?? DatabaseRepository.instance,
        vehicleCloud = vehicleCloud ?? VehicleCloudOperations(),
        engineCloud = engineCloud ?? EngineCloudOperations(),
        batteryCloud = batteryCloud ?? BatteryCloudOperations(),
        exteriorCloud = exteriorCloud ?? ExteriorCloudOperations(),
        fuelCloud = fuelCloud ?? FuelCloudOperations();

  static final CloudBackfillService instance = CloudBackfillService._internal();

  final DatabaseRepository dbRepository;
  final VehicleCloudOperations vehicleCloud;
  final EngineCloudOperations engineCloud;
  final BatteryCloudOperations batteryCloud;
  final ExteriorCloudOperations exteriorCloud;
  final FuelCloudOperations fuelCloud;
  // Prevent concurrent runs (common cause of duplicate cloud inserts).
  bool _running = false;

  CloudBackfillService({
    DatabaseRepository? dbRepository,
    VehicleCloudOperations? vehicleCloud,
    EngineCloudOperations? engineCloud,
    BatteryCloudOperations? batteryCloud,
    ExteriorCloudOperations? exteriorCloud,
    FuelCloudOperations? fuelCloud,
  })  : dbRepository = dbRepository ?? DatabaseRepository.instance,
        vehicleCloud = vehicleCloud ?? VehicleCloudOperations(),
        engineCloud = engineCloud ?? EngineCloudOperations(),
        batteryCloud = batteryCloud ?? BatteryCloudOperations(),
        exteriorCloud = exteriorCloud ?? ExteriorCloudOperations(),
        fuelCloud = fuelCloud ?? FuelCloudOperations();

  /// Runs one pass of backfill across all supported tables.
  /// Call repeatedly (or on a timer) until [BackfillResult.hasMore] is false.
  Future<BackfillResult> runOnce(
    String userId, {
    int vehicleLimit = 25,
    int detailsLimit = 75,
    int recordLimit = 150,
  }) async {
    if (_running) {
      // A run is already in progress; report that there may still be work.
      return BackfillResult(
        processedByTable: const {},
        totalProcessed: 0,
        hasMore: true,
      );
    }

    _running = true;
    try {
      final counts = <String, int>{};

      counts['vehicles'] = await _backfillVehicles(userId, limit: vehicleLimit);

      counts['engineDetails'] =
          await _backfillEngineDetails(userId, limit: detailsLimit);
      counts['batteryDetails'] =
          await _backfillBatteryDetails(userId, limit: detailsLimit);
      counts['exteriorDetails'] =
          await _backfillExteriorDetails(userId, limit: detailsLimit);

      counts['fuelRecords'] =
          await _backfillFuelRecords(userId, limit: recordLimit);

      final totalProcessed = counts.values.fold<int>(0, (sum, v) => sum + v);

      // There may be more if we hit any per-table limit or if child rows were
      // skipped because the vehicle isn't synced yet.
      final hasMore = await _hasAnyUnsyncedRows(userId);

      return BackfillResult(
        processedByTable: counts,
        totalProcessed: totalProcessed,
        hasMore: hasMore,
      );
    } finally {
      _running = false;
    }
  }

  // ---------- Vehicles ----------

  Future<int> _backfillVehicles(String userId, {required int limit}) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'vehicleInformation',
      where: 'userId = ? AND isCloudSynced = 0',
      whereArgs: [userId],
      limit: limit,
    );

    var processed = 0;

    for (final row in rows) {
      final vehicle = VehicleInformationModel.fromMap(row);

      // Safety: if ids are unexpectedly null, skip.
      if (vehicle.vehicleId == null || vehicle.userId == null) continue;

      try {
        if (vehicle.cloudId == null) {
          final cloudId = await vehicleCloud.createVehicle(vehicle);

          final updated = await db.update(
            'vehicleInformation',
            {'cloudId': cloudId, 'isCloudSynced': 1},
            where: 'vehicleId = ? AND userId = ?',
            whereArgs: [vehicle.vehicleId, vehicle.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill vehicles: failed to mark vehicleId=${vehicle.vehicleId} as synced (updated=$updated)',
            );
          }
        } else {
          await vehicleCloud.updateVehicle(vehicle);

          final updated = await db.update(
            'vehicleInformation',
            {'isCloudSynced': 1},
            where: 'vehicleId = ? AND userId = ?',
            whereArgs: [vehicle.vehicleId, vehicle.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill vehicles: failed to mark vehicleId=${vehicle.vehicleId} as synced (updated=$updated)',
            );
          }
        }

        processed++;
      } catch (_) {
        // Leave row unsynced for retry in a future run.
      }
    }

    return processed;
  }

  // ---------- Helpers (vehicle cloudId lookup) ----------

  Future<String?> _getVehicleCloudId({
    required int vehicleId,
    required String userId,
  }) async {
    final db = await dbRepository.database;

    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
      limit: 1,
    );

    if (vehicleResult.isEmpty) return null;
    return vehicleResult.first['cloudId'] as String?;
  }

  // ---------- Engine Details ----------

  Future<int> _backfillEngineDetails(String userId, {required int limit}) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'engineDetails',
      where: 'userId = ? AND isCloudSynced = 0',
      whereArgs: [userId],
      limit: limit,
    );

    var processed = 0;

    for (final row in rows) {
      final engine = EngineDetailsModel.fromMap(row);

      if (engine.engineDetailsId == null || engine.userId == null) continue;

      // Must have vehicle cloudId first
      final cloudVehicleId = await _getVehicleCloudId(
        vehicleId: engine.vehicleId,
        userId: engine.userId!,
      );
      if (cloudVehicleId == null) continue;

      try {
        if (engine.cloudId == null) {
          final cloudId = await engineCloud.insertEngineDetails(engine);

          final updated = await db.update(
            'engineDetails',
            {'cloudId': cloudId, 'isCloudSynced': 1},
            where: 'engineDetailsId = ? AND userId = ?',
            whereArgs: [engine.engineDetailsId, engine.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill engine: failed to mark engineDetailsId=${engine.engineDetailsId} as synced (updated=$updated)',
            );
          }
        } else {
          await engineCloud.updateEngineDetails(engine);

          final updated = await db.update(
            'engineDetails',
            {'isCloudSynced': 1},
            where: 'engineDetailsId = ? AND userId = ?',
            whereArgs: [engine.engineDetailsId, engine.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill engine: failed to mark engineDetailsId=${engine.engineDetailsId} as synced (updated=$updated)',
            );
          }
        }

        processed++;
      } catch (_) {}
    }

    return processed;
  }

  // ---------- Battery Details ----------

  Future<int> _backfillBatteryDetails(String userId, {required int limit}) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'batteryDetails',
      where: 'userId = ? AND isCloudSynced = 0',
      whereArgs: [userId],
      limit: limit,
    );

    var processed = 0;

    for (final row in rows) {
      final battery = BatteryDetailsModel.fromMap(row);

      if (battery.batteryDetailsId == null) continue;

      final cloudVehicleId = await _getVehicleCloudId(
        vehicleId: battery.vehicleId,
        userId: battery.userId,
      );
      if (cloudVehicleId == null) continue;

      try {
        if (battery.cloudId == null) {
          final cloudId = await batteryCloud.insertBatteryDetails(battery);

          final updated = await db.update(
            'batteryDetails',
            {'cloudId': cloudId, 'isCloudSynced': 1},
            where: 'batteryDetailsId = ? AND userId = ?',
            whereArgs: [battery.batteryDetailsId, battery.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill battery: failed to mark batteryDetailsId=${battery.batteryDetailsId} as synced (updated=$updated)',
            );
          }
        } else {
          await batteryCloud.updateBatteryDetails(battery);

          final updated = await db.update(
            'batteryDetails',
            {'isCloudSynced': 1},
            where: 'batteryDetailsId = ? AND userId = ?',
            whereArgs: [battery.batteryDetailsId, battery.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill battery: failed to mark batteryDetailsId=${battery.batteryDetailsId} as synced (updated=$updated)',
            );
          }
        }

        processed++;
      } catch (_) {}
    }

    return processed;
  }

  // ---------- Exterior Details ----------

  Future<int> _backfillExteriorDetails(String userId,
      {required int limit}) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'exteriorDetails',
      where: 'userId = ? AND isCloudSynced = 0',
      whereArgs: [userId],
      limit: limit,
    );

    var processed = 0;

    for (final row in rows) {
      final exterior = ExteriorDetailsModel.fromMap(row);

      if (exterior.exteriorDetailsId == null) continue;

      final cloudVehicleId = await _getVehicleCloudId(
        vehicleId: exterior.vehicleId,
        userId: exterior.userId,
      );
      if (cloudVehicleId == null) continue;

      try {
        if (exterior.cloudId == null) {
          final cloudId = await exteriorCloud.insertExteriorDetails(exterior);

          final updated = await db.update(
            'exteriorDetails',
            {'cloudId': cloudId, 'isCloudSynced': 1},
            where: 'exteriorDetailsId = ? AND userId = ?',
            whereArgs: [exterior.exteriorDetailsId, exterior.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill exterior: failed to mark exteriorDetailsId=${exterior.exteriorDetailsId} as synced (updated=$updated)',
            );
          }
        } else {
          await exteriorCloud.updateExteriorDetails(exterior);

          final updated = await db.update(
            'exteriorDetails',
            {'isCloudSynced': 1},
            where: 'exteriorDetailsId = ? AND userId = ?',
            whereArgs: [exterior.exteriorDetailsId, exterior.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill exterior: failed to mark exteriorDetailsId=${exterior.exteriorDetailsId} as synced (updated=$updated)',
            );
          }
        }

        processed++;
      } catch (_) {}
    }

    return processed;
  }

  // ---------- Fuel Records ----------

  Future<int> _backfillFuelRecords(String userId, {required int limit}) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'fuelRecords',
      where: 'userId = ? AND isCloudSynced = 0',
      whereArgs: [userId],
      limit: limit,
    );

    var processed = 0;

    for (final row in rows) {
      final fuel = FuelRecords.fromMap(row);

      // Avoid crashes on nulls
      if (fuel.fuelRecordId == null || fuel.userId == null || fuel.vehicleId == null) {
        continue;
      }

      final cloudVehicleId = await _getVehicleCloudId(
        vehicleId: fuel.vehicleId!,
        userId: fuel.userId!,
      );
      if (cloudVehicleId == null) continue;

      try {
        if (fuel.cloudId == null) {
          final cloudId = await fuelCloud.createFuelRecord(fuel);

          final updated = await db.update(
            'fuelRecords',
            {'cloudId': cloudId, 'isCloudSynced': 1},
            where: 'fuelRecordId = ? AND userId = ?',
            whereArgs: [fuel.fuelRecordId, fuel.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill fuel: failed to mark fuelRecordId=${fuel.fuelRecordId} as synced (updated=$updated)',
            );
          }
        } else {
          await fuelCloud.updateFuelRecord(fuel);

          final updated = await db.update(
            'fuelRecords',
            {'isCloudSynced': 1},
            where: 'fuelRecordId = ? AND userId = ?',
            whereArgs: [fuel.fuelRecordId, fuel.userId],
          );

          if (updated != 1) {
            throw Exception(
              'Backfill fuel: failed to mark fuelRecordId=${fuel.fuelRecordId} as synced (updated=$updated)',
            );
          }
        }

        processed++;
      } catch (_) {}
    }

    return processed;
  }

  // ---------- Status ----------

  Future<bool> _hasAnyUnsyncedRows(String userId) async {
    final db = await dbRepository.database;

    final tables = <String>[
      'vehicleInformation',
      'engineDetails',
      'batteryDetails',
      'exteriorDetails',
      'fuelRecords',
    ];

    for (final table in tables) {
      final rows = await db.rawQuery(
        'SELECT 1 FROM $table WHERE userId = ? AND isCloudSynced = 0 LIMIT 1',
        [userId],
      );
      if (rows.isNotEmpty) return true;
    }

    return false;
  }
}

class BackfillResult {
  final Map<String, int> processedByTable;
  final int totalProcessed;
  final bool hasMore;

  BackfillResult({
    required this.processedByTable,
    required this.totalProcessed,
    required this.hasMore,
  });
}