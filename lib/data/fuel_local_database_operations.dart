import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/data/fuel_cloud_database_operations.dart';
import 'package:maintenance_manager/models/fuel_records.dart';

bool get enableVehicleCloudWrite =>
    FirebaseRemoteConfig.instance.getBool('enableCloudWrite');

class FuelRecordOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> createFuelRecord(FuelRecords fuelRecord) async {
    final db = await dbRepository.database;
    final int id = await db.insert('fuelRecords', fuelRecord.toMap());

    if (enableVehicleCloudWrite) {
      final cloudId = await FuelCloudOperations().createFuelRecord(fuelRecord);

      // Update local DB with cloudId & isCloudSynced
      await db.update(
        'fuelRecords',
        {'cloudId': cloudId, 'isCloudSynced': 1},
        where: 'fuelRecordId = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> updateFuelRecord(FuelRecords fuelRecord) async {
    final db = await dbRepository.database;
  
    final rows = await db.query(
      'fuelRecords',
      where: 'fuelRecordId = ?',
      whereArgs: [fuelRecord.fuelRecordId],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw Exception('Fuel record not found');
    }

    final existing = FuelRecords.fromMap(rows.first);

    final merged = fuelRecord.copyWith(
      cloudId: existing.cloudId,
      isCloudSynced: 0,
    );

    final localMap = merged.toMap()
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await db.update(
      'fuelRecords',
      localMap,
      where: 'fuelRecordId = ?',
      whereArgs: [merged.fuelRecordId],
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

    if (existing.cloudId == null) {
      final newCloudId = await FuelCloudOperations().createFuelRecord(merged);

      await db.update(
        'fuelRecords',
        {'cloudId': newCloudId, 'isCloudSynced': 1},
        where: 'fuelRecordId = ?',
        whereArgs: [merged.fuelRecordId],
      );
      return;
    }

    await FuelCloudOperations().updateFuelRecord(merged);

    await db.update(
      'fuelRecords',
      {'isCloudSynced': 1},
      where: 'fuelRecordId = ?',
      whereArgs: [merged.fuelRecordId],
    );
  }

  Future<void> deleteFuelRecord(FuelRecords fuelRecord) async {
    final db = await dbRepository.database;
    db.delete('fuelRecords', where: 'fuelRecordId = ?', whereArgs: [fuelRecord.fuelRecordId]);

    if (enableVehicleCloudWrite && fuelRecord.cloudId != null) {
      await FuelCloudOperations().deleteFuelRecord(fuelRecord);
    }
  }

  Future<void> deleteAllFuelRecordsByVehicleId(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    if (enableVehicleCloudWrite) {
      final records = await getAllFuelRecordsByVehicleId(userId, vehicleId);
      for (var record in records) {
        if (record.cloudId != null) {
          await FuelCloudOperations().deleteFuelRecord(record);
        }
      }
    }

    await db.delete(
      'fuelRecords',
      where: 'userId = ? AND vehicleId = ?',
      whereArgs: [userId, vehicleId],
    );
  }

  Future<List<FuelRecords>> getAllFuelRecords(int vehicleId) async {
    final db = await dbRepository.database;
    final List<Map<String, dynamic>> allFuelRecords = await db.query(
      "fuelRecords", 
      where: 'vehileId = ?', 
      whereArgs: [vehicleId]);
    return allFuelRecords.map((e) => FuelRecords.fromMap(e)).toList();
  }

  Future<List<FuelRecords>> getAllFuelRecordsByVehicleId(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    final List<Map<String, dynamic>> fuelRecords =
      await db.query(
        'fuelRecords',
        where: 'userId = ? AND vehicleId = ?',
        whereArgs: [userId, vehicleId]);
    return fuelRecords.map((e) => FuelRecords.fromMap(e)).toList();
  }

  Future<List<FuelRecords>> getFuelRecordsByMonth(int vehicleId, int year, int month) async {
    final db = await dbRepository.database;
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0, 23, 59, 59); // year, month, day, hour, minute, seconds 
    final records = await db.query(
      'fuelrecords',
      where: 'vehicleId = ? AND date >= ? AND date <= ?',
      whereArgs: [
        vehicleId,
        firstDayOfMonth.toIso8601String(),
        lastDayOfMonth.toIso8601String()
      ],
    );
    return records.map((e) => FuelRecords.fromMap(e)).toList();
  }

  Future<List<FuelRecords>> getFuelRecordsByYear(int vehicleId, int year) async {
    final db = await dbRepository.database;
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1).subtract(Duration(milliseconds: 1));
    final result = await db.query(
      'fuelrecords',
      where: 'vehicleId = ? AND date >= ? AND date <= ?',
      whereArgs: [vehicleId, start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return result.map((json) => FuelRecords.fromMap(json)).toList();
  }

  Future<double> getTotalFuelCostByYear(int vehicleId, int year) async {
    final db = await dbRepository.database;
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1).subtract(Duration(milliseconds: 1));
    final result = await db.rawQuery(
      'SELECT SUM(refuelCost) as totalCost FROM fuelrecords WHERE vehicleId = ? AND date >= ? AND date <= ?',
      [vehicleId, start.toIso8601String(), end.toIso8601String()],
    );
    double total = result.first['totalCost'] != null ? result.first['totalCost'] as double : 0.0;
    return total;
  }

  Future<double> getTotalFuelCostByMonth(int vehicleId, int year, int month) async {
    final db = await dbRepository.database;
    final start = DateTime(year, month, 1);
    final end = (month < 12)
      ? DateTime(year, month + 1, 1).subtract(Duration(milliseconds: 1))
      : DateTime(year + 1, 1, 1).subtract(Duration(milliseconds: 1));
    final result = await db.rawQuery(
      'SELECT SUM(refuelCost) as totalCost FROM fuelrecords WHERE vehicleId = ? AND date >= ? AND date <= ?',
      [vehicleId, start.toIso8601String(), end.toIso8601String()],
    );
    double total = result.first['totalCost'] != null ? result.first['totalCost'] as double : 0.0;
    return total;
  }

  Future<FuelRecords> getFuelRecord(int? vehicleId, String userId, int? fuelRecordId) async {
    final db = await dbRepository.database;
    final result = await db.query('fuelRecords', 
      where: 'vehicleId = ? AND userId = ? AND fuelRecordId = ?',
     whereArgs: [vehicleId, userId, fuelRecordId]);
    return FuelRecords.fromMap(result.first);
  }
}