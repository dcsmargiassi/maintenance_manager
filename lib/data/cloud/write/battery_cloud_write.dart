import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/battery_detail_records.dart';

class BatteryCloudWriteOperations {
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
          .collection('batteryDetails')
          .doc('batteryDetails');

  /// Create/overwrite battery details in Firestore (cloud-only).
  /// Uses a fixed doc id because there is one battery details record per vehicle.
  Future<String> insertBatteryDetails(BatteryDetailsCloudModel battery) async {
    final docRef = _doc(battery.userId, battery.vehicleCloudId);

    final cloudMap = battery.toMap()
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(cloudMap);
    return docRef.id; // 'batteryDetails'
  }

  /// Update battery details in Firestore (cloud-only).
  Future<void> updateBatteryDetails(BatteryDetailsCloudModel battery) async {
    final docRef = _doc(battery.userId, battery.vehicleCloudId);

    final cloudMap = battery.toMap();

    await docRef.update(cloudMap);
  }

  /// Delete battery details from Firestore (cloud-only).
  Future<void> deleteBatteryDetails(BatteryDetailsCloudModel battery) async {
    final docRef = _doc(battery.userId, battery.vehicleCloudId);
    await docRef.delete();
  }

  /// Fetch battery details doc for a vehicle.
  Future<BatteryDetailsCloudModel?> fetchBatteryDetails(
    String userId,
    String vehicleCloudId,
  ) async {
    final snap = await _doc(userId, vehicleCloudId).get();
    if (!snap.exists) return null;

    return BatteryDetailsCloudModel.fromJson(
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