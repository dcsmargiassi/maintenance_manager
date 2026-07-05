import 'package:maintenance_manager/constants/maintenance_types.dart';

class MaintenanceTypeLabels {
  static const labels = {
    MaintenanceTypes.oilChange: 'Oil Change',
    MaintenanceTypes.brakes: 'Brakes',
    MaintenanceTypes.tires: 'Tires',
    MaintenanceTypes.battery: 'Battery',
    MaintenanceTypes.engine: 'Engine Repair',
    MaintenanceTypes.transmission: 'Transmission',
    MaintenanceTypes.coolingSystem: 'Cooling System',
    MaintenanceTypes.inspection: 'Inspection',
    MaintenanceTypes.electrical: 'Electrical',
    MaintenanceTypes.suspension: 'Suspension / Steering',
    MaintenanceTypes.filters: 'Filters',
    MaintenanceTypes.fluids: 'Fluids',
    MaintenanceTypes.bodyExterior: 'Body / Exterior',
    MaintenanceTypes.other: 'Other',
  };
  static String labelFor(String type) {
    return labels[type] ?? type;
  }
}
