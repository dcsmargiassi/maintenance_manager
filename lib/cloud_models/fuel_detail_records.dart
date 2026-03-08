import 'package:cloud_firestore/cloud_firestore.dart';

class FuelRecordCloudModel {
  final String? cloudId; // Firestore document ID
  final String userId;
  final String vehicleCloudId;

  final double fuelAmount;
  final double fuelPrice;
  final double refuelCost; // auto-calculated
  final double odometerAmount;
  final String date;
  final Timestamp? createdAt;

  FuelRecordCloudModel({
    this.cloudId,
    required this.userId,
    required this.vehicleCloudId,
    required this.fuelAmount,
    required this.fuelPrice,
    required this.refuelCost,
    required this.odometerAmount,
    required this.date,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleCloudId': vehicleCloudId,
      'fuelAmount': fuelAmount,
      'fuelPrice': fuelPrice,
      'refuelCost': refuelCost,
      'odometerAmount': odometerAmount,
      'date': date,
      'createdAt': createdAt, // if null (legacy) firestore will ignore
    };
  }

  factory FuelRecordCloudModel.fromMap(String cloudId, Map<String, dynamic> map) {
    return FuelRecordCloudModel(
      cloudId: cloudId,
      userId: (map['userId'] ?? ''),
      vehicleCloudId: (map['vehicleCloudId'] ?? ''),
      fuelAmount: (map['fuelAmount'] ?? 0).toDouble(),
      fuelPrice: (map['fuelPrice'] ?? 0).toDouble(),
      refuelCost: (map['refuelCost'] ?? 0).toDouble(),
      odometerAmount: (map['odometerAmount'] ?? 0).toDouble(),
      date: map['date'] ?? '',
      createdAt: map['createdAt'] as Timestamp?,
    );
  }
}