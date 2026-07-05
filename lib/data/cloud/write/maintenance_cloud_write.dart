import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/maintenance_detail_records.dart';

class MaintenanceCloudWriteOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(
    String userId,
    String vehicleCloudId,
  ) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleCloudId)
          .collection('maintenanceRecords');

  /// Create a maintenance record in Firestore (cloud-only)
  Future<String> createMaintenanceRecord(
    MaintenanceRecordCloudModel record,
  ) async {
    final docRef = _col(record.userId, record.vehicleCloudId).doc();

    final map = record.toMap()
      ..removeWhere((key, value) => value == null)
      ..remove('createdAt')
      ..addAll({
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

    await docRef.set(map);
    return docRef.id;
  }

  /// Update an existing maintenance record in Firestore (cloud-only)
  Future<void> updateMaintenanceRecord(
    MaintenanceRecordCloudModel record,
  ) async {
    if (record.id.isEmpty) {
      throw Exception('Cannot update a maintenance record without id.');
    }

    final docRef = _col(record.userId, record.vehicleCloudId).doc(record.id);

    final map = record.toMap()
      ..remove('createdAt')
      ..removeWhere((key, value) => value == null)
      ..addAll({
        'updatedAt': FieldValue.serverTimestamp(),
      });

    await docRef.update(map);
  }

  /// Patch an existing maintenance record in Firestore (cloud-only)
  Future<void> updateMaintenanceRecordPatch({
    required String userId,
    required String vehicleCloudId,
    required String recordId,
    required Map<String, dynamic> patch,
  }) async {
    if (recordId.isEmpty) {
      throw Exception('Cannot update maintenance record without recordId.');
    }

    final cleanedPatch = Map<String, dynamic>.from(patch)
      ..removeWhere((key, value) => value == null)
      ..remove('createdAt')
      ..addAll({
        'updatedAt': FieldValue.serverTimestamp(),
      });

    await _col(userId, vehicleCloudId).doc(recordId).update(cleanedPatch);
  }

  /// Add one attachment metadata map to the maintenance record.
  ///
  /// Example attachment:
  /// {
  ///   'url': 'https://...',
  ///   'type': 'receipt',
  ///   'fileName': 'receipt.jpg',
  ///   'uploadedAt': Timestamp.now(),
  /// }
  Future<void> addAttachment({
    required String userId,
    required String vehicleCloudId,
    required String recordId,
    required Map<String, dynamic> attachment,
  }) async {
    if (recordId.isEmpty) {
      throw Exception('Cannot add attachment without recordId.');
    }

    final cleanedAttachment = Map<String, dynamic>.from(attachment)
      ..removeWhere((key, value) => value == null);

    await _col(userId, vehicleCloudId).doc(recordId).update({
      'attachments': FieldValue.arrayUnion([cleanedAttachment]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove one attachment metadata map from the maintenance record.
  ///
  /// Note: FieldValue.arrayRemove requires the object to match exactly.
  Future<void> removeAttachment({
    required String userId,
    required String vehicleCloudId,
    required String recordId,
    required Map<String, dynamic> attachment,
  }) async {
    if (recordId.isEmpty) {
      throw Exception('Cannot remove attachment without recordId.');
    }

    await _col(userId, vehicleCloudId).doc(recordId).update({
      'attachments': FieldValue.arrayRemove([attachment]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Replace all attachments on a maintenance record.
  ///
  /// This is often easier than arrayRemove if attachment metadata changes.
  Future<void> replaceAttachments({
    required String userId,
    required String vehicleCloudId,
    required String recordId,
    required List<Map<String, dynamic>> attachments,
  }) async {
    if (recordId.isEmpty) {
      throw Exception('Cannot replace attachments without recordId.');
    }

    await _col(userId, vehicleCloudId).doc(recordId).update({
      'attachments': attachments,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a maintenance record from Firestore (cloud-only)
  Future<void> deleteMaintenanceRecord(
    MaintenanceRecordCloudModel record,
  ) async {
    if (record.id.isEmpty) {
      throw Exception('Cannot delete maintenance record without a valid id.');
    }

    await _col(record.userId, record.vehicleCloudId).doc(record.id).delete();
  }

  /// Delete all maintenance records for a specific vehicle (cloud-only)
  Future<void> deleteAllMaintenanceRecordsByVehicleCloudId(
    String userId,
    String vehicleCloudId,
  ) async {
    final snapshot = await _col(userId, vehicleCloudId).get();

    // Firestore batch limit is 500 operations. This keeps it safe.
    WriteBatch batch = _firestore.batch();
    var operationCount = 0;

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
      operationCount++;

      if (operationCount == 450) {
        await batch.commit();
        batch = _firestore.batch();
        operationCount = 0;
      }
    }

    if (operationCount > 0) {
      await batch.commit();
    }
  }
}
