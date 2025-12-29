import 'package:maintenance_manager/models/exterior_detail_records.dart';
import 'package:maintenance_manager/cloud_models/exterior_detail_records.dart';

class ExteriorDetailsMapper {
  // Convert Local SQLite -> Cloud Firestore
  static ExteriorDetailsCloudModel localToCloud(
    ExteriorDetailsModel local,
    String cloudDocId,
    String userId,
    String vehicleCloudId,
  ) {
    return ExteriorDetailsCloudModel(
      id: cloudDocId,
      userId: userId,
      vehicleCloudId: vehicleCloudId,
      driverWindshieldWiper: local.driverWindshieldWiper ?? '',
      passengerWindshieldWiper: local.passengerWindshieldWiper ?? '',
      rearWindshieldWiper: local.rearWindshieldWiper ?? '',
      headlampHighBeam: local.headlampHighBeam ?? '',
      headlampLowBeam: local.headlampLowBeam ?? '',
      turnLamp: local.turnLamp ?? '',
      backupLamp: local.backupLamp ?? '',
      fogLamp: local.fogLamp ?? '',
      brakeLamp: local.brakeLamp ?? '',
      licensePlateLamp: local.licensePlateLamp ?? '',
    );
  }

  // Convert Cloud Firestore -> Local SQLite
  static ExteriorDetailsModel cloudToLocal(
    ExteriorDetailsCloudModel cloud,
    String userId,
    int vehicleId,
  ) {
    return ExteriorDetailsModel(
      exteriorDetailsId: null, // SQLite will auto-assign
      userId: cloud.userId,
      vehicleId: vehicleId,
      driverWindshieldWiper: cloud.driverWindshieldWiper,
      passengerWindshieldWiper: cloud.passengerWindshieldWiper,
      rearWindshieldWiper: cloud.rearWindshieldWiper,
      headlampHighBeam: cloud.headlampHighBeam,
      headlampLowBeam: cloud.headlampLowBeam,
      turnLamp: cloud.turnLamp,
      backupLamp: cloud.backupLamp,
      fogLamp: cloud.fogLamp,
      brakeLamp: cloud.brakeLamp,
      licensePlateLamp: cloud.licensePlateLamp,
    );
  }
}