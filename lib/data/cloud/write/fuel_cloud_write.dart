import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/fuel_detail_records.dart';

class FuelCloudWriteOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(
    String userId,
    String vehicleCloudId,
  ) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleCloudId)
          .collection('fuelRecords');

  /// Create a fuel record in Firestore (cloud-only)
  Future<String> createFuelRecord(FuelRecordCloudModel record) async {
    final docRef = _col(record.userId, record.vehicleCloudId).doc();

    final map = record.toMap()
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(map);
    return docRef.id;
  }

  /// Update an existing fuel record in Firestore (cloud-only)
  Future<void> updateFuelRecord(FuelRecordCloudModel record) async {
    if (record.cloudId == null || record.cloudId!.isEmpty) {
      throw Exception('Cannot update a cloud record without cloudId.');
    }

    final docRef = _col(record.userId, record.vehicleCloudId).doc(record.cloudId);

    final map = record.toMap()
      ..remove('createdAt'); // preserve original createdAt

    await docRef.update(map);
  }

  /// Delete a fuel record from Firestore (cloud-only)
  Future<void> deleteFuelRecord(FuelRecordCloudModel record) async {
    if (record.cloudId == null || record.cloudId!.isEmpty) {
      throw Exception('Cannot delete fuel record without a valid cloudId.');
    }

    final docRef = _col(record.userId, record.vehicleCloudId).doc(record.cloudId);

    await docRef.delete();
  }

  /// Delete all fuel records for a specific vehicle (cloud-only)
  Future<void> deleteAllFuelRecordsByVehicleCloudId(
    String userId,
    String vehicleCloudId,
  ) async {
    final snapshot = await _col(userId, vehicleCloudId).get();
  
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Fetch all fuel records for a specific vehicle (optional/debug)
  Future<List<FuelRecordCloudModel>> fetchAllFuelRecordsForVehicle({
    required String userId,
    required String vehicleCloudId,
  }) async {
    final snapshot = await _col(userId, vehicleCloudId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => FuelRecordCloudModel.fromMap(
              doc.id,
              {
                ...doc.data(),
                'userId': doc.data()['userId'] ?? userId,
                'vehicleCloudId': doc.data()['vehicleCloudId'] ?? vehicleCloudId,
              },
            ))
        .toList();
  }
}