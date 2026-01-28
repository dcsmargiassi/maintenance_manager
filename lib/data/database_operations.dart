/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various operation functions to perform CRUD operations on the different database tables
 - Different functions such as create, update, retrieve, and delete on each different table
 - Some additional functions are implemented to make specific calls such as for information on a specific vehicle, or 
   to get all associated fuel or maintenance records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
//import 'package:maintenance_manager/data/cloud_database_operations.dart';
//import 'package:maintenance_manager/data/database.dart';
//import 'package:maintenance_manager/models/battery_detail_records.dart';
//import 'package:maintenance_manager/models/engine_detail_records.dart';
//import 'package:maintenance_manager/models/exterior_detail_records.dart';
//import 'package:maintenance_manager/models/vehicle_information.dart';
//import 'package:maintenance_manager/models/fuel_records.dart';
// //import 'package:maintenance_manager/models/maintenance_records.dart';
//
// // Vehicle information table operation functions
//
// // Flag for testing of cloud writing
//const bool enableVehicleCloudWrite = true;
//
//class VehicleOperations {
//  DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  Future<int> createVehicle(VehicleInformationModel vehicle) async {
//    final db = await dbRepository.database;
//    final vehicleId = await db.insert('vehicleInformation', vehicle.toMap());
//    if (enableVehicleCloudWrite) {
//      // Create a new instance of the cloud service
//      final cloudId = await VehicleCloudOperations().createVehicle(vehicle);
//
//      // Update the local DB with cloudId and mark as synced
//      await db.update(
//        'vehicleInformation',
//        {
//          'cloudId': cloudId,
//          'isCloudSynced': 1,
//        },
//        where: 'vehicleId = ?',
//        whereArgs: [vehicleId],
//      );
//    }
//    return vehicleId;
//  }
//
//  Future<void> updateVehicle(VehicleInformationModel vehicle) async {
//    final db = await dbRepository.database;
//    //await db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicle.vehicleId, vehicle.userId]);
//
//    final result = await db.query(
//      'vehicleInformation',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicle.vehicleId, vehicle.userId],
//      limit: 1,
//    );
//
//    if (result.isEmpty) {
//      throw Exception('Vehicle not found');
//    }
//
//    final existing = VehicleInformationModel.fromMap(result.first);
//
//    final merged = vehicle.copyWith(
//      cloudId: existing.cloudId,
//      isCloudSynced: 0,
//    );
//
//    final localMap = merged.toMap()
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//      await db.update(
//      'vehicleInformation',
//      localMap,
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [merged.vehicleId, merged.userId],
//    );
//
//    if (enableVehicleCloudWrite) {
//      if (existing.cloudId == null) {
//        final cloudId =
//            await VehicleCloudOperations().createVehicle(merged);
//
//        // Save cloudId locally
//        await db.update(
//          'vehicleInformation',
//          {
//            'cloudId': cloudId,
//            'isCloudSynced': 1,
//          },
//          where: 'vehicleId = ? AND userId = ?',
//          whereArgs: [merged.vehicleId, merged.userId],
//        );
//
//        return; // creation already contains latest data
//      }
//
//  await VehicleCloudOperations().updateVehicle(merged);
//
//  await db.update(
//    'vehicleInformation',
//    {'isCloudSynced': 1},
//    where: 'vehicleId = ? AND userId = ?',
//    whereArgs: [merged.vehicleId, merged.userId],
//  );
//    }
//  }
//
//  Future<void> archiveVehicleById(int vehicleId, String userId, String date) async {
//    final db = await dbRepository.database;
//  await db.update('vehicleInformation', {'archived': 1,'sellDate': date}, where: 'vehicleId = ?', whereArgs: [vehicleId]);
//  if (enableVehicleCloudWrite) {
//      final vehicle = await getVehicleById(vehicleId, userId);
//      await VehicleCloudOperations().updateVehicle(vehicle);
//    }
//  }
//
//  Future<void> unarchiveVehicleById(String userId, int vehicleId) async {
//  final db = await dbRepository.database;
//  await db.update(
//    'vehicleInformation',
//    {'archived': 0},
//    where: 'vehicleId = ? AND userId = ?',
//    whereArgs: [vehicleId, userId],
//  );
//  if (enableVehicleCloudWrite) {
//      final vehicle = await getVehicleById(vehicleId, userId);
//      await VehicleCloudOperations().updateVehicle(vehicle);
//    }
//  }
//
//  Future<void> deleteVehicle(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    VehicleInformationModel vehicle = await getVehicleById(vehicleId, userId);
//    db.delete('vehicleInformation', 
//    where: 'vehicleId = ? AND userId = ?', 
//    whereArgs: [vehicleId, userId]);
//    db.delete('fuelRecords',
//    where: 'vehicleId = ? AND userId = ?',
//    whereArgs: [vehicleId, userId]);
//    db.delete('engineDetails',
//    where: 'vehicleId = ? AND userId = ?',
//    whereArgs: [vehicleId, userId]);
//    db.delete('batteryDetails',
//    where:'vehicleId = ? AND userId = ?',
//    whereArgs: [vehicleId, userId]);
//    if (enableVehicleCloudWrite && vehicle.cloudId != null) {
//      await VehicleCloudOperations().deleteVehicle(vehicle.userId!, vehicleId, vehicle.cloudId);
//    }
//  }
//
//  Future<void> deleteAllVehicles(String userId) async {
//    final db = await dbRepository.database;
//    db.delete('vehicleInformation', 
//    where: 'userId = ?', 
//    whereArgs: [userId]);
//    db.delete('fuelRecords',
//    where: 'userId = ?',
//    whereArgs: [userId]);
//    db.delete('engineDetails',
//    where: 'userId = ?',
//    whereArgs: [userId]);
//    db.delete('batteryDetails',
//    where:'userId = ?',
//    whereArgs: [userId]);
//  }
//
//  Future<List<VehicleInformationModel>> getAllVehicles(String userId) async {
//    final db = await dbRepository.database;
//    final List<Map<String, dynamic>> allVehicles = await db.query("vehicleInformation");
//    return allVehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
//  }
//
//  Future<List<VehicleInformationModel>> getAllVehiclesByUserId(String userId) async {
//    final db = await dbRepository.database;
//    const archivedStatus = 0;
//    final List<Map<String, dynamic>> vehicles = await db.query( 'vehicleInformation', where: 'userId = ? AND archived = ?', whereArgs: [userId, archivedStatus]);
//    return vehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
//  }
//
//  Future<List<VehicleInformationModel>> getAllArchivedVehiclesByUserId(String userId) async {
//    final db = await dbRepository.database;
//    const archivedStatus = 1;
//    final List<Map<String, dynamic>> vehicles = await db.query( 'vehicleInformation', where: 'userId = ? AND archived = ?', whereArgs: [userId, archivedStatus]);
//    return vehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
//  }
//
//  Future<VehicleInformationModel> getVehicleById(int vehicleId, String userId) async {
//    final db = await dbRepository.database;
//    final result = await db.query('vehicleInformation', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
//    return VehicleInformationModel.fromMap(result.first);
//  }
//
//  Future<void> updateLifeTimeFuelCost(VehicleInformationModel vehicle) async {
//    final db = await dbRepository.database;
//    await db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicle.vehicleId, vehicle.userId]);
//    if (enableVehicleCloudWrite) {
//      await VehicleCloudOperations().updateVehicle(vehicle);
//    }
//  }
//}
//
// // Fuel Records operation functions
//
//class FuelRecordOperations {
//  DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  Future<void> createFuelRecord(FuelRecords fuelRecord) async {
//    final db = await dbRepository.database;
//    final int id = await db.insert('fuelRecords', fuelRecord.toMap());
//
//    if (enableVehicleCloudWrite) {
//      final cloudId = await FuelCloudOperations().createFuelRecord(fuelRecord);
//
//      // Update local DB with cloudId & isCloudSynced
//      await db.update(
//        'fuelRecords',
//        {'cloudId': cloudId, 'isCloudSynced': 1},
//        where: 'fuelRecordId = ?',
//        whereArgs: [id],
//      );
//    }
//  }
//
//  Future<void> updateFuelRecord(FuelRecords fuelRecord) async {
//    final db = await dbRepository.database;
//  
//    final rows = await db.query(
//      'fuelRecords',
//      where: 'fuelRecordId = ?',
//      whereArgs: [fuelRecord.fuelRecordId],
//      limit: 1,
//    );
//
//    if (rows.isEmpty) {
//      throw Exception('Fuel record not found');
//    }
//
//    final existing = FuelRecords.fromMap(rows.first);
//
//    final merged = fuelRecord.copyWith(
//      cloudId: existing.cloudId,
//      isCloudSynced: 0,
//    );
//
//    final localMap = merged.toMap()
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await db.update(
//      'fuelRecords',
//      localMap,
//      where: 'fuelRecordId = ?',
//      whereArgs: [merged.fuelRecordId],
//    );
//
//    if (!enableVehicleCloudWrite) return;
//
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [merged.vehicleId, merged.userId],
//      limit: 1,
//    );
//
//    final cloudVehicleId =
//        vehicleResult.isNotEmpty ? vehicleResult.first['cloudId'] as String? : null;
//
//    if (cloudVehicleId == null) {
//      return;
//    }
//
//    if (existing.cloudId == null) {
//      final newCloudId = await FuelCloudOperations().createFuelRecord(merged);
//
//      await db.update(
//        'fuelRecords',
//        {'cloudId': newCloudId, 'isCloudSynced': 1},
//        where: 'fuelRecordId = ?',
//        whereArgs: [merged.fuelRecordId],
//      );
//      return;
//    }
//
//    await FuelCloudOperations().updateFuelRecord(merged);
//
//    await db.update(
//      'fuelRecords',
//      {'isCloudSynced': 1},
//      where: 'fuelRecordId = ?',
//      whereArgs: [merged.fuelRecordId],
//    );
//  }
//
//  Future<void> deleteFuelRecord(FuelRecords fuelRecord) async {
//    final db = await dbRepository.database;
//    db.delete('fuelRecords', where: 'fuelRecordId = ?', whereArgs: [fuelRecord.fuelRecordId]);
//
//    if (enableVehicleCloudWrite && fuelRecord.cloudId != null) {
//      await FuelCloudOperations().deleteFuelRecord(fuelRecord);
//    }
//  }
//
//  Future<void> deleteAllFuelRecordsByVehicleId(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    if (enableVehicleCloudWrite) {
//      final records = await getAllFuelRecordsByVehicleId(userId, vehicleId);
//      for (var record in records) {
//        if (record.cloudId != null) {
//          await FuelCloudOperations().deleteFuelRecord(record);
//        }
//      }
//    }
//
//    await db.delete(
//      'fuelRecords',
//      where: 'userId = ? AND vehicleId = ?',
//      whereArgs: [userId, vehicleId],
//    );
//  }
//
//  Future<List<FuelRecords>> getAllFuelRecords(int vehicleId) async {
//    final db = await dbRepository.database;
//    final List<Map<String, dynamic>> allFuelRecords = await db.query(
//      "fuelRecords", 
//      where: 'vehileId = ?', 
//      whereArgs: [vehicleId]);
//    return allFuelRecords.map((e) => FuelRecords.fromMap(e)).toList();
//  }
//
//  Future<List<FuelRecords>> getAllFuelRecordsByVehicleId(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    final List<Map<String, dynamic>> fuelRecords =
//      await db.query(
//        'fuelRecords',
//        where: 'userId = ? AND vehicleId = ?',
//        whereArgs: [userId, vehicleId]);
//    return fuelRecords.map((e) => FuelRecords.fromMap(e)).toList();
//  }
//
//  Future<List<FuelRecords>> getFuelRecordsByMonth(int vehicleId, int year, int month) async {
//    final db = await dbRepository.database;
//    final firstDayOfMonth = DateTime(year, month, 1);
//    final lastDayOfMonth = DateTime(year, month + 1, 0, 23, 59, 59); // year, month, day, hour, minute, seconds 
//    final records = await db.query(
//      'fuelrecords',
//      where: 'vehicleId = ? AND date >= ? AND date <= ?',
//      whereArgs: [
//        vehicleId,
//        firstDayOfMonth.toIso8601String(),
//        lastDayOfMonth.toIso8601String()
//      ],
//    );
//    return records.map((e) => FuelRecords.fromMap(e)).toList();
//  }
//
//  Future<List<FuelRecords>> getFuelRecordsByYear(int vehicleId, int year) async {
//    final db = await dbRepository.database;
//    final start = DateTime(year, 1, 1);
//    final end = DateTime(year + 1, 1, 1).subtract(Duration(milliseconds: 1));
//    final result = await db.query(
//      'fuelrecords',
//      where: 'vehicleId = ? AND date >= ? AND date <= ?',
//      whereArgs: [vehicleId, start.toIso8601String(), end.toIso8601String()],
//      orderBy: 'date DESC',
//    );
//    return result.map((json) => FuelRecords.fromMap(json)).toList();
//  }
//
//  Future<double> getTotalFuelCostByYear(int vehicleId, int year) async {
//    final db = await dbRepository.database;
//    final start = DateTime(year, 1, 1);
//    final end = DateTime(year + 1, 1, 1).subtract(Duration(milliseconds: 1));
//    final result = await db.rawQuery(
//      'SELECT SUM(refuelCost) as totalCost FROM fuelrecords WHERE vehicleId = ? AND date >= ? AND date <= ?',
//      [vehicleId, start.toIso8601String(), end.toIso8601String()],
//    );
//    double total = result.first['totalCost'] != null ? result.first['totalCost'] as double : 0.0;
//    return total;
//  }
//
//  Future<double> getTotalFuelCostByMonth(int vehicleId, int year, int month) async {
//    final db = await dbRepository.database;
//    final start = DateTime(year, month, 1);
//    final end = (month < 12)
//      ? DateTime(year, month + 1, 1).subtract(Duration(milliseconds: 1))
//      : DateTime(year + 1, 1, 1).subtract(Duration(milliseconds: 1));
//    final result = await db.rawQuery(
//      'SELECT SUM(refuelCost) as totalCost FROM fuelrecords WHERE vehicleId = ? AND date >= ? AND date <= ?',
//      [vehicleId, start.toIso8601String(), end.toIso8601String()],
//    );
//    double total = result.first['totalCost'] != null ? result.first['totalCost'] as double : 0.0;
//    return total;
//  }
//
//  Future<FuelRecords> getFuelRecord(int? vehicleId, String userId, int? fuelRecordId) async {
//    final db = await dbRepository.database;
//    final result = await db.query('fuelRecords', 
//      where: 'vehicleId = ? AND userId = ? AND fuelRecordId = ?',
//     whereArgs: [vehicleId, userId, fuelRecordId]);
//    return FuelRecords.fromMap(result.first);
//  }
//}
//
// // Engine Details operation functions
//class EngineDetailsOperations {
//  DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  Future<void> insertEngineDetails(EngineDetailsModel engine) async {
//    final db = await dbRepository.database;
//    final localId = await db.insert('engineDetails', engine.toMap());
//
//    if (enableVehicleCloudWrite) {
//      try {
//        final cloudId = await EngineCloudOperations().insertEngineDetails(engine);
//
//        // Update local DB with cloudId and mark as synced
//        await db.update(
//          'engineDetails',
//          {
//            'cloudId': cloudId,
//            'isCloudSynced': 1,
//          },
//          where: 'engineDetailsId = ?',
//          whereArgs: [localId],
//        );
//      } catch (e) {
//        throw Exception('Engine insert cloud sync failed: $e');
//      }
//    }
//  }
//  
//  Future<void> updateEngineDetails(EngineDetailsModel engine) async {
//    final db = await dbRepository.database;
//
//    final rows = await db.query(
//      'engineDetails',
//      where: 'engineDetailsId = ? AND userId = ?',
//      whereArgs: [engine.engineDetailsId, engine.userId],
//      limit: 1,
//    );
//
//    if (rows.isEmpty) {
//      throw Exception('Engine details row not found');
//    }
//
//    final existing = EngineDetailsModel.fromMap(rows.first);
//
//    final merged = engine.copyWith(
//      cloudId: existing.cloudId,
//      isCloudSynced: 0,
//    );
//
//    final localMap = merged.toMap()
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await db.update(
//      'engineDetails',
//      localMap,
//      where: 'engineDetailsId = ? AND userId = ?',
//      whereArgs: [merged.engineDetailsId, merged.userId],
//    );
//
//    if (!enableVehicleCloudWrite) return;
//
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [merged.vehicleId, merged.userId],
//      limit: 1,
//    );
//
//    final cloudVehicleId =
//        vehicleResult.isNotEmpty ? vehicleResult.first['cloudId'] as String? : null;
//
//    if (cloudVehicleId == null) {
//      return;
//    }
//
//    try {
//      if (existing.cloudId == null) {
//        final newCloudId = await EngineCloudOperations()
//            .insertEngineDetails(merged);
//
//        await db.update(
//          'engineDetails',
//          {'cloudId': newCloudId, 'isCloudSynced': 1},
//          where: 'engineDetailsId = ? AND userId = ?',
//          whereArgs: [merged.engineDetailsId, merged.userId],
//        );
//        return;
//      }
//
//      await EngineCloudOperations().updateEngineDetails(merged);
//
//      await db.update(
//        'engineDetails',
//        {'isCloudSynced': 1},
//        where: 'engineDetailsId = ? AND userId = ?',
//        whereArgs: [merged.engineDetailsId, merged.userId],
//      );
//    } catch (e) {
//      throw Exception('Engine update cloud sync failed: $e');
//    }
//  }
//  
//  Future<void> deleteEngineDetails(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//
//    if (enableVehicleCloudWrite) {
//      final engines = await db.query(
//        'engineDetails',
//        where: 'vehicleId = ? AND userId = ?',
//        whereArgs: [vehicleId, userId],
//      );
//
//      for (var engineMap in engines) {
//        final engine = EngineDetailsModel.fromMap(engineMap);
//        if (engine.cloudId != null) {
//          try {
//            await EngineCloudOperations().deleteEngineDetails(engine);
//          } catch (e) {
//            throw Exception('Engine delete cloud sync failed: $e');
//          }
//        }
//      }
//    }
//
//    await db.delete('engineDetails',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//  }
//  
//  Future<EngineDetailsModel> getEngineDetailsByVehicleId(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    final result = await db.query('engineDetails',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//      return EngineDetailsModel.fromMap(result.first);
//  }
//}
//
// // Battery details operation functions
//class BatteryDetailsOperations{
//  DatabaseRepository dbRepository = DatabaseRepository.instance;
//  
//  Future<void> insertBatteryDetails(BatteryDetailsModel battery) async {
//    final db = await dbRepository.database;
//    final localId = await db.insert('batteryDetails', battery.toMap());
//
//    if (enableVehicleCloudWrite) {
//      try {
//        final cloudId = await BatteryCloudOperations().insertBatteryDetails(battery);
//
//        await db.update(
//          'batteryDetails',
//          {
//            'cloudId': cloudId,
//            'isCloudSynced': 1,
//          },
//          where: 'batteryDetailsId = ?',
//          whereArgs: [localId],
//        );
//      } catch (e) {
//        throw Exception('Battery insert cloud sync failed: $e');
//      }
//    }
//  }
//
//  Future<void> updateBatteryDetails(BatteryDetailsModel battery) async {
//    final db = await dbRepository.database;
//
//    final rows = await db.query(
//      'batteryDetails',
//      where: 'batteryDetailsId = ? AND userId = ?',
//      whereArgs: [battery.batteryDetailsId, battery.userId],
//      limit: 1,
//    );
//
//    if (rows.isEmpty) {
//      throw Exception('Battery details row not found');
//    }
//
//    final existing = BatteryDetailsModel.fromMap(rows.first);
//
//    final merged = battery.copyWith(
//      cloudId: existing.cloudId,
//      isCloudSynced: 0,
//    );
//
//    final localMap = merged.toMap()
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await db.update(
//      'batteryDetails',
//      localMap,
//      where: 'batteryDetailsId = ? AND userId = ?',
//      whereArgs: [merged.batteryDetailsId, merged.userId],
//    );
//
//    if (!enableVehicleCloudWrite) return;
//
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [merged.vehicleId, merged.userId],
//      limit: 1,
//    );
//
//    final cloudVehicleId =
//        vehicleResult.isNotEmpty ? vehicleResult.first['cloudId'] as String? : null;
//
//    if (cloudVehicleId == null) {
//      return;
//    }
//
//    try {
//      if (existing.cloudId == null) {
//        final newCloudId =
//            await BatteryCloudOperations().insertBatteryDetails(merged);
//
//        await db.update(
//          'batteryDetails',
//          {'cloudId': newCloudId, 'isCloudSynced': 1},
//          where: 'batteryDetailsId = ? AND userId = ?',
//          whereArgs: [merged.batteryDetailsId, merged.userId],
//        );
//        return;
//      }
//
//      await BatteryCloudOperations().updateBatteryDetails(merged);
//
//      await db.update(
//        'batteryDetails',
//        {'isCloudSynced': 1},
//        where: 'batteryDetailsId = ? AND userId = ?',
//        whereArgs: [merged.batteryDetailsId, merged.userId],
//      );
//    } catch (e) {
//      throw Exception('Battery update cloud sync failed: $e');
//    }
//  }
//
//  Future<void> deleteBatteryDetails(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    if (enableVehicleCloudWrite) {
//      final batteries = await db.query(
//        'batteryDetails',
//        where: 'vehicleId = ? AND userId = ?',
//        whereArgs: [vehicleId, userId],
//      );
//
//      for (var batteryMap in batteries) {
//        final battery = BatteryDetailsModel.fromMap(batteryMap);
//        if (battery.cloudId != null) {
//          try {
//            await BatteryCloudOperations().deleteBatteryDetails(battery);
//          } catch (e) {
//            throw Exception('Battery delete cloud sync failed: $e');
//          }
//        }
//      }
//    }
//    await db.delete('batteryDetails',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//  }
//
//  Future<BatteryDetailsModel> getBatteryDetailsByVehicleId(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    final result = await db.query('batteryDetails',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//      return BatteryDetailsModel.fromMap(result.first);
//
//
//  }
//}
//
// // Exterior details operation functions
//class ExteriorDetailsOperations {
//  DatabaseRepository dbRepository = DatabaseRepository.instance;
//  Future<void> insertExteriorDetails(ExteriorDetailsModel exterior) async {
//    final db = await dbRepository.database;
//    final localId = await db.insert('exteriorDetails', exterior.toMap());
//
//    if (enableVehicleCloudWrite) {
//      try {
//        final cloudId = await ExteriorCloudOperations().insertExteriorDetails(exterior);
//
//        await db.update(
//          'exteriorDetails',
//          {
//            'cloudId': cloudId,
//            'isCloudSynced': 1,
//          },
//          where: 'exteriorDetailsId = ?',
//          whereArgs: [localId],
//        );
//      } catch (e) {
//        throw Exception('Exterior insert cloud sync failed: $e');
//      }
//    }
//  }
//
//  Future<void> updateExteriorDetails(ExteriorDetailsModel exterior) async {
//  final db = await dbRepository.database;
//
//  // 1) Load existing row FIRST to preserve cloud bookkeeping
//  final existingRows = await db.query(
//    'exteriorDetails',
//    where: 'exteriorDetailsId = ? AND userId = ?',
//    whereArgs: [exterior.exteriorDetailsId, exterior.userId],
//    limit: 1,
//  );
//
//  if (existingRows.isEmpty) {
//    throw Exception('Exterior details row not found');
//  }
//
//  final existing = ExteriorDetailsModel.fromMap(existingRows.first);
//
//  // 2) Merge: keep existing.cloudId, mark dirty
//  final merged = exterior.copyWith(
//    cloudId: existing.cloudId,
//    isCloudSynced: 0,
//  );
//
//  // 3) Update local row WITHOUT overwriting cloud fields
//  final localMap = merged.toMap()
//    ..remove('cloudId')
//    ..remove('isCloudSynced');
//
//  await db.update(
//    'exteriorDetails',
//    localMap,
//    where: 'exteriorDetailsId = ? AND userId = ?',
//    whereArgs: [merged.exteriorDetailsId, merged.userId],
//  );
//
//  if (!enableVehicleCloudWrite) return;
//
//  final vehicleResult = await db.query(
//    'vehicleInformation',
//    columns: ['cloudId'],
//    where: 'vehicleId = ? AND userId = ?',
//    whereArgs: [merged.vehicleId, merged.userId],
//    limit: 1,
//  );
//
//  final cloudVehicleId = vehicleResult.isNotEmpty ? vehicleResult.first['cloudId'] as String? : null;
//  if (cloudVehicleId == null) {
//    return;
//  }
//
//  if (existing.cloudId == null) {
//    final newCloudId =
//        await ExteriorCloudOperations().insertExteriorDetails(merged);
//
//    await db.update(
//      'exteriorDetails',
//      {'cloudId': newCloudId, 'isCloudSynced': 1},
//      where: 'exteriorDetailsId = ? AND userId = ?',
//      whereArgs: [merged.exteriorDetailsId, merged.userId],
//    );
//    return;
//  }
//
//  await ExteriorCloudOperations().updateExteriorDetails(merged);
//
//  await db.update(
//    'exteriorDetails',
//    {'isCloudSynced': 1},
//    where: 'exteriorDetailsId = ? AND userId = ?',
//    whereArgs: [merged.exteriorDetailsId, merged.userId],
//  );
//}
//
//  Future<void> deleteExteriorDetails(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    if (enableVehicleCloudWrite) {
//      final result = await db.query(
//        'exteriorDetails',
//        where: 'vehicleId = ? AND userId = ?',
//        whereArgs: [vehicleId, userId],
//      );
//
//      for (var map in result) {
//        final exterior = ExteriorDetailsModel.fromMap(map);
//        if (exterior.cloudId != null) {
//          try {
//            await ExteriorCloudOperations().deleteExteriorDetails(exterior);
//          } catch (e) {
//            throw Exception('Exterior delete cloud sync failed: $e');
//          }
//        }
//      }
//    }
//
//    await db.delete(
//      'exteriorDetails',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//  }
//
//  Future<ExteriorDetailsModel> getExteriorDetailsByVehicleId(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    final result = await db.query(
//      'exteriorDetails',
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//    if (result.isNotEmpty){
//    return ExteriorDetailsModel.fromMap(result.first);
//    } else {
//      return ExteriorDetailsModel(
//      userId: userId,
//      vehicleId: vehicleId,
//      driverWindshieldWiper: '',
//      passengerWindshieldWiper: '',
//      rearWindshieldWiper: '',
//      headlampHighBeam: '',
//      headlampLowBeam: '',
//      turnLamp: '',
//      backupLamp: '',
//      fogLamp: '',
//      brakeLamp: '',
//      licensePlateLamp: '',
//      );
//    }
//  }
//  Future<bool> exteriorDetailsExists(String userId, int vehicleId) async {
//    final db = await dbRepository.database;
//    final result = await db.query(
//      'exteriorDetails',
//      where: 'userId = ? AND vehicleId = ?',
//      whereArgs: [userId, vehicleId],
//      limit: 1,
//    );
//    return result.isNotEmpty;
//  }
//}
//
//
//
// // maintenance Records operation functions