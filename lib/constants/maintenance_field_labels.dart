class MaintenanceFieldLabels {
  static const Map<String, String> labels = {
    // Oil Change
    'oilWeight': 'Oil Weight',
    'oilBrand': 'Oil Brand',
    'oilFilter': 'Oil Filter',
    'oilQuantity': 'Oil Quantity',
    'oilComposition': 'Oil Composition',
    'partNumber': 'Part Number',

    // Brakes
    'axle': 'Axle',
    'padsReplaced': 'Brake Pads Replaced',
    'rotorsReplaced': 'Brake Rotors Replaced',
    'calipersReplaced': 'Brake Calipers Replaced',
    'brakeFluidChanged': 'Brake Fluid Changed',
    'partBrand': 'Part Brand',

    // Tires
    'serviceTypeTires': 'Service Type',
    'tireBrand': 'Tire Brand',
    'tireModel': 'Tire Model',
    'tirePosition': 'Tire Position',
    'tireSize': 'Tire Size',
    'rotationPerformed': 'Rotation Performed',
    'balancePerformed': 'Balance Performed',
    'alignmentPerformed': 'Alignment Performed',

    // Battery
    'batteryBrand': 'Battery Brand',
    'batteryGroup': 'Battery Group',
    'cca': 'Cold Cranking Amps (CCA)',
    'batteryType': 'Battery Type',
    'warrantyMonths': 'Warranty Length (Months)',

    // Engine
    'repairCategory': 'Repair Category',
    'laborHours': 'Labor Hours',

    // Transmission
    'serviceTypeTransmission': 'Service Type',
    'fluidType': 'Fluid Type',
    'fluidQuantity': 'Fluid Quantity',
    'filterReplaced': 'Filter Replaced',

    // Cooling System
    'serviceTypeCoolingSystem': 'Service Type',
    'coolantType': 'Coolant Type',
    'coolantQuantity': 'Coolant Quantity',
    'thermostatReplaced': 'Thermostat Replaced',
    'waterPumpReplaced': 'Water Pump Replaced',
    'radiatorReplaced': 'Radiator Replaced',

    // Electrical
    'component': 'Component',

    // Suspension
    'side': 'Vehicle Side',
    'alignmentRequired': 'Alignment Required',

    // Inspection
    'inspectionType': 'Inspection Type',
    'result': 'Result',
    'expirationDate': 'Expiration Date',

    // Filters
    'filterType': 'Filter Type',
    'filterBrand': 'Filter Brand',

    // Fluids
    'fluidBrand': 'Fluid Brand',

    // Body / Exterior
    'repairType': 'Repair Type',
    'paintCode': 'Paint Code',
    'partReplaced': 'Part Replaced',

    // Other
    'description': 'Description',
  };
  static String labelFor(String type) {
    return labels[type] ?? type;
  }
}
