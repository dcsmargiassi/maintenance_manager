import 'package:maintenance_manager/helper_functions/encryption_helper.dart';

class VehicleInformationCloudModel {
  final String cloudId; // Firestore doucment ID
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
    required this.cloudId,
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

@Deprecated("Phase out from map utilize from json")
  factory VehicleInformationCloudModel.fromMap(String cloudId, Map<String, dynamic> map) {
    return VehicleInformationCloudModel(
      cloudId: cloudId,
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

  factory VehicleInformationCloudModel.empty({
    required String userId,
    required String cloudId,
  }) {
    return VehicleInformationCloudModel(
      cloudId: cloudId,
      userId: userId,
      vehicleNickName: '',
      vin: '',
      make: '',
      model: '',
      version: '',
      year: 0,
      purchaseDate: '',
      sellDate: '',
      odometerBuy: 0.0,
      odometerSell: 0.0,
      odometerCurrent: 0.0,
      purchasePrice: 0.0,
      sellPrice: 0.0,
      archived: 0,
      lifeTimeFuelCost: 0.0,
      lifeTimeMaintenanceCost: 0.0,
      licensePlate: '',
    );
  }

  static Future<VehicleInformationCloudModel?> fromJson(
    String cloudId,
    Map<String, dynamic>? data, {
    bool decryptSensitive = true,
  }) async {
    if (data == null) return null;

    Future<String?> tryDecrypt(dynamic v) async {
      if (v == null) return null;
      final s = v.toString();
      if (s.isEmpty) return s;

      if (!decryptSensitive) return s;

      try {
        return await decryptField(s);
      } catch (_) {
        // Offline or decrypt failure → return encrypted value
        return s;
      }
    }

    return VehicleInformationCloudModel(
      cloudId: cloudId,
      userId: data['userId'] ?? '',
      vehicleNickName: data['vehicleNickName'],
      vin: await tryDecrypt(data['vin']),
      make: data['make'],
      model: data['model'],
      version: data['version'],
      year: (data['year'] as num?)?.toInt() ?? 0,
      purchaseDate: data['purchaseDate'],
      sellDate: data['sellDate'],
      odometerBuy: (data['odometerBuy'] as num?)?.toDouble(),
      odometerSell: (data['odometerSell'] as num?)?.toDouble(),
      odometerCurrent: (data['odometerCurrent'] as num?)?.toDouble(),
      purchasePrice: (data['purchasePrice'] as num?)?.toDouble(),
      sellPrice: (data['sellPrice'] as num?)?.toDouble(),
      archived: (data['archived'] ?? 0) as int,
      lifeTimeFuelCost: (data['lifeTimeFuelCost'] as num?)?.toDouble() ?? 0.0,
      lifeTimeMaintenanceCost:
          (data['lifeTimeMaintenanceCost'] as num?)?.toDouble() ?? 0.0,
      licensePlate: await tryDecrypt(data['licensePlate']),
    );
  }
}