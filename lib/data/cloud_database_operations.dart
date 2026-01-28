//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:maintenance_manager/data/database.dart';
//import 'package:maintenance_manager/models/battery_detail_records.dart';
//import 'package:maintenance_manager/models/engine_detail_records.dart';
//import 'package:maintenance_manager/models/exterior_detail_records.dart';
//import 'package:maintenance_manager/models/fuel_records.dart';
//import 'package:maintenance_manager/models/vehicle_information.dart';
//
//const bool enableVehicleCloudWrite = true;
//
// // Vehicle information table operation functions
//
//class VehicleCloudOperations {
//  final DatabaseRepository dbRepository = DatabaseRepository.instance;
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//  Future<String> createVehicle(VehicleInformationModel vehicle) async {
//    // Generate a new doc reference
//    final docRef = _firestore
//        .collection('users')
//        .doc(vehicle.userId)
//        .collection('vehicles')
//        .doc(); // auto ID
//
//    // Map the vehicle to cloud fields
//    final cloudMap = vehicle.toMap()
//      ..remove('vehicleId') // Firestore auto-doc ID
//      ..addAll({
//        'createdAt': FieldValue.serverTimestamp(),
//      });
//
//    await docRef.set(cloudMap);
//
//    return docRef.id;
//  }
//
//  Future<void> updateVehicle(VehicleInformationModel vehicle) async {
//    if (vehicle.cloudId == null) {
//    throw Exception('Vehicle cloudId is null — cannot update Firestore');
//  }
//
//  final docRef = _firestore
//      .collection('users')
//      .doc(vehicle.userId)
//      .collection('vehicles')
//      .doc(vehicle.cloudId);
//
//  final cloudMap = vehicle.toMap()
//    ..remove('vehicleId')
//    ..remove('cloudId')
//    ..remove('isCloudSynced')
//    ..removeWhere((k, v) => v == null);
//
// // debugPrint('🔥 Firestore update → ${docRef.path}');
// // debugPrint('🔥 Payload → $cloudMap');
//
//  await docRef.update(cloudMap);
//  }
//
//  Future<void> archiveVehicleById(int vehicleId, String userId, String date, String cloudId) async {
//    if (enableVehicleCloudWrite) {
//      await _firestore
//          .collection('users')
//          .doc(userId)
//          .collection('vehicles')
//          .doc(cloudId)
//          .update({'archived': 1, 'sellDate': date});
//    }
//
//    final db = await dbRepository.database;
//    await db.update(
//      'vehicleInformation',
//      {'archived': 1, 'sellDate': date, 'isCloudSynced': enableVehicleCloudWrite ? 1 : 0},
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//  }
//
//  Future<void> unarchiveVehicleById(int vehicleId, String userId, String cloudId) async {
//    if (enableVehicleCloudWrite) {
//      await _firestore
//          .collection('users')
//          .doc(userId)
//          .collection('vehicles')
//          .doc(cloudId)
//          .update({'archived': 0});
//    }
//
//    final db = await dbRepository.database;
//    await db.update(
//      'vehicleInformation',
//      {'archived': 0, 'isCloudSynced': enableVehicleCloudWrite ? 1 : 0},
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [vehicleId, userId],
//    );
//  }
//
//  Future<void> deleteVehicle(String userId, int vehicleId, String? cloudId) async {
//    final db = await dbRepository.database;
//
//    if (enableVehicleCloudWrite && cloudId != null) {
//      final vehicleDoc = _firestore
//          .collection('users')
//          .doc(userId)
//          .collection('vehicles')
//          .doc(cloudId);
//
//      // List of subcollections to delete
//      final subcollections = ['fuelRecords', 'engineDetails', 'batteryDetails', 'exteriorDetails'];
//
//      for (var sub in subcollections) {
//        final snapshot = await vehicleDoc.collection(sub).get();
//
//        for (var doc in snapshot.docs) {
//          await doc.reference.delete();
//        }
//      }
//
//      // Delete the vehicle document itself
//      await vehicleDoc.delete();
//    }
//
//    // Delete locally
//    await db.delete('fuelRecords', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
//    await db.delete('engineDetails', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
//    await db.delete('batteryDetails', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
//    await db.delete('exteriorDetails', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
//    await db.delete('vehicleInformation', where: 'vehicleId = ? AND userId = ?', whereArgs: [vehicleId, userId]);
//  }
//
//  Future<List<VehicleInformationModel>> getAllVehicles(String userId) async {
//    final snapshot = await _firestore.collection('users').doc(userId).collection('vehicles').get();
//
//    return snapshot.docs.map((doc) {
//      final data = doc.data()..['cloudId'] = doc.id;
//      return VehicleInformationModel.fromJson(data);
//    }).toList();
//  }
//
//  Future<VehicleInformationModel?> getVehicleById(String userId, String cloudId) async {
//    final doc = await _firestore.collection('users').doc(userId).collection('vehicles').doc(cloudId).get();
//    if (!doc.exists) return null;
//    final data = doc.data()!..['cloudId'] = doc.id;
//    return VehicleInformationModel.fromJson(data);
//  }
//}
//
// // Cloud fuel operations
//
//class FuelCloudOperations {
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  final DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  /// Create a fuel record in Firestore
//  Future<String> createFuelRecord(FuelRecords fuelRecord) async {
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [fuelRecord.vehicleId, fuelRecord.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//    final docRef = _firestore
//        .collection('users')
//        .doc(fuelRecord.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('fuelRecords')
//        .doc();
//
//    final cloudMap = fuelRecord.toMap()
//      ..remove('fuelRecordId') // Firestore auto-ID
//      ..addAll({
//        'createdAt': FieldValue.serverTimestamp(),
//      });
//
//    await docRef.set(cloudMap);
//
//    return docRef.id;
//  }
//
//  /// Update an existing fuel record in Firestore
//  Future<void> updateFuelRecord(FuelRecords fuelRecord) async {
//    if (fuelRecord.cloudId == null) {
//      throw Exception('Cannot update a cloud record without cloudId.');
//    }
//
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [fuelRecord.vehicleId, fuelRecord.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(fuelRecord.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('fuelRecords')
//        .doc(fuelRecord.cloudId);
//
//    final cloudMap = fuelRecord.toMap()
//      ..remove('fuelRecordId')
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await docRef.update(cloudMap);
//  }
//
//  /// Delete a fuel record from Firestore
//  Future<void> deleteFuelRecord(FuelRecords fuelRecord) async {
//    if (fuelRecord.cloudId == null) {
//      throw Exception('Cannot delete a cloud record without fuelRecord cloudId.');
//    }
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [fuelRecord.vehicleId, fuelRecord.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(fuelRecord.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('fuelRecords')
//        .doc(fuelRecord.cloudId);
//
//    await docRef.delete();
//  }
//
//  /// Fetch all fuel records for a user (optional for syncing)
//  Future<List<FuelRecords>> fetchAllFuelRecords(String userId) async {
//    final snapshot = await _firestore
//        .collection('users')
//        .doc(userId)
//        .collection('fuelRecords')
//        .get();
//
//    return snapshot.docs
//        .map((doc) => FuelRecords.fromMap({
//              ...doc.data(),
//              'cloudId': doc.id,
//              'isCloudSynced': 1,
//            }))
//        .toList();
//  }
//}
//
// // Cloud Engine Functions
//
//class EngineCloudOperations {
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  final DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  /// Insert engine details in Firestore
//  Future<String> insertEngineDetails(EngineDetailsModel engine) async {
//    if (engine.userId == null) {
//      throw Exception('Vehicle ID and User ID are required.');
//    }
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [engine.vehicleId, engine.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    // Create document reference
//    final docRef = _firestore
//        .collection('users')
//        .doc(engine.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('engineDetails')
//        .doc(); // auto-ID for engine record
//
//    final cloudMap = engine.toMap()
//      ..remove('engineDetailsId')
//      ..addAll({'createdAt': FieldValue.serverTimestamp()});
//
//    await docRef.set(cloudMap);
//    return docRef.id;
//  }
//
//  /// Update engine details in Firestore
//  Future<void> updateEngineDetails(EngineDetailsModel engine) async {
//    if (engine.cloudId == null) {
//      throw Exception('Cannot update cloud engine record without cloudId.');
//    }
//
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [engine.vehicleId, engine.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(engine.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('engineDetails')
//        .doc(engine.cloudId);
//
//    final cloudMap = engine.toMap()
//      ..remove('engineDetailsId')
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await docRef.set(cloudMap, SetOptions(merge: true));
//  }
//
//  /// Delete engine details in Firestore
//  Future<void> deleteEngineDetails(EngineDetailsModel engine) async {
//    if (engine.cloudId == null) {
//      throw Exception('Cannot delete cloud engine record without cloudId.');
//    }
//
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [engine.vehicleId, engine.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(engine.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('engineDetails')
//        .doc(engine.cloudId);
//
//    await docRef.delete();
//  }
//
//  Future<List<EngineDetailsModel>> fetchAllEngineDetails(String userId, String cloudVehicleId) async {
//    final snapshot = await _firestore
//        .collection('users')
//        .doc(userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('engineDetails')
//        .get();
//
//    return snapshot.docs.map((doc) => EngineDetailsModel.fromMap({
//      ...doc.data(),
//      'cloudId': doc.id,
//      'isCloudSynced': 1,
//    })).toList();
//  }
//}
//
// // Cloud Battery Functions
//
//class BatteryCloudOperations {
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  final DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  /// Insert a battery detail into Firestore
//  Future<String> insertBatteryDetails(BatteryDetailsModel battery) async {
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [battery.vehicleId, battery.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(battery.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('batteryDetails')
//        .doc();
//
//    final cloudMap = battery.toMap()
//      ..remove('batteryDetailsId')
//      ..addAll({
//        'createdAt': FieldValue.serverTimestamp(),
//      });
//
//    await docRef.set(cloudMap);
//    return docRef.id;
//  }
//
//  /// Update a battery detail in Firestore
//  Future<void> updateBatteryDetails(BatteryDetailsModel battery) async {
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [battery.vehicleId, battery.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//
//    if (battery.cloudId == null) {
//      throw Exception('Cannot update a cloud record without cloudId or vehicleCloudId.');
//    }
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(battery.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('batteryDetails')
//        .doc(battery.cloudId);
//
//    final cloudMap = battery.toMap()
//      ..remove('batteryDetailsId')
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await docRef.update(cloudMap);
//  }
//
//  /// Delete a battery detail from Firestore
//  Future<void> deleteBatteryDetails(BatteryDetailsModel battery) async {
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [battery.vehicleId, battery.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//
//    if (battery.cloudId == null) {
//      throw Exception('Cannot delete a cloud record without cloudId or vehicleCloudId.');
//    }
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(battery.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('batteryDetails')
//        .doc(battery.cloudId);
//
//    await docRef.delete();
//  }
//}
//
// // Cloud Exterior Functions
//
//class ExteriorCloudOperations {
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  final DatabaseRepository dbRepository = DatabaseRepository.instance;
//
//  /// Insert exterior details into Firestore
//  Future<String> insertExteriorDetails(ExteriorDetailsModel exterior) async {
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [exterior.vehicleId, exterior.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(exterior.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('exteriorDetails')
//        .doc();
//
//    final cloudMap = exterior.toMap()
//      ..remove('exteriorDetailsId')
//      ..addAll({
//        'createdAt': FieldValue.serverTimestamp(),
//      });
//
//    await docRef.set(cloudMap);
//    return docRef.id;
//  }
//
//  /// Update exterior details in Firestore
//  Future<void> updateExteriorDetails(ExteriorDetailsModel exterior) async {
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [exterior.vehicleId, exterior.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    if (exterior.cloudId == null) {
//      throw Exception('Cannot update a cloud record without cloudId or vehicleCloudId.');
//    }
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(exterior.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('exteriorDetails')
//        .doc(exterior.cloudId);
//
//    final cloudMap = exterior.toMap()
//      ..remove('exteriorDetailsId')
//      ..remove('cloudId')
//      ..remove('isCloudSynced');
//
//    await docRef.update(cloudMap);
//  }
//
//  /// Delete exterior details from Firestore
//  Future<void> deleteExteriorDetails(ExteriorDetailsModel exterior) async {
//
//    // Get vehicle cloudId
//    final db = await dbRepository.database;
//    final vehicleResult = await db.query(
//      'vehicleInformation',
//      columns: ['cloudId'],
//      where: 'vehicleId = ? AND userId = ?',
//      whereArgs: [exterior.vehicleId, exterior.userId],
//    );
//
//    if (vehicleResult.isEmpty || vehicleResult.first['cloudId'] == null) {
//      throw Exception('Vehicle cloudId not found. Make sure vehicle is synced to the cloud.');
//    }
//
//    final cloudVehicleId = vehicleResult.first['cloudId'] as String;
//
//    if (exterior.cloudId == null) {
//      throw Exception('Cannot delete a cloud record without cloudId or vehicleCloudId.');
//    }
//
//    final docRef = _firestore
//        .collection('users')
//        .doc(exterior.userId)
//        .collection('vehicles')
//        .doc(cloudVehicleId)
//        .collection('exteriorDetails')
//        .doc(exterior.cloudId);
//
//    await docRef.delete();
//  }
//}
//