import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/data/vehicle_cloud_database_operations.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';

bool get enableVehicleCloudWrite =>
    FirebaseRemoteConfig.instance.getBool('enableCloudWrite');

class VehicleOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;

  Future<int> createVehicle(VehicleInformationModel vehicle) async {
    final db = await dbRepository.database;
    final vehicleId = await db.insert('vehicleInformation', vehicle.toMap());
    if (enableVehicleCloudWrite) {
      // Create a new instance of the cloud service
      final cloudId = await VehicleCloudOperations().createVehicle(vehicle);

      // Update the local DB with cloudId and mark as synced
      await db.update(
        'vehicleInformation',
        {
          'cloudId': cloudId,
          'isCloudSynced': 1,
        },
        where: 'vehicleId = ?',
        whereArgs: [vehicleId],
      );
    }
    return vehicleId;
  }

  Future<void> updateVehicle(VehicleInformationModel vehicle) async {
  final db = await dbRepository.database;

  final result = await db.query(
    'vehicleInformation',
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [vehicle.vehicleId, vehicle.userId],
    limit: 1,
  );

  if (result.isEmpty) throw Exception('Vehicle not found');

  final existing = VehicleInformationModel.fromMap(result.first);

  final merged = vehicle.copyWith(
    cloudId: existing.cloudId,
    isCloudSynced: 0,
  );

  // Local update
  final localMap = merged.toMap()
    ..remove('cloudId')
    ..remove('isCloudSynced');

  await db.update(
    'vehicleInformation',
    localMap,
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [merged.vehicleId, merged.userId],
  );

  if (!enableVehicleCloudWrite) return;

  // Cloud PATCH (only changed fields)
  final patch = <String, dynamic>{};

  void setIfChanged(String key, dynamic newVal, dynamic oldVal) {
    if (newVal != oldVal) patch[key] = newVal;
  }

  setIfChanged('vehicleNickName', merged.vehicleNickName, existing.vehicleNickName);
  setIfChanged('make', merged.make, existing.make);
  setIfChanged('model', merged.model, existing.model);
  setIfChanged('version', merged.version, existing.version);
  setIfChanged('year', merged.year, existing.year);
  setIfChanged('purchaseDate', merged.purchaseDate, existing.purchaseDate);
  setIfChanged('sellDate', merged.sellDate, existing.sellDate);
  setIfChanged('odometerBuy', merged.odometerBuy, existing.odometerBuy);
  setIfChanged('odometerSell', merged.odometerSell, existing.odometerSell);
  setIfChanged('odometerCurrent', merged.odometerCurrent, existing.odometerCurrent);
  setIfChanged('purchasePrice', merged.purchasePrice, existing.purchasePrice);
  setIfChanged('sellPrice', merged.sellPrice, existing.sellPrice);
  setIfChanged('archived', merged.archived, existing.archived);
  setIfChanged('lifeTimeFuelCost', merged.lifeTimeFuelCost, existing.lifeTimeFuelCost);
  setIfChanged('lifeTimeMaintenanceCost', merged.lifeTimeMaintenanceCost, existing.lifeTimeMaintenanceCost);

  // Sensitive fields only if changed - High cost with encryption
  setIfChanged('vin', merged.vin, existing.vin);
  setIfChanged('licensePlate', merged.licensePlate, existing.licensePlate);

  if (patch.isEmpty) {
    await db.update(
      'vehicleInformation',
      {'isCloudSynced': 1},
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [merged.vehicleId, merged.userId],
    );
    return;
  }

  // Create cloud record if not existing
  if (existing.cloudId == null) {
    final cloudId = await VehicleCloudOperations().createVehicle(merged);

    await db.update(
      'vehicleInformation',
      {'cloudId': cloudId, 'isCloudSynced': 1},
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [merged.vehicleId, merged.userId],
    );
    return;
  }

  // Normal cloud update uses PATCH, not full update
  await VehicleCloudOperations().updateVehiclePatch(
    userId: merged.userId!,
    cloudId: existing.cloudId!,
    patch: patch,
  );

  await db.update(
    'vehicleInformation',
    {'isCloudSynced': 1},
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [merged.vehicleId, merged.userId],
  );
}

    Future<void> archiveVehicleById(int vehicleId, String userId, String date) async {
      final db = await dbRepository.database;
    await db.update('vehicleInformation', {'archived': 1,'sellDate': date}, where: 'vehicleId = ?', whereArgs: [vehicleId]);
    if (enableVehicleCloudWrite) {
        final vehicle = await getVehicleById(vehicleId, userId);
        await VehicleCloudOperations().updateVehicle(vehicle);
    }
  }

  Future<void> unarchiveVehicleById(String userId, int vehicleId) async {
  final db = await dbRepository.database;
  await db.update(
    'vehicleInformation',
    {'archived': 0},
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [vehicleId, userId],
  );
  if (enableVehicleCloudWrite) {
      final vehicle = await getVehicleById(vehicleId, userId);
      await VehicleCloudOperations().updateVehicle(vehicle);
    }
  }

  Future<void> deleteVehicle(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    VehicleInformationModel vehicle = await getVehicleById(vehicleId, userId);
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
    if (enableVehicleCloudWrite && vehicle.cloudId != null) {
      await VehicleCloudOperations().deleteVehicle(vehicle.userId!, vehicleId, vehicle.cloudId);
    }
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

  Future<List<VehicleInformationModel>> getAllVehicles(String userId) async {
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
    if (enableVehicleCloudWrite) {
      //await VehicleCloudOperations().updateVehicle(vehicle);
    // Get cloudId
      final rows = await db.query(
        'vehicleInformation',
        columns: ['cloudId'],
        where: 'vehicleId = ? AND userId = ?',
        whereArgs: [vehicle.vehicleId, vehicle.userId],
        limit: 1,
      );

      if (rows.isEmpty || rows.first['cloudId'] == null) {
        // Vehicle not yet in cloud; leave unsynced and let backfill/next edit create it
        return;
      }

      final cloudId = rows.first['cloudId'] as String;

      // Cloud update: patch only the lifetime cost (no VIN/plate included)
      await VehicleCloudOperations().updateVehiclePatch(
        userId: vehicle.userId!,
        cloudId: cloudId,
        patch: {
          'lifeTimeFuelCost': vehicle.lifeTimeFuelCost,
        },
      );

      // Mark local as synced
      await db.update(
        'vehicleInformation',
        {'isCloudSynced': 1},
        where: 'vehicleId = ? AND userId = ?',
        whereArgs: [vehicle.vehicleId, vehicle.userId],
      );
    }
  }
}