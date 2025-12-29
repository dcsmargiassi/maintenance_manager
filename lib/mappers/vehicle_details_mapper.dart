import 'package:maintenance_manager/cloud_models/vehicle_detail_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';

class VehicleInformationMapper {
  // Local -> Cloud
  static VehicleInformationCloudModel localToCloud(VehicleInformationModel local, String cloudId) {
    return VehicleInformationCloudModel(
      id: cloudId,
      userId: local.userId ?? '',
      vehicleNickName: local.vehicleNickName,
      vin: local.vin,
      make: local.make,
      model: local.model,
      version: local.version,
      year: local.year ?? 0,
      purchaseDate: local.purchaseDate,
      sellDate: local.sellDate,
      odometerBuy: local.odometerBuy,
      odometerSell: local.odometerSell,
      odometerCurrent: local.odometerCurrent,
      purchasePrice: local.purchasePrice,
      sellPrice: local.sellPrice,
      archived: local.archived ?? 0,
      lifeTimeFuelCost: local.lifeTimeFuelCost ?? 0.0,
      lifeTimeMaintenanceCost: local.lifeTimeMaintenanceCost ?? 0.0,
      licensePlate: local.licensePlate,
    );
  }

  // Cloud -> Local
  static VehicleInformationModel cloudToLocal(VehicleInformationCloudModel cloud) {
    return VehicleInformationModel(
      vehicleId: null, // SQLite auto-increment
      userId: cloud.userId,
      vehicleNickName: cloud.vehicleNickName,
      vin: cloud.vin,
      make: cloud.make,
      model: cloud.model,
      version: cloud.version,
      year: cloud.year,
      purchaseDate: cloud.purchaseDate,
      sellDate: cloud.sellDate,
      odometerBuy: cloud.odometerBuy,
      odometerSell: cloud.odometerSell,
      odometerCurrent: cloud.odometerCurrent,
      purchasePrice: cloud.purchasePrice,
      sellPrice: cloud.sellPrice,
      archived: cloud.archived,
      lifeTimeFuelCost: cloud.lifeTimeFuelCost,
      lifeTimeMaintenanceCost: cloud.lifeTimeMaintenanceCost,
      licensePlate: cloud.licensePlate,
    );
  }
}