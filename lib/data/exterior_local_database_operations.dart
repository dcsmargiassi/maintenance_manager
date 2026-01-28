import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/data/exterior_cloud_database_operations.dart';
import 'package:maintenance_manager/models/exterior_detail_records.dart';

bool get enableVehicleCloudWrite =>
    FirebaseRemoteConfig.instance.getBool('enableCloudWrite');

class ExteriorDetailsOperations {
  DatabaseRepository dbRepository = DatabaseRepository.instance;
  Future<void> insertExteriorDetails(ExteriorDetailsModel exterior) async {
    final db = await dbRepository.database;
    final localId = await db.insert('exteriorDetails', exterior.toMap());

    if (enableVehicleCloudWrite) {
      try {
        final cloudId = await ExteriorCloudOperations().insertExteriorDetails(exterior);

        await db.update(
          'exteriorDetails',
          {
            'cloudId': cloudId,
            'isCloudSynced': 1,
          },
          where: 'exteriorDetailsId = ?',
          whereArgs: [localId],
        );
      } catch (e) {
        throw Exception('Exterior insert cloud sync failed: $e');
      }
    }
  }

  Future<void> updateExteriorDetails(ExteriorDetailsModel exterior) async {
  final db = await dbRepository.database;

  // 1) Load existing row FIRST to preserve cloud bookkeeping
  final existingRows = await db.query(
    'exteriorDetails',
    where: 'exteriorDetailsId = ? AND userId = ?',
    whereArgs: [exterior.exteriorDetailsId, exterior.userId],
    limit: 1,
  );

  if (existingRows.isEmpty) {
    throw Exception('Exterior details row not found');
  }

  final existing = ExteriorDetailsModel.fromMap(existingRows.first);

  // 2) Merge: keep existing.cloudId, mark dirty
  final merged = exterior.copyWith(
    cloudId: existing.cloudId,
    isCloudSynced: 0,
  );

  // 3) Update local row WITHOUT overwriting cloud fields
  final localMap = merged.toMap()
    ..remove('cloudId')
    ..remove('isCloudSynced');

  await db.update(
    'exteriorDetails',
    localMap,
    where: 'exteriorDetailsId = ? AND userId = ?',
    whereArgs: [merged.exteriorDetailsId, merged.userId],
  );

  if (!enableVehicleCloudWrite) return;

  final vehicleResult = await db.query(
    'vehicleInformation',
    columns: ['cloudId'],
    where: 'vehicleId = ? AND userId = ?',
    whereArgs: [merged.vehicleId, merged.userId],
    limit: 1,
  );

  final cloudVehicleId = vehicleResult.isNotEmpty ? vehicleResult.first['cloudId'] as String? : null;
  if (cloudVehicleId == null) {
    return;
  }

  if (existing.cloudId == null) {
    final newCloudId =
        await ExteriorCloudOperations().insertExteriorDetails(merged);

    await db.update(
      'exteriorDetails',
      {'cloudId': newCloudId, 'isCloudSynced': 1},
      where: 'exteriorDetailsId = ? AND userId = ?',
      whereArgs: [merged.exteriorDetailsId, merged.userId],
    );
    return;
  }

  await ExteriorCloudOperations().updateExteriorDetails(merged);

  await db.update(
    'exteriorDetails',
    {'isCloudSynced': 1},
    where: 'exteriorDetailsId = ? AND userId = ?',
    whereArgs: [merged.exteriorDetailsId, merged.userId],
  );
}

  Future<void> deleteExteriorDetails(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    if (enableVehicleCloudWrite) {
      final result = await db.query(
        'exteriorDetails',
        where: 'vehicleId = ? AND userId = ?',
        whereArgs: [vehicleId, userId],
      );

      for (var map in result) {
        final exterior = ExteriorDetailsModel.fromMap(map);
        if (exterior.cloudId != null) {
          try {
            await ExteriorCloudOperations().deleteExteriorDetails(exterior);
          } catch (e) {
            throw Exception('Exterior delete cloud sync failed: $e');
          }
        }
      }
    }

    await db.delete(
      'exteriorDetails',
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
  }

  Future<ExteriorDetailsModel> getExteriorDetailsByVehicleId(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    final result = await db.query(
      'exteriorDetails',
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
    if (result.isNotEmpty){
    return ExteriorDetailsModel.fromMap(result.first);
    } else {
      return ExteriorDetailsModel(
      userId: userId,
      vehicleId: vehicleId,
      driverWindshieldWiper: '',
      passengerWindshieldWiper: '',
      rearWindshieldWiper: '',
      headlampHighBeam: '',
      headlampLowBeam: '',
      turnLamp: '',
      backupLamp: '',
      fogLamp: '',
      brakeLamp: '',
      licensePlateLamp: '',
      );
    }
  }
  Future<bool> exteriorDetailsExists(String userId, int vehicleId) async {
    final db = await dbRepository.database;
    final result = await db.query(
      'exteriorDetails',
      where: 'userId = ? AND vehicleId = ?',
      whereArgs: [userId, vehicleId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}