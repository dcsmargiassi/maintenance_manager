const Map<String, String> currencySymbols = {
  'USD': '\$',
  'EUR': '€',
  'GBP': '£',
  'JPY': '¥',
  'AUD': '\$',
  'MXN': '\$',
  'MXV': 'Mex\$',
};

const Map<String, String> distanceUnits = {
  'Miles': 'mi',
  'Kilometers': 'km',
};

// Fuel volume units
const Map<String, String> fuelVolumeUnits = {
  'Gallons': 'gal',
  'Liters': 'L',
};

// Fluid volume units (quart, liter, etc)
const Map<String, String> maintenanceFluidUnits = {
  'Quarts': 'qt',
  'Liters': 'L',
};

const List<String> supportedDateFormats = [
  'MM/dd/yyyy',
  'dd/MM/yyyy',
  'yyyy-MM-dd',
];
