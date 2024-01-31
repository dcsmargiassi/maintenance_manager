/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various operation functions to perform CRUD operations on the different database tables
 - Different functions such as create, update, retrieve, and delete on each different table
 - Some additional functions are implemented to make specific calls such as for information on a specific vehicle, or 
   to get all associated fuel or maintenance records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/user.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:maintenance_manager/models/maintenance_records.dart';
//import 'package:maintenance_manager/models/fuel_records.dart';

// User table operation functions

class UserOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> createUser(User user) async {
    final db = await dbRepository.database;
    db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);

  }

  Future<User?> getUserByEmail(String email) async {
    final db = await dbRepository.database;
    var result = await db.query('user', where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await dbRepository.database;
    var result = await db.query('user', where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<void> updateUser(User user) async {
    final db = await dbRepository.database;
    db.update('user', user.toMap(), where: 'email=>?', whereArgs: [user.email]);

  }

  Future<void> deleteUser(User user) async {
    final db = await dbRepository.database;
    db.delete('user', where: 'email=>?', whereArgs: [user.email]);

  }

  Future<void> updateLastLogin(User user) async {
    final db = await dbRepository.database;
    await db.update(
      'user',
      {'lastLogin': DateTime.now().toIso8601String()},
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await dbRepository.database;
    var allRows = await db.query('user');
    List<User> users = allRows.map((user) => User.fromMap(user)).toList();
    return users;
  }
}

// Vehicle information table operation functions

class VehicleOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<void> createVehicle(VehicleInformation vehicle) async {
    final db = await dbRepository.database;
    db.insert('vehicleInformation', vehicle.toMap());
    // ignore: avoid_print
    print('Vehicle Inserted');

  }

  Future<void> updateVehicle(VehicleInformation vehicle) async {
    final db = await dbRepository.database;
    db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId=>?', whereArgs: [vehicle.vehicleId]);

  }

  Future<void> archiveVehicle(VehicleInformation vehicle) async {
    final db = await dbRepository.database;
    db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId=>?', whereArgs: [vehicle.vehicleId]);

  }

  Future<void> deleteVehicle(VehicleInformation vehicle) async {
    final db = await dbRepository.database;
    db.delete('vehicleInformation', where: 'vehicleId=>?', whereArgs: [vehicle.vehicleId]);

  }

  Future<List<VehicleInformation>> getAllVehicles() async {
    final db = await dbRepository.database;
    var allRows = await db.query('vehicleInformation');
    List<VehicleInformation> vehicles = allRows.map((vehicle) => VehicleInformation.fromMap(vehicle)).toList();
    return vehicles;
  }
}

// Fuel Records operation functions

 //class FuelRecords {
 //  
 //}


// maintenance Records operation functions

// Fuel records operation functions

