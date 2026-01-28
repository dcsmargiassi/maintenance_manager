import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/helper_functions/encryption_helper.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';

const bool enableVehicleCloudWrite = true;

// Vehicle information table operation functions

class VehicleCloudOperations {
  final DatabaseRepository dbRepository = DatabaseRepository.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createVehicle(VehicleInformationModel vehicle) async {
    // Generate a new doc reference
    final docRef = _firestore
        .collection('users')
        .doc(vehicle.userId)
        .collection('vehicles')
        .doc(); // auto ID

    // Map the vehicle to cloud fields
    final cloudMap = vehicle.toMap()
      ..remove('vehicleId') // Firestore auto-doc ID
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Encryption function for VIN and LicensePlate Field
      if (cloudMap['vin'] != null) {
        cloudMap['vin'] = await encryptField(cloudMap['vin'] as String);
      }
      if (cloudMap['licensePlate'] != null) {
        cloudMap['licensePlate'] =
            await encryptField(cloudMap['licensePlate'] as String);
      }

    await docRef.set(cloudMap);

    return docRef.id;
  }

  Future<void> updateVehicle(VehicleInformationModel vehicle) async {
    if (vehicle.cloudId == null) {
      throw Exception('Vehicle cloudId is null — cannot update Firestore');
    }

    final docRef = _firestore
        .collection('users')
        .doc(vehicle.userId)
        .collection('vehicles')
        .doc(vehicle.cloudId);

    final cloudMap = vehicle.toMap()
      ..remove('vehicleId')
      ..remove('cloudId')
      ..remove('isCloudSynced')
      ..removeWhere((k, v) => v == null);

      // Encryption function for VIN and LicensePlate Field
      if (cloudMap.containsKey('vin')) {
        cloudMap['vin'] = await encryptField(cloudMap['vin'] as String);
      }
      if (cloudMap.containsKey('licensePlate')) {
        cloudMap['licensePlate'] =
            await encryptField(cloudMap['licensePlate'] as String);
      }
    await docRef.update(cloudMap);
  }

  Future<void> archiveVehicleById(int vehicleId, String userId, String date, String cloudId) async {
    if (enableVehicleCloudWrite) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(cloudId)
          .update({'archived': 1, 'sellDate': date});
    }

    final db = await dbRepository.database;
    await db.update(
      'vehicleInformation',
      {'archived': 1, 'sellDate': date, 'isCloudSynced': enableVehicleCloudWrite ? 1 : 0},
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
  }

  Future<void> unarchiveVehicleById(int vehicleId, String userId, String cloudId) async {
    if (enableVehicleCloudWrite) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(cloudId)
          .update({'archived': 0});
    }

    final db = await dbRepository.database;
    await db.update(
      'vehicleInformation',
      {'archived': 0, 'isCloudSynced': enableVehicleCloudWrite ? 1 : 0},
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [vehicleId, userId],
    );
  }

  Future<void> deleteVehicle(String userId, int vehicleId, String? cloudId) async {
    final db = await dbRepository.database;

    if (enableVehicleCloudWrite && cloudId != null) {
      final vehicleDoc = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(cloudId);

      // List of subcollections to delete
      final subcollections = ['fuelRecords', 'engineDetails', 'batteryDetails', 'exteriorDetails'];

      for (var sub in subcollections) {
        final snapshot = await vehicleDoc.collection(sub).get();

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Delete the vehicle document itself
      await vehicleDoc.delete();
    }

    // Delete locally
    await db.delete('fuelRecords', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
    await db.delete('engineDetails', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
    await db.delete('batteryDetails', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
    await db.delete('exteriorDetails', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
    await db.delete('vehicleInformation', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
  }

  Future<List<VehicleInformationModel>> getAllVehicles(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('vehicles').get();

    return snapshot.docs.map((doc) {
      final data = doc.data()..['cloudId'] = doc.id;
      return VehicleInformationModel.fromJson(data);
    }).toList();
  }

  Future<VehicleInformationModel?> getVehicleById(String userId, String cloudId) async {
    final doc = await _firestore.collection('users').doc(userId).collection('vehicles').doc(cloudId).get();
    if (!doc.exists) return null;
    final data = doc.data()!..['cloudId'] = doc.id;
    return VehicleInformationModel.fromJson(data);
  }

  Future<void> updateVehiclePatch({
    required String userId,
    required String cloudId,
    required Map<String, dynamic> patch,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('vehicles')
        .doc(cloudId);
  
    // Encrypt only if present
    if (patch.containsKey('vin')) {
      patch['vin'] = await encryptField((patch['vin'] ?? '') as String);
    }
    if (patch.containsKey('licensePlate')) {
      patch['licensePlate'] =
          await encryptField((patch['licensePlate'] ?? '') as String);
    }
  
    await docRef.update(patch);
  }
}