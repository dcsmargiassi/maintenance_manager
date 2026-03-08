import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/vehicle_detail_records.dart';

class VehicleCloudReadOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('vehicles');

  Future<List<VehicleInformationCloudModel>> getAllVehicles(
    String userId, {
    bool decryptSensitive = false,
  }) async {
    final snapshot = await _col(userId).get();
    return _mapSnapshot(snapshot, decryptSensitive: decryptSensitive);
  }

  Future<List<VehicleInformationCloudModel>> getAllActiveVehiclesByUserId(
    String userId, {
    bool decryptSensitive = false,
  }) async {
    final snapshot = await _col(userId).where('archived', isEqualTo: 0).get();
    return _mapSnapshot(snapshot, decryptSensitive: decryptSensitive);
  }

  Future<List<VehicleInformationCloudModel>> getAllArchivedVehiclesByUserId(
    String userId, {
    bool decryptSensitive = false,
  }) async {
    final snapshot = await _col(userId).where('archived', isEqualTo: 1).get();
    return _mapSnapshot(snapshot, decryptSensitive: decryptSensitive);
  }

  Future<VehicleInformationCloudModel?> getVehicleByCloudId(
    String userId,
    String cloudId, {
    bool decryptSensitive = true,
  }) async {
    final doc = await _col(userId).doc(cloudId).get();
    if (!doc.exists) return null;

    // doc.data() does NOT include doc id, so pass it separately
    return VehicleInformationCloudModel.fromJson(
      doc.id,
      doc.data(),
      decryptSensitive: decryptSensitive,
    );
  }

  // ---------- helpers ----------

  Future<List<VehicleInformationCloudModel>> _mapSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot, {
    required bool decryptSensitive,
  }) async {
    // Build in parallel (faster than awaiting inside a loop)
    final futures = snapshot.docs.map((doc) {
      return VehicleInformationCloudModel.fromJson(
        doc.id,
        doc.data(),
        decryptSensitive: decryptSensitive,
      ).then((v) => v!);
    }).toList();

    return Future.wait(futures);
  }
}