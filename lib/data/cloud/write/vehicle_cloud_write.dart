import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:maintenance_manager/cloud_models/vehicle_detail_records.dart';
import 'package:maintenance_manager/helper_functions/encryption_helper.dart';

bool get enableVehicleCloudWrite =>
    FirebaseRemoteConfig.instance.getBool('enableCloudWrite');

// Vehicle information table operation functions

class VehicleCloudWriteOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('vehicles');

  DocumentReference<Map<String, dynamic>> _doc(String userId, String cloudVehicleId) =>
      _col(userId).doc(cloudVehicleId);

  /// Create vehicle (cloud-only). Returns new cloud doc id.
  Future<String> createVehicle(VehicleInformationCloudModel vehicle) async {
    final docRef = _col(vehicle.userId).doc(); // auto ID

    final map = vehicle.toMap()
      ..addAll({'createdAt': FieldValue.serverTimestamp()});

    // Encrypt sensitive fields if present AND non-null
    if (map['vin'] != null) {
      map['vin'] = await encryptField(map['vin'] as String);
    }
    if (map['licensePlate'] != null) {
      map['licensePlate'] = await encryptField(map['licensePlate'] as String);
    }

    await docRef.set(map);
    return docRef.id;
  }

  /// Update vehicle (cloud-only). Requires non-empty cloudId.
  Future<void> updateVehicle(VehicleInformationCloudModel vehicle) async {
    if (vehicle.cloudId.isEmpty) {
      throw Exception('Vehicle cloudId is empty — cannot update Firestore');
    }

    final docRef = _doc(vehicle.userId, vehicle.cloudId);

    final patch = vehicle.toMap()
      ..removeWhere((k, v) => v == null);

    // Encrypt sensitive fields only if included in the patch
    if (patch.containsKey('vin') && patch['vin'] != null) {
      patch['vin'] = await encryptField(patch['vin'] as String);
    }
    if (patch.containsKey('licensePlate') && patch['licensePlate'] != null) {
      patch['licensePlate'] = await encryptField(patch['licensePlate'] as String);
    }

    await docRef.update(patch);
  }

  /// Patch update (cloud-only).
  Future<void> updateVehiclePatch({
    required String userId,
    required String cloudVehicleId,
    required Map<String, dynamic> patch,
  }) async {
    final docRef = _doc(userId, cloudVehicleId);

    patch.removeWhere((k, v) => v == null);

    // Encrypt only if present
    if (patch.containsKey('vin') && patch['vin'] != null) {
      patch['vin'] = await encryptField(patch['vin'] as String);
    }
    if (patch.containsKey('licensePlate') && patch['licensePlate'] != null) {
      patch['licensePlate'] = await encryptField(patch['licensePlate'] as String);
    }

    await docRef.update(patch);
  }

  /// Archive (cloud-only).
  Future<void> archiveVehicle({
    required String userId,
    required String cloudVehicleId,
    required String sellDateIso,
  }) async {
    await _doc(userId, cloudVehicleId).update({
      'archived': 1,
      'sellDate': sellDateIso,
    });
  }

  /// Unarchive (cloud-only).
  Future<void> unarchiveVehicle({
    required String userId,
    required String cloudVehicleId,
  }) async {
    await _doc(userId, cloudVehicleId).update({
      'archived': 0,
    });
  }

  /// Delete vehicle + subcollections (cloud-only).
  Future<void> deleteVehicle({
    required String userId,
    required String cloudVehicleId,
  }) async {
    final vehicleDoc = _doc(userId, cloudVehicleId);

    final subcollections = [
      'fuelRecords',
      'engineDetails',
      'batteryDetails',
      'exteriorDetails',
    ];

    for (final sub in subcollections) {
      final snap = await vehicleDoc.collection(sub).get();
      for (final d in snap.docs) {
        await d.reference.delete();
      }
    }

    await vehicleDoc.delete();
  }

  Future<void> deleteAllVehicles({
    required String userId,
  }) async {
    final snapshot = await _col(userId).get();
  
    for (final doc in snapshot.docs) {
      await deleteVehicle(
        userId: userId,
        cloudVehicleId: doc.id,
      );
    }
  }

  Future<void> updateLifeTimeFuelCost({
    required String userId,
    required String cloudVehicleId,
    required double lifeTimeFuelCost,
  }) async {
    await updateVehiclePatch(
      userId: userId,
      cloudVehicleId: cloudVehicleId,
      patch: {
        'lifeTimeFuelCost': lifeTimeFuelCost,
      },
    );
  }
}