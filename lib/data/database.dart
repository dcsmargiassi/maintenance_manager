/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: The creation of the database tables using Raw SQL code
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';


class DatabaseRepository {
  DatabaseRepository._privateConstructor();

  static final DatabaseRepository instance =
  DatabaseRepository._privateConstructor();

  final _databaseName = 'maintenanceManagerDatabase';
  final _databaseVersion = 2;
  
  
  static late Database _database; // Took away static and replaced with late to fix error as database should always be initialized at run time unless an error...
  static Completer<Database>? _databaseCompleter;
// Checking to see if database is already created, if not jump to _initdatabase and create it

  Future<Database> get database async {
    if (_databaseCompleter == null) {
      _databaseCompleter = Completer<Database>();
      _database = await _initDatabase();
      _databaseCompleter!.complete(_database);
    }
    return _databaseCompleter!.future;
  }

Future<Database> _initDatabase() async {
    Directory documents = await getApplicationDocumentsDirectory();
    String path = join(documents.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: onCreate);
  }

//// Creating the database an initializing the path to the local directory where data will be stored.
//  // ignore: unused_element
//  _initDatabase() async {
//    Directory documents = await getApplicationDocumentsDirectory();
//    String path = join(documents.path + _databaseName);
//    return await openDatabase(path, version: _databaseVersion, onCreate: onCreate);
//  }

  Future<void> onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE user (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        lastLogin TEXT,
        emailNotifications INTEGER,
        firstname TEXT,
        lastname TEXT
      );
      ''');
    await db.execute('''
      CREATE TABLE vehicleInformation (
        vehicleId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        vehicleNickName TEXT,
        vin TEXT,
        make TEXT,
        model TEXT,
        version TEXT,
        year INTEGER,
        purchaseDate TEXT,
        sellDate TEXT,
        odometerBuy REAL,
        odometerSell REAL,
        odometerCurrent REAL,
        purchasePrice REAL,
        sellPrice REAL,
        FOREIGN KEY (userId) REFERENCES user(userId)
      );
    ''');
    await db.execute('''
      CREATE TABLE fuelRecords (
        fuelRecordId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        vehicleId INTEGER,
        fuelAmount REAL,
        fuelPrice REAL,
        refuelCost REAL,
        odometerAmount REAL,
        date TEXT,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES user(userId),
        FOREIGN KEY (vehicleId) REFERENCES vehicleInformation(vehicleId)
      );
    ''');
    await db.execute('''
      CREATE TABLE maintenanceRecords (
        maintenanceRecordId INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER,
        date TEXT,
        workLocation TEXT,
        maintenanceType TEXT,
        notes TEXT,
        oilChange INTEGER,
        tireRotationAlignment INTEGER,
        FOREIGN KEY (vehicleId) REFERENCES vehicleInformation(vehicleId)
      );
    ''');
  }
}