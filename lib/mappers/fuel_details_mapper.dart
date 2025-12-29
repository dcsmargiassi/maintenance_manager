import 'package:maintenance_manager/cloud_models/fuel_detail_records.dart';
import 'package:maintenance_manager/models/fuel_records.dart';

class FuelRecordMapper {
  /// Convert Local SQLite → Cloud Firestore
  static FuelRecordCloudModel localToCloud(
    FuelRecords local,
    String userId,
    String vehicleCloudId,
    String? cloudDocId,
  ) {
    final fuelAmount = local.fuelAmount ?? 0.0;
    final fuelPrice = local.fuelPrice ?? 0.0;

    return FuelRecordCloudModel(
      id: cloudDocId,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      fuelAmount: fuelAmount,
      fuelPrice: fuelPrice,
      refuelCost: fuelAmount * fuelPrice,
      odometerAmount: local.odometerAmount ?? 0.0,
      date: local.date ?? '',
    );
  }

  /// Convert Cloud Firestore → Local SQLite
  static FuelRecords cloudToLocal(
    FuelRecordCloudModel cloud,
    String userId,
    int vehicleId,
  ) {
    return FuelRecords(
      fuelRecordId: null, // SQLite auto-increments
      userId: userId,
      vehicleId: vehicleId,
      fuelAmount: cloud.fuelAmount,
      fuelPrice: cloud.fuelPrice,
      refuelCost: cloud.refuelCost,
      odometerAmount: cloud.odometerAmount,
      date: cloud.date,
    );
  }
}