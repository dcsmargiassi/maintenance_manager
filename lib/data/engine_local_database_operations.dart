import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/data/engine_cloud_database_operations.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';

bool get enableVehicleCloudWrite =>
    FirebaseRemoteConfig.instance.getBool('enableCloudWrite');

class EngineDetailsOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> insertEngineDetails(EngineDetailsModel engine) async {
    final db = await dbRepository.database;
    final localId = await db.insert('engineDetails', engine.toMap());

    if (enableVehicleCloudWrite) {
      try {
        final cloudId = await EngineCloudOperations().insertEngineDetails(engine);

        // Update local DB with cloudId and mark as synced
        await db.update(
          'engineDetails',
          {
            'cloudId': cloudId,
            'isCloudSynced': 1,
          },
          where: 'engineDetailsId = ?',
          whereArgs: [localId],
        );
      } catch (e) {
        throw Exception('Engine insert cloud sync failed: $e');
      }
    }
  }
  
  Future<void> updateEngineDetails(EngineDetailsModel engine) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'engineDetails',
      where: 'engineDetailsId = ? AND userId = ?',
      whereArgs: [engine.engineDetailsId, engine.userId],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw Exception('Engine details row not found');
    }

    final existing = EngineDetailsModel.fromMap(rows.first);

    final merged = engine.copyWith(
      cloudId: existing.cloudId,
      isCloudSynced: 0,
    );

    final localMap = merged.toMap()
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await db.update(
      'engineDetails',
      localMap,
      where: 'engineDetailsId = ? AND userId = ?',
      whereArgs: [merged.engineDetailsId, merged.userId],
    );

    if (!enableVehicleCloudWrite) return;

    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [merged.vehicleId, merged.userId],
      limit: 1,
    );

    final cloudVehicleId =
        vehicleResult.isNotEmpty ? vehicleResult.first['cloudId'] as String? : null;

    if (cloudVehicleId == null) {
      return;
    }

    try {
      if (existing.cloudId == null) {
        final newCloudId = await EngineCloudOperations()
            .insertEngineDetails(merged);

        await db.update(
          'engineDetails',
          {'cloudId': newCloudId, 'isCloudSynced': 1},
          where: 'engineDetailsId = ? AND userId = ?',
          whereArgs: [merged.engineDetailsId, merged.userId],
        );
        return;
      }

      await EngineCloudOperations().updateEngineDetails(merged);

      await db.update(
        'engineDetails',
        {'isCloudSynced': 1},
        where: 'engineDetailsId = ? AND userId = ?',
        whereArgs: [merged.engineDetailsId, merged.userId],
      );
    } catch (e) {
      throw Exception('Engine update cloud sync failed: $e');
    }
  }
  
  Future<void> deleteEngineDetails(String userId, int vehicleId) async {
    final db = await dbRepository.database;

    if (enableVehicleCloudWrite) {
      final engines = await db.query(
        'engineDetails',
        where: 'vehicleId = ? AND userId = ?',
        whereArgs: [vehicleId, userId],
      );

      for (var engineMap in engines) {
        final engine = EngineDetailsModel.fromMap(engineMap);
        if (engine.cloudId != null) {
          try {
            await EngineCloudOperations().deleteEngineDetails(engine);
          } catch (e) {
            throw Exception('Engine delete cloud sync failed: $e');
          }
        }
      }
    }

    await db.delete('engineDetails',
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
  }
  
  Future<EngineDetailsModel> getEngineDetailsByVehicleId(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    final result = await db.query('engineDetails',
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
      return EngineDetailsModel.fromMap(result.first);
  }
}