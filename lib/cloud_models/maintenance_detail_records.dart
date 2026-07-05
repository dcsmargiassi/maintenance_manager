import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceRecordCloudModel {
  final String id;
  final String userId;
  final String vehicleCloudId;
  final String maintenanceType;
  final String title;
  final String date;
  final Timestamp? createdAt;
  final double? odometer;
  final double totalCost;
  final String? shopName;
  final String? notes;
  final Map<String, dynamic> details;
  final List<String> attachmentUrls;

  MaintenanceRecordCloudModel({
    required this.id,
    required this.userId,
    required this.vehicleCloudId,
    required this.maintenanceType,
    required this.title,
    required this.date,
    required this.createdAt,
    this.odometer,
    required this.totalCost,
    this.shopName,
    this.notes,
    this.details = const {},
    this.attachmentUrls = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleCloudId': vehicleCloudId,
      'maintenanceType': maintenanceType,
      'title': title,
      'date': date,
      'createdAt': createdAt,
      'odometer': odometer,
      'totalCost': totalCost,
      'shopName': shopName,
      'notes': notes,
      'details': details,
      'attachmentUrls': attachmentUrls,
    };
  }

  factory MaintenanceRecordCloudModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return MaintenanceRecordCloudModel(
      id: id,
      userId: map['userId'] ?? '',
      vehicleCloudId: map['vehicleCloudId'] ?? '',
      maintenanceType: map['maintenanceType'] ?? 'other',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
      odometer: (map['odometer'] as num?)?.toDouble(),
      totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0.0,
      shopName: map['shopName'],
      notes: map['notes'],
      details: Map<String, dynamic>.from(map['details'] ?? {}),
      attachmentUrls: List<String>.from(map['attachmentUrls'] ?? []),
    );
  }

  static const _unset = Object();
  MaintenanceRecordCloudModel copyWith({
    String? id,
    String? userId,
    String? vehicleCloudId,
    String? maintenanceType,
    String? title,
    String? date,
    Timestamp? createdAt,
    Object? odometer = _unset,
    double? totalCost,
    Object? shopName = _unset,
    Object? notes = _unset,
    Map<String, dynamic>? details,
    Object? attachmentUrls = _unset,
  }) {
    return MaintenanceRecordCloudModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleCloudId: vehicleCloudId ?? this.vehicleCloudId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      title: title ?? this.title,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      odometer:
          identical(odometer, _unset) ? this.odometer : odometer as double?,
      totalCost: totalCost ?? this.totalCost,
      shopName:
          identical(shopName, _unset) ? this.shopName : shopName as String?,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      details: details ?? this.details,
      attachmentUrls: identical(attachmentUrls, _unset)
          ? this.attachmentUrls
          : attachmentUrls as List<String>,
    );
  }
}
