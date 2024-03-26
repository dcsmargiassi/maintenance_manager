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

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
  final db = await dbRepository.database;
  var result = await db.query('user', where: 'email = ? AND password = ?', whereArgs: [email, password]);
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

  Future<String?> getUserIdByEmail(String email) async {
    final db = await dbRepository.database;
    var result = await db.query('user', columns: ['userId'], where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first['userId'] as String : null;
}
}

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
    db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId=>?', whereArgs: [vehicle.vehicleId]);

  }

  Future<void> archiveVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    db.update('vehicleInformation', vehicle.toMap(), where: 'vehicleId=>?', whereArgs: [vehicle.vehicleId]);

  }

  Future<void> deleteVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    db.delete('vehicleInformation', where: 'vehicleId=>?', whereArgs: [vehicle.vehicleId]);

  }

  Future<List<VehicleInformationModel>> getAllVehicles() async {
    final db = await dbRepository.database;
    final List<Map<String, dynamic>> allVehicles = await db.query("vehicleInformation");
    return allVehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
  }

  Future<List<VehicleInformationModel>> getAllVehiclesByUserId(int userId) async {
    final db = await dbRepository.database;
    final List<Map<String, dynamic>> vehicles = await db.query( 'vehicleInformation', where: 'userId = ?', whereArgs: [userId]);
    return vehicles.map((e) => VehicleInformationModel.fromJson(e)).toList();
}

  Future<VehicleInformationModel> getVehicleById(int vehicleId, int userId) async {
    final db = await dbRepository.database;
    final result = await db.query('vehicleInformation', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
    return VehicleInformationModel.fromMap(result.first);
  }
}

// Fuel Records operation functions

 //class FuelRecords {
 //  
 //}


// maintenance Records operation functions

// Fuel records operation functions

