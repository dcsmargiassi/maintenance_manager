import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:maintenance_manager/data/battery_cloud_database_operations.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';

bool get enableVehicleCloudWrite =>
    FirebaseRemoteConfig.instance.getBool('enableCloudWrite');

class BatteryDetailsOperations{
  DatabaseRepository dbRepository = DatabaseRepository.instance;
  
  Future<void> insertBatteryDetails(BatteryDetailsModel battery) async {
    final db = await dbRepository.database;
    final localId = await db.insert('batteryDetails', battery.toMap());

    if (enableVehicleCloudWrite) {
      try {
        final cloudId = await BatteryCloudOperations().insertBatteryDetails(battery);

        await db.update(
          'batteryDetails',
          {
            'cloudId': cloudId,
            'isCloudSynced': 1,
          },
          where: 'batteryDetailsId = ?',
          whereArgs: [localId],
        );
      } catch (e) {
        throw Exception('Battery insert cloud sync failed: $e');
      }
    }
  }

  Future<void> updateBatteryDetails(BatteryDetailsModel battery) async {
    final db = await dbRepository.database;

    final rows = await db.query(
      'batteryDetails',
      where: 'batteryDetailsId = ? AND userId = ?',
      whereArgs: [battery.batteryDetailsId, battery.userId],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw Exception('Battery details row not found');
    }

    final existing = BatteryDetailsModel.fromMap(rows.first);

    final merged = battery.copyWith(
      cloudId: existing.cloudId,
      isCloudSynced: 0,
    );

    final localMap = merged.toMap()
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await db.update(
      'batteryDetails',
      localMap,
      where: 'batteryDetailsId = ? AND userId = ?',
      whereArgs: [merged.batteryDetailsId, merged.userId],
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
        final newCloudId =
            await BatteryCloudOperations().insertBatteryDetails(merged);

        await db.update(
          'batteryDetails',
          {'cloudId': newCloudId, 'isCloudSynced': 1},
          where: 'batteryDetailsId = ? AND userId = ?',
          whereArgs: [merged.batteryDetailsId, merged.userId],
        );
        return;
      }

      await BatteryCloudOperations().updateBatteryDetails(merged);

      await db.update(
        'batteryDetails',
        {'isCloudSynced': 1},
        where: 'batteryDetailsId = ? AND userId = ?',
        whereArgs: [merged.batteryDetailsId, merged.userId],
      );
    } catch (e) {
      throw Exception('Battery update cloud sync failed: $e');
    }
  }

  Future<void> deleteBatteryDetails(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    if (enableVehicleCloudWrite) {
      final batteries = await db.query(
        'batteryDetails',
        where: 'vehicleId = ? AND userId = ?',
        whereArgs: [vehicleId, userId],
      );

      for (var batteryMap in batteries) {
        final battery = BatteryDetailsModel.fromMap(batteryMap);
        if (battery.cloudId != null) {
          try {
            await BatteryCloudOperations().deleteBatteryDetails(battery);
          } catch (e) {
            throw Exception('Battery delete cloud sync failed: $e');
          }
        }
      }
    }
    await db.delete('batteryDetails',
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
  }

  Future<BatteryDetailsModel> getBatteryDetailsByVehicleId(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    final result = await db.query('batteryDetails',
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
      return BatteryDetailsModel.fromMap(result.first);
  }
}