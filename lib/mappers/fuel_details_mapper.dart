import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_manager/cloud_models/fuel_detail_records.dart';
import 'package:maintenance_manager/models/fuel_records.dart';

class FuelRecordMapper {
  static FuelRecordCloudModel localToCloud(
    FuelRecords local,
    String userId,
    String vehicleCloudId,
    String cloudDocId, {
    Timestamp? createdAt,
  }) {
    final fuelAmount = local.fuelAmount ?? 0.0;
    final fuelPrice = local.fuelPrice ?? 0.0;

    return FuelRecordCloudModel(
      cloudId: cloudDocId,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      fuelAmount: fuelAmount,
      fuelPrice: fuelPrice,
      refuelCost: local.refuelCost ?? (fuelAmount * fuelPrice),
      odometerAmount: local.odometerAmount ?? 0.0,
      date: local.date ?? '',
      createdAt: createdAt,
    );
  }

  static FuelRecords cloudToLocal(
    FuelRecordCloudModel cloud,
    String userId,
    int vehicleId,
  ) {
    return FuelRecords(
      fuelRecordId: null,
      userId: userId,
      vehicleId: vehicleId,
      fuelAmount: cloud.fuelAmount,
      fuelPrice: cloud.fuelPrice,
      refuelCost: cloud.refuelCost,
      odometerAmount: cloud.odometerAmount,
      date: cloud.date,
      cloudId: cloud.cloudId,
      isCloudSynced: 1,
    );
  }
}