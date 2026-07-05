import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/maintenance_detail_records.dart';

class MaintenanceRecordsPage {
  final List<MaintenanceRecordCloudModel> records;
  final DocumentSnapshot<Map<String, dynamic>>? lastDoc;

  MaintenanceRecordsPage({
    required this.records,
    required this.lastDoc,
  });
}

class MaintenanceCloudReadOperations {
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

  Future<MaintenanceRecordsPage> getMaintenanceRecordsPage({
    required String userId,
    required String vehicleCloudId,
    int limit = 25,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    String orderByField = 'createdAt',
    bool descending = true,
    String? maintenanceType,
  }) async {
    Query<Map<String, dynamic>> q = _col(userId, vehicleCloudId);

    if (maintenanceType != null && maintenanceType.isNotEmpty) {
      q = q.where('maintenanceType', isEqualTo: maintenanceType);
    }

    q = q.orderBy(orderByField, descending: descending).limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    final records = _mapDocs(
      docs: snap.docs,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
    );

    final last = snap.docs.isNotEmpty ? snap.docs.last : null;

    return MaintenanceRecordsPage(
      records: records,
      lastDoc: last,
    );
  }

  Stream<List<MaintenanceRecordCloudModel>> watchLatestMaintenanceRecords({
    required String userId,
    required String vehicleCloudId,
    int limit = 25,
  }) {
    return _col(userId, vehicleCloudId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => _mapDocs(
            docs: snap.docs,
            userId: userId,
            vehicleCloudId: vehicleCloudId,
          ),
        );
  }

  Future<List<MaintenanceRecordCloudModel>>
      fetchAllMaintenanceRecordsForVehicle({
    required String userId,
    required String vehicleCloudId,
    String orderByField = 'createdAt',
    bool descending = true,
  }) async {
    final snap = await _col(userId, vehicleCloudId)
        .orderBy(orderByField, descending: descending)
        .get();

    return _mapDocs(
      docs: snap.docs,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
    );
  }

  Future<MaintenanceRecordCloudModel?> getMaintenanceRecordByCloudId({
    required String userId,
    required String vehicleCloudId,
    required String maintenanceRecordCloudId,
  }) async {
    final doc =
        await _col(userId, vehicleCloudId).doc(maintenanceRecordCloudId).get();

    if (!doc.exists) return null;

    return MaintenanceRecordCloudModel.fromMap(
      doc.id,
      {
        ...(doc.data() ?? {}),
        'userId': (doc.data() ?? {})['userId'] ?? userId,
        'vehicleCloudId':
            (doc.data() ?? {})['vehicleCloudId'] ?? vehicleCloudId,
      },
    );
  }

  Future<List<MaintenanceRecordCloudModel>> getMaintenanceRecordsByType({
    required String userId,
    required String vehicleCloudId,
    required String maintenanceType,
    String orderByField = 'createdAt',
    bool descending = true,
  }) async {
    final snap = await _col(userId, vehicleCloudId)
        .where('maintenanceType', isEqualTo: maintenanceType)
        .orderBy(orderByField, descending: descending)
        .get();

    return _mapDocs(
      docs: snap.docs,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
    );
  }

  Future<List<MaintenanceRecordCloudModel>> getMaintenanceRecordsByMonth({
    required String userId,
    required String vehicleCloudId,
    required int year,
    required int month,
  }) async {
    final start = DateTime(year, month, 1);
    final endExclusive =
        month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

    return _getMaintenanceRecordsInRange(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      startInclusive: start,
      endExclusive: endExclusive,
    );
  }

  Future<List<MaintenanceRecordCloudModel>> getMaintenanceRecordsByYear({
    required String userId,
    required String vehicleCloudId,
    required int year,
  }) async {
    final start = DateTime(year, 1, 1);
    final endExclusive = DateTime(year + 1, 1, 1);

    return _getMaintenanceRecordsInRange(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      startInclusive: start,
      endExclusive: endExclusive,
    );
  }

  Future<double> getTotalMaintenanceCostByMonth({
    required String userId,
    required String vehicleCloudId,
    required int year,
    required int month,
  }) async {
    final records = await getMaintenanceRecordsByMonth(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      year: year,
      month: month,
    );

    return records.fold<double>(
      0.0,
      (total, record) => total + record.totalCost,
    );
  }

  Future<double> getTotalMaintenanceCostByYear({
    required String userId,
    required String vehicleCloudId,
    required int year,
  }) async {
    final records = await getMaintenanceRecordsByYear(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      year: year,
    );

    return records.fold<double>(
      0.0,
      (total, record) => total + record.totalCost,
    );
  }

  List<MaintenanceRecordCloudModel> searchMaintenanceRecords({
    required List<MaintenanceRecordCloudModel> records,
    required String query,
  }) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return records;

    return records.where((record) {
      final title = record.title.toLowerCase();
      final type = record.maintenanceType.toLowerCase();
      final shop = (record.shopName ?? '').toLowerCase();
      final notes = (record.notes ?? '').toLowerCase();

      final detailsText = record.details.entries
          .map((e) => '${e.key} ${e.value}')
          .join(' ')
          .toLowerCase();

      return title.contains(q) ||
          type.contains(q) ||
          shop.contains(q) ||
          notes.contains(q) ||
          detailsText.contains(q);
    }).toList();
  }

  Future<List<MaintenanceRecordCloudModel>> _getMaintenanceRecordsInRange({
    required String userId,
    required String vehicleCloudId,
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final startDate = startInclusive.toIso8601String().split('T').first;
    final endDate = endExclusive.toIso8601String().split('T').first;

    final snap = await _col(userId, vehicleCloudId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThan: endDate)
        .orderBy('date', descending: true)
        .get();

    return _mapDocs(
      docs: snap.docs,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
    );
  }

  List<MaintenanceRecordCloudModel> _mapDocs({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    required String userId,
    required String vehicleCloudId,
  }) {
    return docs
        .map(
          (d) => MaintenanceRecordCloudModel.fromMap(
            d.id,
            {
              ...d.data(),
              'userId': d.data()['userId'] ?? userId,
              'vehicleCloudId': d.data()['vehicleCloudId'] ?? vehicleCloudId,
            },
          ),
        )
        .toList();
  }
}
