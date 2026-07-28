import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceReminderCloudModel {
  final String? id;
  final String userId;
  final String vehicleCloudId;

  /// Examples: oilChange, batteryReplacement, tireRotation
  final String reminderType;

  /// User-facing name, such as "Oil Change"
  final String title;

  final bool enabled;

  /// mileage, time, or both
  final String scheduleType;

  /// Maintenance record that established the current service baseline.
  final String? sourceMaintenanceRecordId;

  /// Odometer when the service was last completed.
  final int? lastServiceOdometer;

  /// Date when the service was last completed.
  final DateTime? lastServiceDate;

  /// Example: 5,000, 7,500, or 10,000 miles.
  final int? mileageInterval;

  /// Example: notify 250 miles before service is due.
  final int? mileageReminderThreshold;

  /// Example: 36 months for a three-year battery interval.
  final int? timeIntervalMonths;

  /// Example: notify 30 days before service is due.
  final int? timeReminderThresholdDays;

  /// Prevents sending the same mileage reminder repeatedly.
  ///
  /// For example, if the current reminder is for 55,000 miles,
  /// this stores 55,000 after that notification has been sent.
  final int? lastNotifiedForOdometer;

  /// Prevents sending the same date reminder repeatedly.
  ///
  /// This represents the service due date associated with the
  /// last notification.
  final DateTime? lastNotifiedForDate;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceReminderCloudModel({
    this.id,
    required this.userId,
    required this.vehicleCloudId,
    required this.reminderType,
    required this.title,
    required this.enabled,
    required this.scheduleType,
    this.sourceMaintenanceRecordId,
    this.lastServiceOdometer,
    this.lastServiceDate,
    this.mileageInterval,
    this.mileageReminderThreshold,
    this.timeIntervalMonths,
    this.timeReminderThresholdDays,
    this.lastNotifiedForOdometer,
    this.lastNotifiedForDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Calculates the next odometer reading at which service is due.
  int? get nextDueOdometer {
    if (lastServiceOdometer == null || mileageInterval == null) {
      return null;
    }

    return lastServiceOdometer! + mileageInterval!;
  }

  /// Calculates when the mileage warning should begin.
  int? get mileageReminderStart {
    final dueOdometer = nextDueOdometer;

    if (dueOdometer == null || mileageReminderThreshold == null) {
      return null;
    }

    return dueOdometer - mileageReminderThreshold!;
  }

  /// Calculates the next date on which service is due.
  DateTime? get nextDueDate {
    if (lastServiceDate == null || timeIntervalMonths == null) {
      return null;
    }

    return _addMonths(
      lastServiceDate!,
      timeIntervalMonths!,
    );
  }

  /// Calculates when the date warning should begin.
  DateTime? get dateReminderStart {
    final dueDate = nextDueDate;

    if (dueDate == null || timeReminderThresholdDays == null) {
      return null;
    }

    return dueDate.subtract(
      Duration(days: timeReminderThresholdDays!),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleCloudId': vehicleCloudId,
      'reminderType': reminderType,
      'title': title,
      'enabled': enabled,
      'scheduleType': scheduleType,
      'sourceMaintenanceRecordId': sourceMaintenanceRecordId,
      'lastServiceOdometer': lastServiceOdometer,
      'lastServiceDate': _toTimestamp(lastServiceDate),
      'mileageInterval': mileageInterval,
      'mileageReminderThreshold': mileageReminderThreshold,
      'timeIntervalMonths': timeIntervalMonths,
      'timeReminderThresholdDays': timeReminderThresholdDays,
      'lastNotifiedForOdometer': lastNotifiedForOdometer,
      'lastNotifiedForDate': _toTimestamp(lastNotifiedForDate),
      'createdAt': _toTimestamp(createdAt),
      'updatedAt': _toTimestamp(updatedAt),
    };
  }

  factory ServiceReminderCloudModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    return ServiceReminderCloudModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      vehicleCloudId: map['vehicleCloudId'] as String? ?? '',
      reminderType: map['reminderType'] as String? ?? '',
      title: map['title'] as String? ?? '',
      enabled: map['enabled'] as bool? ?? true,
      scheduleType: map['scheduleType'] as String? ?? 'mileage',
      sourceMaintenanceRecordId: map['sourceMaintenanceRecordId'] as String?,
      lastServiceOdometer: _toNullableInt(
        map['lastServiceOdometer'],
      ),
      lastServiceDate: _toDateTime(
        map['lastServiceDate'],
      ),
      mileageInterval: _toNullableInt(
        map['mileageInterval'],
      ),
      mileageReminderThreshold: _toNullableInt(
        map['mileageReminderThreshold'],
      ),
      timeIntervalMonths: _toNullableInt(
        map['timeIntervalMonths'],
      ),
      timeReminderThresholdDays: _toNullableInt(
        map['timeReminderThresholdDays'],
      ),
      lastNotifiedForOdometer: _toNullableInt(
        map['lastNotifiedForOdometer'],
      ),
      lastNotifiedForDate: _toDateTime(
        map['lastNotifiedForDate'],
      ),
      createdAt: _toDateTime(
        map['createdAt'],
      ),
      updatedAt: _toDateTime(
        map['updatedAt'],
      ),
    );
  }

  ServiceReminderCloudModel copyWith({
    String? id,
    String? userId,
    String? vehicleCloudId,
    String? reminderType,
    String? title,
    bool? enabled,
    String? scheduleType,
    String? sourceMaintenanceRecordId,
    int? lastServiceOdometer,
    DateTime? lastServiceDate,
    int? mileageInterval,
    int? mileageReminderThreshold,
    int? timeIntervalMonths,
    int? timeReminderThresholdDays,
    int? lastNotifiedForOdometer,
    DateTime? lastNotifiedForDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceReminderCloudModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleCloudId: vehicleCloudId ?? this.vehicleCloudId,
      reminderType: reminderType ?? this.reminderType,
      title: title ?? this.title,
      enabled: enabled ?? this.enabled,
      scheduleType: scheduleType ?? this.scheduleType,
      sourceMaintenanceRecordId:
          sourceMaintenanceRecordId ?? this.sourceMaintenanceRecordId,
      lastServiceOdometer: lastServiceOdometer ?? this.lastServiceOdometer,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      mileageInterval: mileageInterval ?? this.mileageInterval,
      mileageReminderThreshold:
          mileageReminderThreshold ?? this.mileageReminderThreshold,
      timeIntervalMonths: timeIntervalMonths ?? this.timeIntervalMonths,
      timeReminderThresholdDays:
          timeReminderThresholdDays ?? this.timeReminderThresholdDays,
      lastNotifiedForOdometer:
          lastNotifiedForOdometer ?? this.lastNotifiedForOdometer,
      lastNotifiedForDate: lastNotifiedForDate ?? this.lastNotifiedForDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Timestamp? _toTimestamp(DateTime? value) {
    return value == null ? null : Timestamp.fromDate(value);
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static DateTime _addMonths(
    DateTime date,
    int months,
  ) {
    final targetMonth = date.month + months;
    final targetYear = date.year + ((targetMonth - 1) ~/ 12);
    final normalizedMonth = ((targetMonth - 1) % 12) + 1;

    final finalDay = _daysInMonth(
      targetYear,
      normalizedMonth,
    );

    return DateTime(
      targetYear,
      normalizedMonth,
      date.day > finalDay ? finalDay : date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  static int _daysInMonth(
    int year,
    int month,
  ) {
    return DateTime(year, month + 1, 0).day;
  }
}
