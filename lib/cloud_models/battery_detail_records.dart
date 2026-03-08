class BatteryDetailsCloudModel {
  final String cloudId; // Firestore document ID
  final String userId;
  final String vehicleCloudId; // Reference to cloud vehicle
  
  final String? batterySeriesType;
  final String? batterySize;
  final double? coldCrankAmps;

  BatteryDetailsCloudModel({
    required this.cloudId,
    required this.userId,
    required this.vehicleCloudId,
    this.batterySeriesType,
    this.batterySize,
    this.coldCrankAmps,
  });

  // Convert to a Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleCloudId': vehicleCloudId,
      'batterySeriesType': batterySeriesType,
      'batterySize': batterySize,
      'coldCrankAmps': coldCrankAmps,
    };
  }

  // Create from Firestore map + doc ID
  factory BatteryDetailsCloudModel.fromMap(
    String cloudId,
    Map<String, dynamic> map,
  ) {
    return BatteryDetailsCloudModel(
      cloudId: cloudId,
      userId: '',
      vehicleCloudId: map['vehicleCloudId'],
      batterySeriesType: map['batterySeriesType'],
      batterySize: map['batterySize'],
      coldCrankAmps: (map['coldCrankAmps'] as num?)?.toDouble(),
    );
  }

  factory BatteryDetailsCloudModel.fromJson(
    String cloudId,
    Map<String, dynamic> data,
  ) {
    return BatteryDetailsCloudModel(
      cloudId: cloudId,
      userId: data['userId'] ?? '',
      vehicleCloudId: data['vehicleCloudId'] ?? '',
      batterySeriesType: data['batterySeriesType'],
      batterySize: data['batterySize'],
      coldCrankAmps: (data['coldCrankAmps'] as num?)?.toDouble(),
    );
  }
}