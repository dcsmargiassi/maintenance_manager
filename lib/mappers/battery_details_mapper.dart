import 'package:maintenance_manager/cloud_models/battery_detail_records.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart' show BatteryDetailsModel;

// Local -> Cloud Firestore
BatteryDetailsCloudModel mapLocalBatteryToCloud(
  BatteryDetailsModel local,
  String userId,
  String cloudId,
  String vehicleCloudId,
) {
  return BatteryDetailsCloudModel(
    id: cloudId,
    userId: userId,
    vehicleCloudId: vehicleCloudId,
    batterySeriesType: local.batterySeriesType,
    batterySize: local.batterySize,
    coldCrankAmps: local.coldCrankAmps,
  );
}

// Cloud -> Local SQLite model
BatteryDetailsModel mapCloudBatteryToLocal(
  BatteryDetailsCloudModel cloud,
  int localVehicleId,
) {
  return BatteryDetailsModel(
    batteryDetailsId: null,
    userId: "",
    vehicleId: localVehicleId,
    batterySeriesType: cloud.batterySeriesType,
    batterySize: cloud.batterySize,
    coldCrankAmps: cloud.coldCrankAmps,
  );
}