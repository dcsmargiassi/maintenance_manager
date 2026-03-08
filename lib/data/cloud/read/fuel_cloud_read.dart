import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/fuel_detail_records.dart';

class FuelRecordsPage {
  final List<FuelRecordCloudModel> records;
  final DocumentSnapshot<Map<String, dynamic>>? lastDoc;

  FuelRecordsPage({
    required this.records,
    required this.lastDoc,
  });
}

class FuelCloudReadOperations {
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
          .collection('fuelRecords');

  /// --------- Core: paged list (25 at a time) ---------
  Future<FuelRecordsPage> getFuelRecordsPage({
    required String userId,
    required String vehicleCloudId,
    int limit = 25,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> q = _col(userId, vehicleCloudId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();

    final records = snap.docs
        .map((d) => FuelRecordCloudModel.fromMap(
              d.id,
              {
                ...d.data(),
                // ensure these exist even if you don't store them in doc
                'userId': d.data()['userId'] ?? userId,
                'vehicleCloudId': d.data()['vehicleCloudId'] ?? vehicleCloudId,
              },
            ))
        .toList();

    final last = snap.docs.isNotEmpty ? snap.docs.last : null;
    return FuelRecordsPage(records: records, lastDoc: last);
  }

  /// Optional: stream latest N (NOT infinite scroll, but good for “recent” widgets)
  Stream<List<FuelRecordCloudModel>> watchLatestFuelRecords({
    required String userId,
    required String vehicleCloudId,
    int limit = 25,
  }) {
    return _col(userId, vehicleCloudId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => FuelRecordCloudModel.fromMap(
                  d.id,
                  {
                    ...d.data(),
                    'userId': d.data()['userId'] ?? userId,
                    'vehicleCloudId': d.data()['vehicleCloudId'] ?? vehicleCloudId,
                  },
                ))
            .toList());
  }

  /// --------- “Get all” equivalents ---------
  ///
  /// In cloud world, you generally should NOT fetch all for large datasets.
  /// Keep this only for export/sync/debug.
  Future<List<FuelRecordCloudModel>> fetchAllFuelRecordsForVehicle({
    required String userId,
    required String vehicleCloudId,
  }) async {
    final snap = await _col(userId, vehicleCloudId)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((d) => FuelRecordCloudModel.fromMap(
              d.id,
              {
                ...d.data(),
                'userId': d.data()['userId'] ?? userId,
                'vehicleCloudId': d.data()['vehicleCloudId'] ?? vehicleCloudId,
              },
            ))
        .toList();
  }

  /// --------- Single record ---------
  Future<FuelRecordCloudModel?> getFuelRecordByCloudId({
    required String userId,
    required String vehicleCloudId,
    required String fuelRecordCloudId,
  }) async {
    final doc = await _col(userId, vehicleCloudId).doc(fuelRecordCloudId).get();
    if (!doc.exists) return null;

    return FuelRecordCloudModel.fromMap(
      doc.id,
      {
        ...(doc.data() ?? {}),
        'userId': (doc.data() ?? {})['userId'] ?? userId,
        'vehicleCloudId': (doc.data() ?? {})['vehicleCloudId'] ?? vehicleCloudId,
      },
    );
  }

  /// --------- Month / Year range helpers ---------
  ///
  /// These replace local string date queries and raw SUM SQL.
  /// Uses createdAt (Timestamp).
  Future<List<FuelRecordCloudModel>> getFuelRecordsByMonth({
    required String userId,
    required String vehicleCloudId,
    required int year,
    required int month,
  }) async {
    final start = DateTime(year, month, 1);
    final endExclusive = (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

    return _getFuelRecordsInRange(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      startInclusive: start,
      endExclusive: endExclusive,
    );
  }

  Future<List<FuelRecordCloudModel>> getFuelRecordsByYear({
    required String userId,
    required String vehicleCloudId,
    required int year,
  }) async {
    final start = DateTime(year, 1, 1);
    final endExclusive = DateTime(year + 1, 1, 1);

    return _getFuelRecordsInRange(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      startInclusive: start,
      endExclusive: endExclusive,
    );
  }

  Future<double> getTotalFuelCostByMonth({
    required String userId,
    required String vehicleCloudId,
    required int year,
    required int month,
  }) async {
    final records = await getFuelRecordsByMonth(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      year: year,
      month: month,
    );
    return records.fold<double>(
      0.0,
      (currentTotal, record) => currentTotal + record.refuelCost,
    );
  }

  Future<double> getTotalFuelCostByYear({
    required String userId,
    required String vehicleCloudId,
    required int year,
  }) async {
    final records = await getFuelRecordsByYear(
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      year: year,
    );
    return records.fold<double>(
      0.0,
      (currentTotal, record) => currentTotal + record.refuelCost,
    );
  }

  // --------- private range query ---------

  Future<List<FuelRecordCloudModel>> _getFuelRecordsInRange({
    required String userId,
    required String vehicleCloudId,
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final startDate = startInclusive.toIso8601String().split('T').first;
    final endDate = endExclusive.toIso8601String().split('T').first;

    // Utilizing date field
    final snap = await _col(userId, vehicleCloudId)
      .where('date', isGreaterThanOrEqualTo: startDate)
      .where('date', isLessThan: endDate)
      .orderBy('date', descending: true)
      .get();
      // utilizing CreatedAt field
    //final snap = await _col(userId, vehicleCloudId)
    //    .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startInclusive))
    //    .where('createdAt', isLessThan: Timestamp.fromDate(endExclusive))
    //    .orderBy('createdAt', descending: true)
    //    .get();

    return snap.docs
      .map((d) => FuelRecordCloudModel.fromMap(
            d.id,
            {
              ...d.data(),
              'userId': d.data()['userId'] ?? userId,
              'vehicleCloudId': d.data()['vehicleCloudId'] ?? vehicleCloudId,
            },
          ))
      .toList();
  }
}