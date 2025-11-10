import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addVehicle(Map<String, dynamic> vehicleData) async {
    await _db.collection('vehicles').add(vehicleData);
  }

  Future<void> updateVehicle(String docId, Map<String, dynamic> updatedData) async {
    await _db.collection('vehicles').doc(docId).update(updatedData);
  }

  Future<void> deleteVehicle(String docId) async {
    await _db.collection('vehicles').doc(docId).delete();
  }

  Future<List<Map<String, dynamic>>> getVehicles(String userId) async {
    final snapshot = await _db
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((d) => d.data()).toList();
  }
}