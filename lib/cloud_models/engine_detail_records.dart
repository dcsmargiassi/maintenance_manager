class EngineDetailsCloudModel {
  final String id; // Firestore document ID
  final String userId;
  final String vehicleCloudId;

  final String engineSize;
  final String cylinders;
  final String engineType;
  final String oilWeight;
  final String oilComposition;
  final String oilClass;
  final String oilFilter;
  final String engineFilter;

  EngineDetailsCloudModel({
    required this.id,
    required this.userId,
    required this.vehicleCloudId,
    required this.engineSize,
    required this.cylinders,
    required this.engineType,
    required this.oilWeight,
    required this.oilComposition,
    required this.oilClass,
    required this.oilFilter,
    required this.engineFilter,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleCloudId': vehicleCloudId,
      'engineSize': engineSize,
      'cylinders': cylinders,
      'engineType': engineType,
      'oilWeight': oilWeight,
      'oilComposition': oilComposition,
      'oilClass': oilClass,
      'oilFilter': oilFilter,
      'engineFilter': engineFilter,
    };
  }

  factory EngineDetailsCloudModel.fromMap(String id, Map<String, dynamic> map) {
    return EngineDetailsCloudModel(
      id: id,
      userId: map['userId'] ?? '',
      vehicleCloudId: map['vehicleCloudId'] ?? '',
      engineSize: map['engineSize'] ?? '',
      cylinders: map['cylinders'] ?? '',
      engineType: map['engineType'] ?? '',
      oilWeight: map['oilWeight'] ?? '',
      oilComposition: map['oilComposition'] ?? '',
      oilClass: map['oilClass'] ?? '',
      oilFilter: map['oilFilter'] ?? '',
      engineFilter: map['engineFilter'] ?? '',
    );
  }
}