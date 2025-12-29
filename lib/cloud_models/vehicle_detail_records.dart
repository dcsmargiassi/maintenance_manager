class VehicleInformationCloudModel {
  final String id; // Firestore doucment ID
  final String userId;
  final String? vehicleNickName;
  final String? vin;
  final String? make;
  final String? model;
  final String? version;
  final int year;
  final String? purchaseDate;
  final String? sellDate;
  final double? odometerBuy;
  final double? odometerSell;
  final double? odometerCurrent;
  final double? purchasePrice;
  final double? sellPrice;
  final int archived; // 0 - active 1 - archived 
  final double lifeTimeFuelCost;
  final double lifeTimeMaintenanceCost;
  final String? licensePlate;

  VehicleInformationCloudModel({
    required this.id,
    required this.userId,
    this.vehicleNickName,
    this.vin,
    this.make,
    this.model,
    this.version,
    this.year = 0,
    this.purchaseDate,
    this.sellDate,
    this.odometerBuy,
    this.odometerSell,
    this.odometerCurrent,
    this.purchasePrice,
    this.sellPrice,
    this.archived = 0,
    this.lifeTimeFuelCost = 0.0,
    this.lifeTimeMaintenanceCost = 0.0,
    this.licensePlate,
  });

  factory VehicleInformationCloudModel.fromMap(String id, Map<String, dynamic> map) {
    return VehicleInformationCloudModel(
      id: id,
      userId: map['userId'] ?? '',
      vehicleNickName: map['vehicleNickName'],
      vin: map['vin'],
      make: map['make'],
      model: map['model'],
      version: map['version'],
      year: map['year'] ?? 0,
      purchaseDate: map['purchaseDate'],
      sellDate: map['sellDate'],
      odometerBuy: (map['odometerBuy'] ?? 0).toDouble(),
      odometerSell: (map['odometerSell'] ?? 0).toDouble(),
      odometerCurrent: (map['odometerCurrent'] ?? 0).toDouble(),
      purchasePrice: (map['purchasePrice'] ?? 0).toDouble(),
      sellPrice: (map['sellPrice'] ?? 0).toDouble(),
      archived: map['archived'] ?? 0,
      lifeTimeFuelCost: (map['lifeTimeFuelCost'] ?? 0).toDouble(),
      lifeTimeMaintenanceCost:
          (map['lifeTimeMaintenanceCost'] ?? 0).toDouble(),
      licensePlate: map['licensePlate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleNickName': vehicleNickName,
      'vin': vin,
      'make': make,
      'model': model,
      'version': version,
      'year': year,
      'purchaseDate': purchaseDate,
      'sellDate': sellDate,
      'odometerBuy': odometerBuy,
      'odometerSell': odometerSell,
      'odometerCurrent': odometerCurrent,
      'purchasePrice': purchasePrice,
      'sellPrice': sellPrice,
      'archived': archived,
      'lifeTimeFuelCost': lifeTimeFuelCost,
      'lifeTimeMaintenanceCost': lifeTimeMaintenanceCost,
      'licensePlate': licensePlate,
    };
  }
}