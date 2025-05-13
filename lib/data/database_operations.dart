/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various operation functions to perform CRUD operations on the different database tables
 - Different functions such as create, update, retrieve, and delete on each different table
 - Some additional functions are implemented to make specific calls such as for information on a specific vehicle, or 
   to get all associated fuel or maintenance records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
//import 'package:maintenance_manager/models/maintenance_records.dart';

// Vehicle information table operation functions

class VehicleOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> createVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    db.insert('vehicleInformation', vehicle.toMap());
    // ignore: avoid_print
    print('Vehicle Inserted');

  }

  Future<void> updateVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    await db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicle.vehicleId, vehicle.userId]);
    // ignore: avoid_print
    print('VehicleUpdated');
  }

  Future<void> archiveVehicleById(int vehicleId) async {
    final db = await dbRepository.database;
  await db.update('vehicleInformation', {'archived': 1}, where: 'vehicleId = ?', whereArgs: [vehicleId]);
  }

  Future<void> deleteVehicle(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    db.delete('vehicleInformation', 
    where: 'vehicleId = ? AND userId = ?', 
    whereArgs: [vehicleId, userId]);
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
  Future<FuelRecords> getFuelRecord(int? vehicleId, String userId, int? fuelRecordId) async {
    final db = await dbRepository.database;
    final result = await db.query('fuelRecords', 
      where: 'vehicleId = ? AND userId = ? AND fuelRecordId = ?',
     whereArgs: [vehicleId, userId, fuelRecordId]);
    return FuelRecords.fromMap(result.first);
  }
}

// maintenance Records operation functions