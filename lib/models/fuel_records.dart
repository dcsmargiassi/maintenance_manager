/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the fuelRecords class which corresponds to the database table fuelRecords with corresponding variables.
 - Constructor createse an instance of fuel class allowing a new fuel record to be inserted.
 - fromMap method creates a fuel object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
class FuelRecords {
  int? fuelRecordId;
  String? userId;
  int? vehicleId;
  double? fuelAmount;
  double? fuelPrice;
  double? refuelCost; // Should be auto-calculated based on fuel amount and price removing manual entry
  double? odometerAmount;
  String? date;
  String? notes;

// Fuel Records table constructor
  FuelRecords({required this.fuelRecordId, required this.userId, required this.vehicleId, required this.fuelAmount, 
  required this.fuelPrice, this.refuelCost, this.odometerAmount, this.date, this.notes});
  
  FuelRecords.fromMap(dynamic obj) { 
    fuelRecordId = obj['fuelRecordId'];
    userId = obj['userId'];
    vehicleId = obj['vehicleId'];
    fuelAmount = obj['fuelAmount'];
    fuelPrice = obj['fuelPrice'];
    refuelCost = obj['refuelCost'];
    odometerAmount = obj['odometerAmount'];
    date = obj['date'];
    notes = obj['notes'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'fuelRecordId': fuelRecordId,
      'userId': userId,
      'vehicleId': vehicleId,
      'fuelAmount': fuelAmount,
      'fuelPrice': fuelPrice,
      'refuelCost': refuelCost,
      'odometerAmount': odometerAmount,
      'date': date,
      'notes': notes,
    };
    return map;
  }
}