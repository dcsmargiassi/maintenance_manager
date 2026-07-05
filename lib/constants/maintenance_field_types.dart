class MaintenanceFieldTypes {
  static const text = 'text';
  static const number = 'number';
  static const boolean = 'boolean';
  static const date = 'date';
  static const dropdown = 'dropdown';
  static const dropdownSearch = 'dropdownSearch';

  static const Map<String, String> fieldTypes = {
    // Oil Change
    'oilWeight': text,
    'oilBrand': text,
    'oilFilter': text,
    'oilQuantity': number,
    'oilComposition': dropdown,
    'partNumber': text,

    // Brakes
    'axle': dropdown,
    'padsReplaced': boolean,
    'rotorsReplaced': boolean,
    'calipersReplaced': boolean,
    'brakeFluidChanged': boolean,
    'partBrand': text,

    // Tires
    'serviceTypeTires': dropdown,
    'tireBrand': text,
    'tireModel': text,
    'tirePosition': dropdown,
    'tireSize': text,
    'rotationPerformed': boolean,
    'balancePerformed': boolean,
    'alignmentPerformed': boolean,

    // Battery
    'batteryBrand': text,
    'batteryGroup': dropdownSearch,
    'cca': number,
    'batteryType': dropdown,
    'warrantyMonths': number,

    // Engine
    'repairCategory': dropdown,
    'laborHours': number,

    // Transmission
    'serviceTypeTransmission': dropdown,
    'fluidType': dropdown,
    'fluidQuantity': number,
    'filterReplaced': boolean,

    // Cooling System
    'serviceTypeCoolingSystem': dropdown,
    'coolantType': dropdown,
    'coolantQuantity': number,
    'thermostatReplaced': boolean,
    'waterPumpReplaced': boolean,
    'radiatorReplaced': boolean,

    // Electrical
    'component': dropdown,

    // Suspension
    'side': dropdown,
    'alignmentRequired': boolean,

    // Inspection
    'inspectionType': dropdown,
    'result': dropdown,
    'expirationDate': date,

    // Filters
    'filterType': dropdown,
    'filterBrand': text,

    // Fluids
    'fluidBrand': text,

    // Body / Exterior
    'repairType': dropdown,
    'paintCode': text,
    'partReplaced': text,

    // Other
    'description': text,
  };

  static String typeFor(String fieldKey) {
    return fieldTypes[fieldKey] ?? text;
  }
}
