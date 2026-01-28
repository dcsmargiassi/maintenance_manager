import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/exterior_detail_records.dart';

class ExteriorCloudOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseRepository dbRepository = DatabaseRepository.instance;

  /// Insert exterior details into Firestore
  Future<String> insertExteriorDetails(ExteriorDetailsModel exterior) async {

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [exterior.vehicleId, exterior.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    final docRef = _firestore
        .collection('users')
        .doc(exterior.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('exteriorDetails')
        .doc();

    final cloudMap = exterior.toMap()
      ..remove('exteriorDetailsId')
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(cloudMap);
    return docRef.id;
  }

  /// Update exterior details in Firestore
  Future<void> updateExteriorDetails(ExteriorDetailsModel exterior) async {

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [exterior.vehicleId, exterior.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    if (exterior.cloudId == null) {
      throw Exception('Cannot update a cloud record without cloudId or vehicleCloudId.');
    }

    final docRef = _firestore
        .collection('users')
        .doc(exterior.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('exteriorDetails')
        .doc(exterior.cloudId);

    final cloudMap = exterior.toMap()
      ..remove('exteriorDetailsId')
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await docRef.update(cloudMap);
  }

  /// Delete exterior details from Firestore
  Future<void> deleteExteriorDetails(ExteriorDetailsModel exterior) async {

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [exterior.vehicleId, exterior.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    if (exterior.cloudId == null) {
      throw Exception('Cannot delete a cloud record without cloudId or vehicleCloudId.');
    }

    final docRef = _firestore
        .collection('users')
        .doc(exterior.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('exteriorDetails')
        .doc(exterior.cloudId);

    await docRef.delete();
  }
}
