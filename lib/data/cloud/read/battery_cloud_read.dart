import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/battery_detail_records.dart';

class BatteryCloudReadOperations {
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
          .doc('batteryDetails'); // fixed doc id per vehicle

  Future<BatteryDetailsCloudModel?> getBatteryDetails(
    String userId,
    String vehicleCloudId,
  ) async {
    final snap = await _doc(userId, vehicleCloudId).get();
    if (!snap.exists) return null;

    final data = snap.data() ?? {};

    return BatteryDetailsCloudModel.fromJson(
      snap.id, // 'batteryDetails'
      {
        ...data,
        'userId': data['userId'] ?? userId,
        'vehicleCloudId': data['vehicleCloudId'] ?? vehicleCloudId,
      },
    );
  }

  Stream<BatteryDetailsCloudModel?> watchBatteryDetails(
    String userId,
    String vehicleCloudId,
  ) {
    return _doc(userId, vehicleCloudId).snapshots().map((snap) {
      if (!snap.exists) return null;

      final data = snap.data() ?? {};
      return BatteryDetailsCloudModel.fromJson(
        snap.id,
        {
          ...data,
          'userId': data['userId'] ?? userId,
          'vehicleCloudId': data['vehicleCloudId'] ?? vehicleCloudId,
        },
      );
    });
  }
}