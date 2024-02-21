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
  int? userId;
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

// Vehicle Information table constructor
  VehicleInformationModel({this.vehicleId, this.userId, this.vehicleNickName, this.vin, this.make,  this.model, this.version, this.year, this.purchaseDate,
  this.sellDate, this.odometerBuy, this.odometerSell, this.odometerCurrent, this.purchasePrice, this.sellPrice});
  
  VehicleInformationModel.fromMap(dynamic obj) { 
    vehicleId = obj['vehicleId'];
    userId = obj['userId']?? '';
    vehicleNickName = obj['vehicleNickName'];
    vin = obj['vin'];
    make = obj['make'];
    model = obj['model'];
    version = obj['version'];
    year = obj['year'];
    purchaseDate = obj['purchaseDate'];
    sellDate = obj['sellDate'];
    odometerBuy = obj['odometerBuy'];
    odometerSell = obj['odometerSell'];
    odometerCurrent = obj['odometerCurrent'];
    purchasePrice = obj['purchasePrice'];
    sellPrice = obj['sellPrice'];
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
    };
    return map;
  }
  
   factory VehicleInformationModel.fromJson(Map<String, dynamic> json) {
    return VehicleInformationModel(
      vehicleId: json['vehicleId'],
      userId: json['userId'],
      vehicleNickName: json['vehicleNickName'],
      vin: json['vin'],
      make: json['make'],
      model: json['model'],
      version: json['version'],
      year: json['year'],
      purchaseDate: json['purchaseDate'],
      sellDate: json['sellDate'],
      odometerBuy: json['odometerBuy'],
      odometerSell: json['odometerSell'],
      odometerCurrent: json['odometerCurrent'],
      purchasePrice: json['purchasePrice'],
      sellPrice: json['sellPrice'],
    );
  }
}
