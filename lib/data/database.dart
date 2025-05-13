/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: The creation of the database tables using Raw SQL code
 - Section to easily update database tables to new versions
 - Verson 5: adding lifetimefuel cost and lifetimemaintenance cost to respective tables
 - Version 6: Changed userId to text for firebase implementation
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
  final _databaseVersion = 6;
  
  
  static late Database _database;
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
    return await openDatabase(path, version: _databaseVersion, onCreate: onCreate, onUpgrade: onUpgrade,);
  }

  // Updating database with missing table columns, if necessary
Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 6) {
    // ignore: avoid_print
    print('Database updated');

    final existingColumns = await _getColumnNames(db, 'vehicleInformation');

    if (!existingColumns.contains('lifeTimeFuelCost')) {
      await db.execute(
          'ALTER TABLE vehicleInformation ADD COLUMN lifeTimeFuelCost REAL DEFAULT 0.0;');
    }

    if (!existingColumns.contains('lifeTimeMaintenanceCost')) {
      await db.execute(
          'ALTER TABLE vehicleInformation ADD COLUMN lifeTimeMaintenanceCost REAL DEFAULT 0.0;');
    }
  }
}

Future<List<String>> _getColumnNames(Database db, String tableName) async {
  final result = await db.rawQuery('PRAGMA table_info($tableName);');
  return result.map((row) => row['name'] as String).toList();
}

  Future<void> onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE vehicleInformation (
        vehicleId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
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
        archived INTEGER,
        lifeTimeFuelCost REAL,
        lifeTimeMaintenanceCost REAL
      );
    ''');
    await db.execute('''
      CREATE TABLE fuelRecords (
        fuelRecordId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        vehicleId INTEGER,
        fuelAmount REAL,
        fuelPrice REAL,
        refuelCost REAL,
        odometerAmount REAL,
        date TEXT,
        notes TEXT,
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