import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/engine_detail_records.dart';

class EngineCloudReadOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(
    String userId,
    String cloudVehicleId,
  ) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(cloudVehicleId)
          .collection('engineDetails')
          .doc('engineDetails'); // fixed doc id per vehicle

  /// Single-per-vehicle: fetch engine details doc.
  Future<EngineDetailsCloudModel?> getEngineDetails(
    String userId,
    String cloudVehicleId, {
    bool decryptSensitive = false, // included for consistency (not used yet)
  }) async {
    final snap = await _doc(userId, cloudVehicleId).get();
    if (!snap.exists) return null;

    // doc.id == 'engineDetails'
    final data = snap.data();

    return EngineDetailsCloudModel.fromJson(
      snap.id, // ✅ cloudId = doc.id
      {
        ...?data,
        'vehicleCloudId': cloudVehicleId,
        'userId': userId,
      },
    );
  }

  /// Stream single doc (live updates)
  Stream<EngineDetailsCloudModel?> watchEngineDetails(
    String userId,
    String cloudVehicleId, {
    bool decryptSensitive = false,
  }) {
    return _doc(userId, cloudVehicleId).snapshots().map((snap) {
      if (!snap.exists) return null;

      final data = snap.data();

      return EngineDetailsCloudModel.fromJson(
        snap.id,
        {
          ...?data,
          'vehicleCloudId': cloudVehicleId,
          'userId': userId,
        },
      );
    });
  }
}