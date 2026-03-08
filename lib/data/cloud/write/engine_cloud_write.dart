import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/engine_detail_records.dart';

class EngineCloudWriteOperations {
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
          .collection('engineDetails')
          .doc('engineDetails');

  /// Create/overwrite engine details in Firestore (cloud-only).
  /// Uses a fixed doc id because there is one engine details record per vehicle.
  Future<String> insertEngineDetails(EngineDetailsCloudModel engine) async {
    final docRef = _doc(engine.userId, engine.vehicleCloudId);

    final cloudMap = engine.toMap()
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(cloudMap);
    return docRef.id; // 'engineDetails'
  }

  /// Update engine details in Firestore (cloud-only).
  Future<void> updateEngineDetails(EngineDetailsCloudModel engine) async {
    final docRef = _doc(engine.userId, engine.vehicleCloudId);

    final cloudMap = engine.toMap();

    await docRef.set(cloudMap, SetOptions(merge: true));
  }

  /// Delete engine details in Firestore (cloud-only).
  Future<void> deleteEngineDetails(EngineDetailsCloudModel engine) async {
    final docRef = _doc(engine.userId, engine.vehicleCloudId);
    await docRef.delete();
  }

  /// Fetch engine details doc for a vehicle (optional helper).
  Future<EngineDetailsCloudModel?> fetchEngineDetails(
    String userId,
    String vehicleCloudId,
  ) async {
    final snap = await _doc(userId, vehicleCloudId).get();
    if (!snap.exists) return null;

    return EngineDetailsCloudModel.fromJson(
      snap.id,
      {
        ...(snap.data() ?? {}),
        'userId': (snap.data() ?? {})['userId'] ?? userId,
        'vehicleCloudId':
            (snap.data() ?? {})['vehicleCloudId'] ?? vehicleCloudId,
      },
    );
  }
}