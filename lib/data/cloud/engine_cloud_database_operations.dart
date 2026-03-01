import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';

class EngineCloudOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseRepository dbRepository = DatabaseRepository.instance;

  /// Insert engine details in Firestore
  Future<String> insertEngineDetails(EngineDetailsModel engine) async {
    if (engine.userId == null) {
      throw Exception('Vehicle ID and User ID are required.');
    }

    // Get vehicle cloudId
    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [engine.vehicleId, engine.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    // Create document reference
    final docRef = _firestore
        .collection('users')
        .doc(engine.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('engineDetails')
        .doc(); // auto-ID for engine record

    final cloudMap = engine.toMap()
      ..remove('engineDetailsId')
      ..addAll({'createdAt': FieldValue.serverTimestamp()});

    await docRef.set(cloudMap);
    return docRef.id;
  }

  /// Update engine details in Firestore
  Future<void> updateEngineDetails(EngineDetailsModel engine) async {
    if (engine.cloudId == null) {
      throw Exception('Cannot update cloud engine record without cloudId.');
    }

    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [engine.vehicleId, engine.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    final docRef = _firestore
        .collection('users')
        .doc(engine.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('engineDetails')
        .doc(engine.cloudId);

    final cloudMap = engine.toMap()
      ..remove('engineDetailsId')
      ..remove('cloudId')
      ..remove('isCloudSynced');

    await docRef.set(cloudMap, SetOptions(merge: true));
  }

  /// Delete engine details in Firestore
  Future<void> deleteEngineDetails(EngineDetailsModel engine) async {
    if (engine.cloudId == null) {
      throw Exception('Cannot delete cloud engine record without cloudId.');
    }

    final db = await dbRepository.database;
    final vehicleResult = await db.query(
      'vehicleInformation',
      columns: ['cloudId'],
      where: 'vehicleId = ? AND userId = ?',
      whereArgs: [engine.vehicleId, engine.userId],
    );

    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
      throw Exception('Vehicle cloudId not found.');
    }

    final cloudVehicleId = vehicleResult.first['cloudId'] as String;

    final docRef = _firestore
        .collection('users')
        .doc(engine.userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('engineDetails')
        .doc(engine.cloudId);

    await docRef.delete();
  }

  Future<List<EngineDetailsModel>> fetchAllEngineDetails(String userId, String cloudVehicleId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('vehicles')
        .doc(cloudVehicleId)
        .collection('engineDetails')
        .get();

    return snapshot.docs.map((doc) => EngineDetailsModel.fromMap({
      ...doc.data(),
      'cloudId': doc.id,
      'isCloudSynced': 1,
    })).toList();
  }
}