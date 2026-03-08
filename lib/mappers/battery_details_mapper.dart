import 'package:maintenance_manager/cloud_models/battery_detail_records.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart' show BatteryDetailsModel;

// Local -> Cloud Firestore
BatteryDetailsCloudModel localToCloud(
  BatteryDetailsModel local,
  String userId,
  String cloudDocId,
  String vehicleCloudId,
) {
  return BatteryDetailsCloudModel(
    cloudId: cloudDocId,
    userId: userId,
    vehicleCloudId: vehicleCloudId,
    batterySeriesType: local.batterySeriesType,
    batterySize: local.batterySize,
    coldCrankAmps: local.coldCrankAmps,
  );
}

// Cloud -> Local SQLite model
BatteryDetailsModel cloudToLocal(
  BatteryDetailsCloudModel cloud,
  int localVehicleId,
) {
  return BatteryDetailsModel(
    batteryDetailsId: null,
    userId: cloud.userId,
    vehicleId: localVehicleId,
    batterySeriesType: cloud.batterySeriesType,
    batterySize: cloud.batterySize,
    coldCrankAmps: cloud.coldCrankAmps,
    cloudId: cloud.cloudId,
    isCloudSynced: 1,
  );
}