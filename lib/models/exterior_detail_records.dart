/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the eexterior details Records class which corresponds to the database table exteriorDetails with corresponding variables.
 - Constructor createse an instance of exterior details class allowing a new record to be inserted.
 - fromMap method creates a exterior details object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
class ExteriorDetailsModel {
  final int? exteriorDetailsId;
  final String userId;
  final int vehicleId;
  final String? driverWindshieldWiper;
  final String? passengerWindshieldWiper;
  final String? rearWindshieldWiper;
  final String? headlampHighBeam;
  final String? headlampLowBeam;
  final String? turnLamp;
  final String? backupLamp;
  final String? fogLamp;
  final String? brakeLamp;
  final String? licensePlateLamp;

  final String? cloudId;
  final int? isCloudSynced;

  ExteriorDetailsModel({
    this.exteriorDetailsId,
    required this.userId,
    required this.vehicleId,
    this.driverWindshieldWiper,
    this.passengerWindshieldWiper,
    this.rearWindshieldWiper,
    this.headlampHighBeam,
    this.headlampLowBeam,
    this.turnLamp,
    this.backupLamp,
    this.fogLamp,
    this.brakeLamp,
    this.licensePlateLamp,
    this.cloudId,
    this.isCloudSynced,
  });

  Map<String, dynamic> toMap() {
    return{
      'exteriorDetailsId': exteriorDetailsId,
      'userId': userId,
      'vehicleId': vehicleId,
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
      'cloudId': cloudId,
      'isCloudSynced': isCloudSynced,
    };
  }


  factory ExteriorDetailsModel.fromMap(Map<String, dynamic> map) {
    return ExteriorDetailsModel(
      exteriorDetailsId: map['exteriorDetailsId'],
      userId: map['userId'],
      vehicleId: map['vehicleId'],
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
      cloudId: map['cloudId'],
      isCloudSynced: map['isCloudSynced'],
    );
  }
}