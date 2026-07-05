class MaintenanceFieldOptions {
  static const Map<String, List<String>> options = {
    'oilComposition': [
      'Conventional',
      'Synthetic Blend',
      'Full Synthetic',
      'High Mileage',
      'Diesel',
    ],

    // Brakes
    'axle': [
      'Front',
      'Rear',
      'Both',
    ],

    // Tires
    'serviceTypeTires': [
      'Replace',
      'Rotation',
      'Balance',
      'Alignment',
      'Patch / Repair',
      'Mount',
    ],
    'tirePosition': [
      'Front Left',
      'Front Right',
      'Rear Left',
      'Rear Right',
      'Front',
      'Rear',
      'All',
    ],

    // Battery
    'batteryType': [
      'Lead Acid',
      'AGM',
      'Gel',
      'Lithium',
    ],
    'batteryGroup': [
      "1",
      "2",
      "2E",
      "2N",
      "17HF",
      "19L",
      "21",
      "21R",
      "22F",
      "22HF",
      "22NF",
      "24",
      "24F",
      "24H",
      "24R",
      "24T",
      "25",
      "26",
      "26R",
      "27",
      "27F",
      "27H",
      "27R",
      "29NF",
      "33",
      "34",
      "34R",
      "35",
      "36R",
      "40R",
      "41",
      "42",
      "43",
      "45",
      "46",
      "47",
      "48",
      "49",
      "50",
      "51",
      "51R",
      "52",
      "53",
      "54",
      "55",
      "56",
      "57",
      "58",
      "58R",
      "59",
      "60",
      "61",
      "62",
      "63",
      "64",
      "65",
      "66",
      "67R",
      "70",
      "71",
      "72",
      "73",
      "74",
      "75",
      "76",
      "77",
      "78",
      "79",
      "85",
      "86",
      "90",
      "91",
      "92",
      "93",
      "94R",
      "95R",
      "96R",
      "97R",
      "98R",
      "99",
      "99R",
      "100",
      "101",
      "102R",
      "121R",
      "124",
      "124R",
      "140R",
      "148",
      "151R",
      "152R",
      "153R",
      "400",
      "401",
      "402R",
      "403",
    ],

    // Engine
    'repairCategory': [
      'Spark Plugs',
      'Ignition Coil',
      'Belt',
      'Hose',
      'Water Pump',
      'Timing Belt / Chain',
      'Valve Cover Gasket',
      'Sensor',
      'Fuel System',
      'Other',
    ],

    // Transmission
    'fluidType': [
      'Automatic Transmission Fluid',
      'Manual Transmission Fluid',
      'CVT Fluid',
      'Gear Oil',
      'Other',
    ],

    'serviceTypeTransmission': [
      'Replace',
      'Repair',
    ],

    // Cooling System
    'coolantType': [
      'Green',
      'Orange / Dex-Cool',
      'Yellow',
      'Blue',
      'Pink',
      'Universal',
      'Other',
    ],

    'serviceTypeCoolingsystem': [
      'Replace',
      'Recharge',
      'Coolant Flush',
    ],

    // Electrical
    'component': [
      'Alternator',
      'Starter',
      'Battery Cable',
      'Fuse',
      'Relay',
      'Sensor',
      'Ignition Coil',
      'Light Bulb',
      'Other',
    ],

    // Suspension / Steering
    'side': [
      'Driver Side',
      'Passenger Side',
      'Front',
      'Rear',
      'Both',
      'All',
    ],

    // Inspection
    'inspectionType': [
      'State Inspection',
      'Emissions Inspection',
      'Safety Inspection',
      'Pre-Purchase Inspection',
      'Safety & Emissions Inspection',
      'Other',
    ],
    'result': [
      'Passed',
      'Failed',
      'Advisory / Needs Attention',
    ],

    // Filters
    'filterType': [
      'Engine Air Filter',
      'Cabin Air Filter',
      'Oil Filter',
      'Fuel Filter',
      'Transmission Filter',
      'Other',
    ],

    // Body / Exterior
    'repairType': [
      'Windshield',
      'Mirror',
      'Bumper',
      'Door Handle',
      'Paint Repair',
      'Dent Repair',
      'Light Assembly',
      'Wiper Blade',
      'Other',
    ],
  };

  static List<String> optionsFor(String fieldKey) {
    return options[fieldKey] ?? const [];
  }

  static bool hasOptions(String fieldKey) {
    return options.containsKey(fieldKey);
  }
}
