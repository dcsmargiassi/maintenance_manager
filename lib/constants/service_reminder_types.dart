class ServiceReminderTypes {
  ServiceReminderTypes._();

  static const String oilChange = 'oilChange';
  static const String batteryReplacement = 'batteryReplacement';
  static const String tireRotation = 'tireRotation';
  static const String inspection = 'inspection';
  static const String airFilter = 'airFilter';
  static const String custom = 'custom';

  static const List<String> values = [
    oilChange,
    batteryReplacement,
    tireRotation,
    inspection,
    airFilter,
    custom,
  ];
}

class ServiceReminderScheduleTypes {
  ServiceReminderScheduleTypes._();

  static const String mileage = 'mileage';
  static const String time = 'time';
  static const String both = 'both';

  static const List<String> values = [
    mileage,
    time,
    both,
  ];
}
