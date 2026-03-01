import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';

class BatteryCloudOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseRepository dbRepository = DatabaseRepository.instance;

  /// Insert a battery detail into Firestore
  Future<String> insertBatteryDetails(BatteryDetailsModel battery) async {

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [battery.vehicleId, battery.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    final docRef = _firestore
        .collection('users')
        .doc(battery.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('batteryDetails')
        .doc();

    final cloudMap = battery.toMap()
      ..remove('batteryDetailsId')
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(cloudMap);
    return docRef.id;
  }

  /// Update a battery detail in Firestore
  Future<void> updateBatteryDetails(BatteryDetailsModel battery) async {

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [battery.vehicleId, battery.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;


    if (battery.cloudId == null) {
      throw Exception('Cannot update a cloud record without cloudId or vehicleCloudId.');
    }

    final docRef = _firestore
        .collection('users')
        .doc(battery.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('batteryDetails')
        .doc(battery.cloudId);

    final cloudMap = battery.toMap()
      ..remove('batteryDetailsId')
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await docRef.update(cloudMap);
  }

  /// Delete a battery detail from Firestore
  Future<void> deleteBatteryDetails(BatteryDetailsModel battery) async {

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [battery.vehicleId, battery.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;


    if (battery.cloudId == null) {
      throw Exception('Cannot delete a cloud record without cloudId or vehicleCloudId.');
    }

    final docRef = _firestore
        .collection('users')
        .doc(battery.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('batteryDetails')
        .doc(battery.cloudId);

    await docRef.delete();
  }
}
