import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/exterior_detail_records.dart';

class ExteriorCloudReadOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(
    String userId,
    String vehicleCloudId,
  ) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleCloudId)
          .collection('exteriorDetails')
          .doc('exteriorDetails'); // fixed doc id per vehicle

  /// Cloud equivalent of getExteriorDetailsByVehicleId(...)
  /// If doc doesn't exist, returns defaults (empty strings) like your local function.
  Future<ExteriorDetailsCloudModel> getExteriorDetails(
    String userId,
    String vehicleCloudId,
  ) async {
    final snap = await _doc(userId, vehicleCloudId).get();

    if (!snap.exists) {
      return ExteriorDetailsCloudModel.empty(
        userId: userId,
        vehicleCloudId: vehicleCloudId,
      );
    }

    final data = snap.data() ?? {};
    // ensure ids exist even if not stored
    final merged = <String, dynamic>{
      ...data,
      'userId': data['userId'] ?? userId,
      'vehicleCloudId': data['vehicleCloudId'] ?? vehicleCloudId,
    };

    return ExteriorDetailsCloudModel.fromMap(snap.id, merged);
  }

  /// Cloud equivalent of exteriorDetailsExists(...)
  Future<bool> exteriorDetailsExists(
    String userId,
    String vehicleCloudId,
  ) async {
    final snap = await _doc(userId, vehicleCloudId).get();
    return snap.exists;
  }

  /// Optional: live updates
  Stream<ExteriorDetailsCloudModel> watchExteriorDetails(
    String userId,
    String vehicleCloudId,
  ) {
    return _doc(userId, vehicleCloudId).snapshots().map((snap) {
      if (!snap.exists) {
        return ExteriorDetailsCloudModel.empty(
          userId: userId,
          vehicleCloudId: vehicleCloudId,
        );
      }

      final data = snap.data() ?? {};
      final merged = <String, dynamic>{
        ...data,
        'userId': data['userId'] ?? userId,
        'vehicleCloudId': data['vehicleCloudId'] ?? vehicleCloudId,
      };

      return ExteriorDetailsCloudModel.fromMap(snap.id, merged);
    });
  }
}