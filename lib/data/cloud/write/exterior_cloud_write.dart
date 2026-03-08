import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/exterior_detail_records.dart';

class ExteriorCloudWriteOperations {
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
          .doc('exteriorDetails');

  /// Create/overwrite exterior details in Firestore (cloud-only).
  /// Uses a fixed doc id because there is one engine details record per vehicle.
  Future<String> insertExteriorDetails(ExteriorDetailsCloudModel exterior) async {
    final docRef = _doc(exterior.userId, exterior.vehicleCloudId);

    final cloudMap = exterior.toMap()
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(cloudMap);
    return docRef.id; // will be 'exteriorDetails'
  }

  /// Update exterior details in Firestore (cloud-only).
  Future<void> updateExteriorDetails(ExteriorDetailsCloudModel exterior) async {
    final docRef = _doc(exterior.userId, exterior.vehicleCloudId);

    final cloudMap = exterior.toMap();

    await docRef.update(cloudMap);
  }

  /// Delete exterior details from Firestore (cloud-only).
  Future<void> deleteExteriorDetails(ExteriorDetailsCloudModel exterior) async {
    final docRef = _doc(exterior.userId, exterior.vehicleCloudId);
    await docRef.delete();
  }
}
