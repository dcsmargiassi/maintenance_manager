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

  final String? cloudId;
  final int? isCloudSynced;

  BatteryDetailsModel({
    this.batteryDetailsId,
    required this.userId,
    required this.vehicleId,
    this.batterySeriesType,
    this.batterySize,
    this.coldCrankAmps,
    this.cloudId,
    this.isCloudSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'batteryDetailsId': batteryDetailsId,
      'userId': userId,
      'vehicleId': vehicleId,
      'batterySeriesType': batterySeriesType,
      'batterySize': batterySize,
      'coldCrankAmps': coldCrankAmps,
      'cloudId': cloudId,
      'isCloudSynced': isCloudSynced,
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
      cloudId: map['cloudId'],
      isCloudSynced: map['isCloudSynced'],
    );
  }
  
  BatteryDetailsModel copyWith({
    int? batteryDetailsId,
    String? userId,
    int? vehicleId,
    String? batterySeriesType,
    String? batterySize,
    double? coldCrankAmps,
    String? cloudId,
    int? isCloudSynced,
  }) {
    return BatteryDetailsModel(
      batteryDetailsId: batteryDetailsId ?? this.batteryDetailsId,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      batterySeriesType: batterySeriesType ?? this.batterySeriesType,
      batterySize: batterySize ?? this.batterySize,
      coldCrankAmps: coldCrankAmps ?? this.coldCrankAmps,
      cloudId: cloudId ?? this. cloudId,
      isCloudSynced: isCloudSynced ?? this.isCloudSynced,
    );
  }
}