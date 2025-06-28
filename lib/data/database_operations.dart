/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various operation functions to perform CRUD operations on the different database tables
 - Different functions such as create, update, retrieve, and delete on each different table
 - Some additional functions are implemented to make specific calls such as for information on a specific vehicle, or 
   to get all associated fuel or maintenance records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
//import 'package:maintenance_manager/models/maintenance_records.dart';

// Vehicle information table operation functions

class VehicleOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<int> createVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    final vehicleId = await db.insert('vehicleInformation', vehicle.toMap());
    return vehicleId;
  }

  Future<void> updateVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    await db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicle.vehicleId, vehicle.userId]);
    // ignore: avoid_print
    print('VehicleUpdated');
  }

  Future<void> archiveVehicleById(int vehicleId, String date) async {
    final db = await dbRepository.database;
  await db.update('vehicleInformation', {'archived': 1,'sellDate': date}, where: 'vehicleId = ?', whereArgs: [vehicleId]);
  }

  Future<void> unarchiveVehicleById(String userId, int vehicleId) async {
  final db = await dbRepository.database;
  await db.update(
    'vehicleInformation',
    {'archived': 0},
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [vehicleId, userId],
  );
  }

  Future<void> deleteVehicle(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    db.delete('vehicleInformation', 
    where: 'vehicleId = ? AND userId = ?', 
    whereArgs: [vehicleId, userId]);
    db.delete('fuelRecords',
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [vehicleId, userId]);
    db.delete('engineDetails',
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [vehicleId, userId]);
    db.delete('batteryDetails',
    where:'vehicleId = ? AND userId = ?',
    whereArgs: [vehicleId, userId]);
  }

  Future<void> deleteAllVehicles(String userId) async {
    final db = await dbRepository.database;
    db.delete('vehicleInformation', 
    where: 'userId = ?', 
    whereArgs: [userId]);
    db.delete('fuelRecords',
    where: 'userId = ?',
    whereArgs: [userId]);
    db.delete('engineDetails',
    where: 'userId = ?',
    whereArgs: [userId]);
    db.delete('batteryDetails',
    where:'userId = ?',
    whereArgs: [userId]);
  }

  Future<List<VehicleInformationModel>> getAllVehicles() async {
    final db = await dbRepository.database;
    final List<Map<String, dynamic>> allVehicles = await db.query("vehicleInformation");
    return allVehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
  }

  Future<List<VehicleInformationModel>> getAllVehiclesByUserId(String userId) async {
    final db = await dbRepository.database;
    const archivedStatus = 0;
    final List<Map<String, dynamic>> vehicles = await db.query( 'vehicleInformation', where: 'userId = ? AND archived = ?', whereArgs: [userId, archivedStatus]);
    return vehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
  }

  Future<List<VehicleInformationModel>> getAllArchivedVehiclesByUserId(String userId) async {
    final db = await dbRepository.database;
    const archivedStatus = 1;
    final List<Map<String, dynamic>> vehicles = await db.query( 'vehicleInformation', where: 'userId = ? AND archived = ?', whereArgs: [userId, archivedStatus]);
    return vehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
  }

  Future<VehicleInformationModel> getVehicleById(int vehicleId, String userId) async {
    final db = await dbRepository.database;
    final result = await db.query('vehicleInformation', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
    return VehicleInformationModel.fromMap(result.first);
  }

  Future<void> updateLifeTimeFuelCost(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    await db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicle.vehicleId, vehicle.userId]);
  }
}

// Fuel Records operation functions

class FuelRecordOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> createFuelRecord(FuelRecords fuelRecord) async {
    final db = await dbRepository.database;
    db.insert('fuelRecords', fuelRecord.toMap());
  }

  Future<void> updateFuelRecord(FuelRecords fuelRecord) async {
    final db = await dbRepository.database;
    db.update('fuelRecords', fuelRecord.toMap(),
        where: 'fuelRecordId = ?',
        whereArgs: [fuelRecord.fuelRecordId]);
  }

  Future<void> deleteFuelRecord(int fuelRecordId) async {
    final db = await dbRepository.database;
    db.delete('fuelRecords', where: 'fuelRecordId = ?', whereArgs: [fuelRecordId]);
  }
  Future<void> deleteAllFuelRecordsByVehicleId(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    db.delete('fuelRecords', 
      where: 'userId = ? AND vehicleId = ?', 
      whereArgs: [userId, vehicleId]);
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

// Engine Details operation functions
class EngineDetailsOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> insertEngineDetails(EngineDetailsModel engine) async {
    final db = await dbRepository.database;
    await db.insert('engineDetails', engine.toMap());
  }
  
  Future<void> updateEngineDetails(EngineDetailsModel engine) async {
    final db = await dbRepository.database;
    await db.update('engineDetails', engine.toMap(),
      where: 'engineDetailsId = ? AND userId = ?',
      whereArgs: [engine.engineDetailsId, engine.userId],
    );
  }
  
  Future<void> deleteEngineDetails(String userId, int vehicleId) async {
    final db = await dbRepository.database;
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

// Battery details operation functions
class BatteryDetailsOperations{
  DatabaseRepository dbRepository = DatabaseRepository.instance;
  
  Future<void> insertBatteryDetails(BatteryDetailsModel battery) async {
    final db = await dbRepository.database;
    await db.insert('batteryDetails', battery.toMap());
  }

  Future<void> updateBatteryDetails(BatteryDetailsModel battery) async {
    final db = await dbRepository.database;
    await db.update('batteryDetails', battery.toMap(),
      where: 'batteryDetailsId = ? AND userId = ?',
      whereArgs: [battery.batteryDetailsId, battery.userId],
    );
  }

  Future<void> deleteBatteryDetails(String userId, int vehicleId) async {
    final db = await dbRepository.database;
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


// maintenance Records operation functions