import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/fuel_records.dart';

class FuelCloudOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseRepository dbRepository = DatabaseRepository.instance;

  /// Create a fuel record in Firestore
  Future<String> createFuelRecord(FuelRecords fuelRecord) async {
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [fuelRecord.vehicleId, fuelRecord.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
    final docRef = _firestore
        .collection('users')
        .doc(fuelRecord.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('fuelRecords')
        .doc();

    final cloudMap = fuelRecord.toMap()
      ..remove('fuelRecordId') // Firestore auto-ID
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(cloudMap);

    return docRef.id;
  }

  /// Update an existing fuel record in Firestore
  Future<void> updateFuelRecord(FuelRecords fuelRecord) async {
    if (fuelRecord.cloudId == null) {
      throw Exception('Cannot update a cloud record without cloudId.');
    }

    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [fuelRecord.vehicleId, fuelRecord.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    final docRef = _firestore
        .collection('users')
        .doc(fuelRecord.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('fuelRecords')
        .doc(fuelRecord.cloudId);

    final cloudMap = fuelRecord.toMap()
      ..remove('fuelRecordId')
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await docRef.update(cloudMap);
  }

  /// Delete a fuel record from Firestore
  Future<void> deleteFuelRecord(FuelRecords fuelRecord) async {
    if (fuelRecord.cloudId == null) {
      throw Exception('Cannot delete a cloud record without fuelRecord cloudId.');
    }

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [fuelRecord.vehicleId, fuelRecord.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    final docRef = _firestore
        .collection('users')
        .doc(fuelRecord.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('fuelRecords')
        .doc(fuelRecord.cloudId);

    await docRef.delete();
  }

  /// Fetch all fuel records for a user (optional for syncing)
  Future<List<FuelRecords>> fetchAllFuelRecords(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('fuelRecords')
        .get();

    return snapshot.docs
        .map((doc) => FuelRecords.fromMap({
              ...doc.data(),
              'cloudId': doc.id,
              'isCloudSynced': 1,
            }))
        .toList();
  }
}