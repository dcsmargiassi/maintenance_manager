/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the maintenance Records class which corresponds to the database table maintenanceRecords with corresponding variables.
 - Constructor createse an instance of maintenance class allowing a new record to be inserted.
 - fromMap method creates a maintenance object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
class MaintenanceRecords {
  String? maintenanceRecordId;
  int? vehicleId;
  String? date;
  String? workLocation;
  int? maintenanceType;
  String? maintenanceCost;
  int? notes = 0;
  bool? oilChange = false;
  bool? tireRotationAlignment = false;

// User table constructor
  MaintenanceRecords({required this.maintenanceRecordId, required this.vehicleId, required this.date, required this.workLocation, required this.maintenanceType, 
  this.maintenanceCost, this.notes, required this.oilChange, required this.tireRotationAlignment});
  
  MaintenanceRecords.fromMap(dynamic obj) { 
    maintenanceRecordId = obj['maintenanceRecordId'];
    vehicleId = obj['vehicleId']?? '';
    date = obj['date'];
    workLocation = obj['workLocation'];
    maintenanceType = obj['maintenanceType'];
    maintenanceCost = obj['maintenanceCost'];
    notes = obj['notes'];
    oilChange = obj['oilChange'];
    tireRotationAlignment = obj['tireRotationAlignment'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'maintenanceRecordId': maintenanceRecordId,
      'vehicleId': vehicleId,
      'date': date,
      'workLocation': workLocation,
      'maintenanceType': maintenanceType,
      'maintenanceCost': maintenanceCost,
      'notes': notes,
      'oilChange': oilChange,
      'tireRotationAlignment': tireRotationAlignment,
    };
    return map;
  }
}