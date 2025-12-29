class BatteryDetailsCloudModel {
  final String id; // Firestore document ID
  final String userId;
  final String vehicleCloudId; // Reference to cloud vehicle
  
  final String? batterySeriesType;
  final String? batterySize;
  final double? coldCrankAmps;

  BatteryDetailsCloudModel({
    required this.id,
    required this.userId,
    required this.vehicleCloudId,
    this.batterySeriesType,
    this.batterySize,
    this.coldCrankAmps,
  });

  // Convert to a Firestore map
  Map<String, dynamic> toMap() {
    return {
      'vehicleCloudId': vehicleCloudId,
      'batterySeriesType': batterySeriesType,
      'batterySize': batterySize,
      'coldCrankAmps': coldCrankAmps,
    };
  }

  // Create from Firestore map + doc ID
  factory BatteryDetailsCloudModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return BatteryDetailsCloudModel(
      id: id,
      userId: '',
      vehicleCloudId: map['vehicleCloudId'],
      batterySeriesType: map['batterySeriesType'],
      batterySize: map['batterySize'],
      coldCrankAmps: (map['coldCrankAmps'] as num?)?.toDouble(),
    );
  }
}