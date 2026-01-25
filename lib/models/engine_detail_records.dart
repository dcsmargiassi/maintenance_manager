/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the engine details Records class which corresponds to the database table engineDetails with corresponding variables.
 - Constructor createse an instance of engine details class allowing a new record to be inserted.
 - fromMap method creates a engine details object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
class EngineDetailsModel {
  final int? engineDetailsId;
  final String? userId;
  final int vehicleId;
  final String? engineSize;
  final String? cylinders;
  final String? engineType;
  final String? oilWeight;
  final String? oilComposition;
  final String? oilClass;
  final String? oilFilter;
  final String? engineFilter;

  final String? cloudId;
  final int? isCloudSynced;

  EngineDetailsModel({
    this.engineDetailsId,
    required this.userId,
    required this.vehicleId,
    this.engineSize,
    this.cylinders,
    this.engineType,
    this.oilWeight,
    this.oilComposition,
    this.oilClass,
    this.oilFilter,
    this.engineFilter,
    this.cloudId,
    this.isCloudSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'engineDetailsId': engineDetailsId,
      'userId': userId,
      'vehicleId': vehicleId,
      'engineSize': engineSize,
      'cylinders': cylinders,
      'engineType': engineType,
      'oilWeight': oilWeight,
      'oilComposition': oilComposition,
      'oilClass': oilClass,
      'oilFilter': oilFilter,
      'engineFilter': engineFilter,
      'cloudId': cloudId,
      'isCloudSynced': isCloudSynced,
    };
  }

  factory EngineDetailsModel.fromMap(Map<String, dynamic> map) {
    return EngineDetailsModel(
      engineDetailsId: map['engineDetailsId'],
      userId: map['userId'],
      vehicleId: map['vehicleId'],
      engineSize: map['engineSize'],
      cylinders: map['cylinders'],
      engineType: map['engineType'],
      oilWeight: map['oilWeight'],
      oilComposition: map['oilComposition'],
      oilClass: map['oilClass'],
      oilFilter: map['oilFilter'],
      engineFilter: map['engineFilter'],
      cloudId: map['cloudId'],
      isCloudSynced: map['isCloudSynced'],
    );
  }
  EngineDetailsModel copyWith({
    int? engineDetailsId,
    String? userId,
    int? vehicleId,
    String? engineSize,
    String? cylinders,
    String? engineType,
    String? oilWeight,
    String? oilComposition,
    String? oilClass,
    String? oilFilter,
    String? engineFilter,
    String? cloudId,
    int? isCloudSynced,
  }) {
  return EngineDetailsModel(
    engineDetailsId: engineDetailsId ?? this.engineDetailsId,
    userId: userId ?? this.userId,
    vehicleId: vehicleId ?? this.vehicleId,
    engineSize: engineSize ?? this.engineSize,
    cylinders: cylinders ?? this.cylinders,
    engineType: engineType ?? this.engineType,
    oilWeight: oilWeight ?? this.oilWeight,
    oilComposition: oilComposition ?? this.oilComposition,
    oilClass: oilClass ?? this.oilClass,
    oilFilter: oilFilter ?? this.oilFilter,
    engineFilter: engineFilter ?? this.engineFilter,
    cloudId: cloudId ?? this.cloudId,
    isCloudSynced: isCloudSynced ?? this.isCloudSynced,
    );
  }
}
