/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the battery Records class which corresponds to the database table batteryDetails with corresponding variables.
 - Constructor createse an instance of battery details class allowing a new record to be inserted.
 - fromMap method creates a battery details object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
class BatteryDetailsModel {
  final int? batteryDetailsId;
  final String userId;
  final int vehicleId;
  final String? batterySeriesType;
  final String? batterySize;
  final double? coldCrankAmps;

  BatteryDetailsModel({
    this.batteryDetailsId,
    required this.userId,
    required this.vehicleId,
    this.batterySeriesType,
    this.batterySize,
    this.coldCrankAmps,
  });

  Map<String, dynamic> toMap() {
    return {
      'batteryDetailsId': batteryDetailsId,
      'userId': userId,
      'vehicleId': vehicleId,
      'batterySeriesType': batterySeriesType,
      'batterySize': batterySize,
      'coldCrankAmps': coldCrankAmps,
    };
  }

  factory BatteryDetailsModel.fromMap(Map<String, dynamic> map) {
    return BatteryDetailsModel(
      batteryDetailsId: map['batteryDetailsId'],
      userId: map['userId'],
      vehicleId: map['vehicleId'],
      batterySeriesType: map['batterySeriesType'],
      batterySize: map['batterySize'],
      coldCrankAmps: map['coldCrankAmps'],
    );
  }
}