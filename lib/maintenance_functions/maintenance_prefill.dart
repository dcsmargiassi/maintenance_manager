import 'package:maintenance_manager/constants/maintenance_types.dart';
import 'package:maintenance_manager/data/cloud/read/battery_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/read/engine_cloud_read.dart';

class MaintenancePrefillService {
  Future<Map<String, dynamic>> getPrefillDetails({
    required String userId,
    required String vehicleCloudId,
    required String maintenanceType,
  }) async {
    switch (maintenanceType) {
      case MaintenanceTypes.oilChange:
        return _prefillOilChange(
          userId: userId,
          vehicleCloudId: vehicleCloudId,
        );

      case MaintenanceTypes.battery:
        return _prefillBattery(
          userId: userId,
          vehicleCloudId: vehicleCloudId,
        );

      default:
        return {};
    }
  }

  Future<Map<String, dynamic>> _prefillOilChange({
    required String userId,
    required String vehicleCloudId,
  }) async {
    final engine = await EngineCloudReadOperations().getEngineDetails(
      userId,
      vehicleCloudId,
    );

    if (engine == null) return {};

    return {
      if (engine.oilWeight.isNotEmpty) 'oilWeight': engine.oilWeight,
      if (engine.oilComposition.isNotEmpty)
        'oilComposition': engine.oilComposition,
      if (engine.oilFilter.isNotEmpty) 'oilFilter': engine.oilFilter,
    };
  }

  Future<Map<String, dynamic>> _prefillBattery({
    required String userId,
    required String vehicleCloudId,
  }) async {
    final battery = await BatteryCloudReadOperations().getBatteryDetails(
      userId,
      vehicleCloudId,
    );

    if (battery == null) return {};

    return {
      if (battery.batterySize!.isNotEmpty) 'batteryGroup': battery.batterySize,
      if (battery.coldCrankAmps != null) 'cca': battery.coldCrankAmps,
    };
  }

  bool canAutofill(String maintenanceType) {
    return {
      MaintenanceTypes.oilChange,
      MaintenanceTypes.battery,
    }.contains(maintenanceType);
  }
}
