class FuelRecordCloudModel {
  final String? id; // Firestore document ID
  final String userId;
  final String vehicleCloudId;

  final double fuelAmount;
  final double fuelPrice;
  final double refuelCost; // auto-calculated
  final double odometerAmount;
  final String date;

  FuelRecordCloudModel({
    this.id,
    required this.userId,
    required this.vehicleCloudId,
    required this.fuelAmount,
    required this.fuelPrice,
    required this.refuelCost,
    required this.odometerAmount,
    required this.date,
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
    };
  }

  factory FuelRecordCloudModel.fromMap(String id, Map<String, dynamic> map) {
    return FuelRecordCloudModel(
      id: id,
      userId: (map['userId'] ?? ''),
      vehicleCloudId: (map['vehicleCloudId'] ?? ''),
      fuelAmount: (map['fuelAmount'] ?? 0).toDouble(),
      fuelPrice: (map['fuelPrice'] ?? 0).toDouble(),
      refuelCost: (map['refuelCost'] ?? 0).toDouble(),
      odometerAmount: (map['odometerAmount'] ?? 0).toDouble(),
      date: map['date'] ?? '',
    );
  }
}