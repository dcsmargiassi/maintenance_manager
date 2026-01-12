/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the vehicleInformation class which corresponds to the database table with corresponding variables.
 - Constructor createse an instance of vehicleInformation class allowing a new vehicle to be inserted.
 - fromMap method creates a vehicle object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

class VehicleInformationModel {
  int? vehicleId;
  String? userId;
  String? vehicleNickName;
  String? vin;
  String? make;
  String? model;
  String? version;
  int? year = 0000;
  String? purchaseDate;
  String? sellDate;
  double? odometerBuy;
  double? odometerSell;
  double? odometerCurrent;
  double? purchasePrice;
  double? sellPrice;
  int? archived;
  double? lifeTimeFuelCost;
  double? lifeTimeMaintenanceCost;
  String? licensePlate;

  String? cloudId;
  int? isCloudSynced;


// Vehicle Information table constructor
  VehicleInformationModel({this.vehicleId, required this.userId, this.vehicleNickName, this.vin, this.make,  this.model, this.version, this.year, this.purchaseDate,
  this.sellDate, this.odometerBuy, this.odometerSell, this.odometerCurrent, this.purchasePrice, this.sellPrice, this.archived,
  this.lifeTimeFuelCost, this.lifeTimeMaintenanceCost, this.licensePlate, this.cloudId, this.isCloudSynced});
  
  VehicleInformationModel.fromMap(dynamic obj) { 
    vehicleId = obj['vehicleId'];
    userId = obj['userId']?? '';
    vehicleNickName = obj['vehicleNickName'] ?? '';
    vin = obj['vin'] ?? '';
    make = obj['make'] ?? '';
    model = obj['model'] ?? '';
    version = obj['version'] ?? '';
    year = obj['year'] ?? 0;
    purchaseDate = obj['purchaseDate'] ?? '';
    sellDate = obj['sellDate'] ?? '';
    odometerBuy = obj['odometerBuy'] ?? 0.0;
    odometerSell = obj['odometerSell'] ?? 0.0;
    odometerCurrent = obj['odometerCurrent'] ?? 0.0;
    purchasePrice = obj['purchasePrice'] ?? 0.0;
    sellPrice = obj['sellPrice'] ?? 0.0;
    archived = obj['archived'] ?? 0;
    lifeTimeFuelCost = obj['lifeTimeFuelCost'] ?? 0.0;
    lifeTimeMaintenanceCost = obj['lifeTimeMaintenanceCost'] ?? 0.0;
    licensePlate = obj['licensePlate'] ?? '';
    cloudId = obj['cloudId'];
    isCloudSynced = obj['isCloudSynced'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'vehicleId': vehicleId,
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
      'cloudId': cloudId,
      'isCloudSynced': isCloudSynced,
    };
    return map;
  }
  
   factory VehicleInformationModel.fromJson(Map<String, dynamic> json) {
    return VehicleInformationModel(
      vehicleId: json['vehicleId'],
      userId: json['userId'] ?? '',
      vehicleNickName: json['vehicleNickName'] ?? '',
      vin: json['vin'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      version: json['version'] ?? '',
      year: json['year'] ?? 0,
      purchaseDate: json['purchaseDate'] ?? '',
      sellDate: json['sellDate'] ?? '',
      odometerBuy: json['odometerBuy'] ?? 0.0,
      odometerSell: json['odometerSell'] ?? 0.0,
      odometerCurrent: json['odometerCurrent'] ?? 0.0,
      purchasePrice: json['purchasePrice'] ?? 0.0,
      sellPrice: json['sellPrice'] ?? 0.0,
      archived: json['archived'] ?? 0,
      lifeTimeFuelCost: json['lifeTimeFuelCost'] ?? 0.0,
      lifeTimeMaintenanceCost: json['lifeTimeMaintenanceCost'] ?? 0.0,
      licensePlate: json['licensePlate'] ?? '',
      cloudId: json['cloudId'],
    isCloudSynced: (json['isCloudSynced'] ?? 0),
    );
  }
}