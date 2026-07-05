import 'package:maintenance_manager/constants/maintenance_types.dart';

class MaintenanceDetailFields {
  static const Map<String, List<String>> fieldsByType = {
    MaintenanceTypes.oilChange: [
      'oilWeight',
      'oilBrand',
      'oilFilter',
      'oilQuantity',
      'oilComposition',
      'partNumber',
    ],
    MaintenanceTypes.brakes: [
      'axle',
      'padsReplaced',
      'rotorsReplaced',
      'calipersReplaced',
      'brakeFluidChanged',
      'partBrand',
      'partNumber',
    ],
    MaintenanceTypes.tires: [
      'serviceTypeTires',
      'tireBrand',
      'tireModel',
      'tirePosition',
      'tireSize',
      'rotationPerformed',
      'balancePerformed',
      'alignmentPerformed',
    ],
    MaintenanceTypes.battery: [
      'batteryBrand',
      'batteryGroup',
      'cca',
      'batteryType',
      'warrantyMonths',
      'partNumber',
    ],
    MaintenanceTypes.engine: [
      'repairCategory',
      'partBrand',
      'partNumber',
      'laborHours',
    ],
    MaintenanceTypes.transmission: [
      'serviceTypeTransmission',
      'fluidType',
      'fluidQuantity',
      'filterReplaced',
      'partBrand',
      'partNumber',
    ],
    MaintenanceTypes.coolingSystem: [
      'serviceTypeCoolingSystem',
      'coolantType',
      'coolantQuantity',
      'thermostatReplaced',
      'waterPumpReplaced',
      'radiatorReplaced',
      'partBrand',
      'partNumber',
    ],
    MaintenanceTypes.electrical: [
      'component',
      'partBrand',
      'partNumber',
    ],
    MaintenanceTypes.suspension: [
      'component',
      'side',
      'partBrand',
      'partNumber',
      'alignmentRequired',
    ],
    MaintenanceTypes.inspection: [
      'inspectionType',
      'result',
      'expirationDate',
    ],
    MaintenanceTypes.filters: [
      'filterType',
      'filterBrand',
      'partNumber',
    ],
    MaintenanceTypes.fluids: [
      'fluidType',
      'fluidBrand',
      'fluidQuantity',
    ],
    MaintenanceTypes.bodyExterior: [
      'repairType',
      'paintCode',
      'partReplaced',
      'partBrand',
      'partNumber',
    ],
    MaintenanceTypes.other: [
      'description',
    ],
  };
  static List<String> fieldsFor(String type) {
    return fieldsByType[type] ?? [];
  }

  static bool hasFields(String type) {
    return (fieldsByType[type] ?? []).isNotEmpty;
  }
}
