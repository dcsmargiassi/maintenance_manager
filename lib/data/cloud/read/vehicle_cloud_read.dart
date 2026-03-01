import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:maintenance_manager/helper_functions/encryption_helper.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';

class VehicleCloudReadOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('vehicles');

  /// Equivalent of local getAllVehicles(userId)
  Future<List<VehicleInformationModel>> getAllVehicles(
    String userId, {
    bool decryptSensitive = true,
  }) async {
    final snapshot = await _col(userId).get();

    return _mapSnapshot(snapshot, decryptSensitive: decryptSensitive);
  }

  // Archived == 0
  Future<List<VehicleInformationModel>> getAllActiveVehiclesByUserId(
    String userId, {
    bool decryptSensitive = true,
  }) async {
    final snapshot = await _col(userId)
        .where('archived', isEqualTo: 0)
        .get();

    return _mapSnapshot(snapshot, decryptSensitive: decryptSensitive);
  }

  // Archived == 1
  Future<List<VehicleInformationModel>> getAllArchivedVehiclesByUserId(
    String userId, {
    bool decryptSensitive = true,
  }) async {
    final snapshot = await _col(userId)
        .where('archived', isEqualTo: 1)
        .get();

    return _mapSnapshot(snapshot, decryptSensitive: decryptSensitive);
  }

  /// Equivalent of local getVehicleById(vehicleId, userId)
  /// Requires Firestore docs to contain the int field `vehicleId`.
  Future<VehicleInformationModel?> getVehicleByLocalVehicleId(
    String userId,
    int vehicleId, {
    bool decryptSensitive = true,
  }) async {
    final snapshot = await _col(userId)
        .where('vehicleId', isEqualTo: vehicleId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    final data = Map<String, dynamic>.from(doc.data());
    data['cloudId'] = doc.id;

    if (decryptSensitive) {
      await _decryptIntoMapIfPresent(data);
    }

    return VehicleInformationModel.fromJson(data);
  }

  /// Existing: fetch by cloudId
  Future<VehicleInformationModel?> fetchVehicleByCloudId(
    String userId,
    String cloudId, {
    bool decryptSensitive = true,
  }) async {
    final doc = await _col(userId).doc(cloudId).get();
    if (!doc.exists) return null;

    final data = Map<String, dynamic>.from(doc.data() ?? {});
    data['cloudId'] = doc.id;

    if (decryptSensitive) {
      await _decryptIntoMapIfPresent(data);
    }

    return VehicleInformationModel.fromJson(data);
  }

  // ---------- helpers ----------

  Future<List<VehicleInformationModel>> _mapSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot, {
    required bool decryptSensitive,
  }) async {
    final out = <VehicleInformationModel>[];

    for (final doc in snapshot.docs) {
      final data = Map<String, dynamic>.from(doc.data());
      data['cloudId'] = doc.id;

      if (decryptSensitive) {
        await _decryptIntoMapIfPresent(data);
      }

      out.add(VehicleInformationModel.fromJson(data));
    }

    return out;
  }

  // Decrypt only works online, if no connection, remain encrypted
  Future<void> _decryptIntoMapIfPresent(Map<String, dynamic> data) async {
    Future<String?> tryDecrypt(dynamic v) async {
      if (v == null) return null;
      final s = v.toString();
      if (s.isEmpty) return s;
      try {
        return await decryptField(s);
      } catch (e) {
        debugPrint('⚠️ Decrypt failed (offline?): $e');
        return s; // keep ciphertext
      }
    }

    if (data.containsKey('vin')) {
      data['vin'] = await tryDecrypt(data['vin']);
    }
    if (data.containsKey('licensePlate')) {
      data['licensePlate'] = await tryDecrypt(data['licensePlate']);
    }
  }
}