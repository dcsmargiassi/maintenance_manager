import 'package:maintenance_manager/cloud_models/engine_detail_records.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';

class EngineDetailsMapper {
  // Local -> Cloud Firestore
  static EngineDetailsCloudModel mapEnginelocalToCloud(
    EngineDetailsModel local,
    String cloudDocId,
    String userId,
    String vehicleCloudId,
  ) {
    return EngineDetailsCloudModel(
      id: cloudDocId,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      engineSize: local.engineSize ?? '',
      cylinders: local.cylinders ?? '',
      engineType: local.engineType ?? '',
      oilWeight: local.oilWeight ?? '',
      oilComposition: local.oilComposition ?? '',
      oilClass: local.oilClass ?? '',
      oilFilter: local.oilFilter ?? '',
      engineFilter: local.engineFilter ?? '',
    );
  }

  // Cloud -> Local SQLite model
  static EngineDetailsModel mapEngineCloudToLocal(
    EngineDetailsCloudModel cloud,
    int localVehicleId,
  ) {
    return EngineDetailsModel(
      engineDetailsId: null,
      userId: cloud.userId,
      vehicleId: localVehicleId,
      engineSize: cloud.engineSize,
      cylinders: cloud.cylinders,
      engineType: cloud.engineType,
      oilWeight: cloud.oilWeight,
      oilComposition: cloud.oilComposition,
      oilClass: cloud.oilClass,
      oilFilter: cloud.oilFilter,
      engineFilter: cloud.engineFilter,
    );
  }
}