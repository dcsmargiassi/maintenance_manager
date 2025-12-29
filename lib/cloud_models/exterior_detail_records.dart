class ExteriorDetailsCloudModel {
  final String id; // Firestore document ID
  final String userId;
  final String vehicleCloudId;

  final String driverWindshieldWiper;
  final String passengerWindshieldWiper;
  final String rearWindshieldWiper;
  final String headlampHighBeam;
  final String headlampLowBeam;
  final String turnLamp;
  final String backupLamp;
  final String fogLamp;
  final String brakeLamp;
  final String licensePlateLamp;

  ExteriorDetailsCloudModel({
    required this.id,
    required this.userId,
    required this.vehicleCloudId,
    required this.driverWindshieldWiper,
    required this.passengerWindshieldWiper,
    required this.rearWindshieldWiper,
    required this.headlampHighBeam,
    required this.headlampLowBeam,
    required this.turnLamp,
    required this.backupLamp,
    required this.fogLamp,
    required this.brakeLamp,
    required this.licensePlateLamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleCloudId': vehicleCloudId,
      'driverWindshieldWiper': driverWindshieldWiper,
      'passengerWindshieldWiper': passengerWindshieldWiper,
      'rearWindshieldWiper': rearWindshieldWiper,
      'headlampHighBeam': headlampHighBeam,
      'headlampLowBeam': headlampLowBeam,
      'turnLamp': turnLamp,
      'backupLamp': backupLamp,
      'fogLamp': fogLamp,
      'brakeLamp': brakeLamp,
      'licensePlateLamp': licensePlateLamp,
    };
  }

  factory ExteriorDetailsCloudModel.fromMap(String id, Map<String, dynamic> map) {
    return ExteriorDetailsCloudModel(
      id: id,
      userId: map['userId'] ?? '',
      vehicleCloudId: map['vehicleCloudId'] ?? '',
      driverWindshieldWiper: map['driverWindshieldWiper'] ?? '',
      passengerWindshieldWiper: map['passengerWindshieldWiper'] ?? '',
      rearWindshieldWiper: map['rearWindshieldWiper'] ?? '',
      headlampHighBeam: map['headlampHighBeam'] ?? '',
      headlampLowBeam: map['headlampLowBeam'] ?? '',
      turnLamp: map['turnLamp'] ?? '',
      backupLamp: map['backupLamp'] ?? '',
      fogLamp: map['fogLamp'] ?? '',
      brakeLamp: map['brakeLamp'] ?? '',
      licensePlateLamp: map['licensePlateLamp'] ?? '',
    );
  }
}