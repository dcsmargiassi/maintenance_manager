/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Utility File for general checks across the app.
 - Valid number check
 - Valid integer check
 - Valid date check
 - Confirm discard changes when leaving page without saving
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/cloud/read/fuel_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/read/vehicle_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/write/vehicle_cloud_write.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

bool isValidNumber(String? input) {
  if (input == null) return false;
  return double.tryParse(input) != null;
}

bool isValidInteger(String? input) {
  if (input == null) return false;
  return int.tryParse(input) != null;
}

bool isValidDate(String input) {
  final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$'); // MM/DD/YYYY
  if (!dateRegex.hasMatch(input)) return false;
  try {
    final parts = input.split('/');
    final month = int.parse(parts[0]);
    final day = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    DateTime parsed = DateTime(year, month, day);
    return parsed.month == month && parsed.day == day && parsed.year == year;
  } catch (_) {
    return false;
  }
}

Future<bool> confirmDiscardChanges(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.discardChangesButton),
      content: Text(AppLocalizations.of(context)!.discardChangesDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.leaveButton),
        ),
      ],
    ),
  ) ?? false;
}

// Lifetime Fuel Calculations

Future<void> incrementLifeTimeFuelCosts(String vehicleCloudId, String userId, double cost) async {
  // Check for blank fuel cost
  if(cost == 0) return;

  final vehicleReadOps = VehicleCloudReadOperations();
  final vehicleWriteOps = VehicleCloudWriteOperations();
  final data = await vehicleReadOps.getVehicleByCloudId(userId, vehicleCloudId);
  
  
  if(data == null) return;
  if (cost < 0.0) return;
  
  final oldCost = data.lifeTimeFuelCost;
  final newCost = oldCost + cost;

  await vehicleWriteOps.updateLifeTimeFuelCost(
    userId: userId,
    cloudVehicleId: vehicleCloudId,
    lifeTimeFuelCost: newCost,
  );
}

Future<void> decrementLifeTimeFuelCosts(String vehicleCloudId, String userId, double cost) async {
  // Check for blank fuel cost
  if(cost == 0) return;

   final vehicleReadOps = VehicleCloudReadOperations();
   final vehicleWriteOps = VehicleCloudWriteOperations();

   final data = await vehicleReadOps.getVehicleByCloudId(userId, vehicleCloudId);

  if (data == null) return;
  if (cost < 0.0) return;

  final oldCost = data.lifeTimeFuelCost;
  final newCost = (oldCost - cost).clamp(0.0, double.infinity).toDouble();

  await vehicleWriteOps.updateLifeTimeFuelCost(
    userId: userId,
    cloudVehicleId: vehicleCloudId,
    lifeTimeFuelCost: newCost,
  );
}

Future<void> recalculateFuelForAllVehicles(String userId) async {
  final vehicleReadOps = VehicleCloudReadOperations();
  final vehicleWriteOps = VehicleCloudWriteOperations();
  final fuelOps = FuelCloudReadOperations();

  final vehicles = await vehicleReadOps.getAllVehicles(userId);

  for (final vehicle in vehicles) {
    final fuelRecords = await fuelOps.fetchAllFuelRecordsForVehicle(
      userId: userId,
      vehicleCloudId: vehicle.cloudId,
    );

    final totalCost = fuelRecords.fold<double>(
      0.0,
      (currentTotal, record) => currentTotal + record.refuelCost,
    );

    await vehicleWriteOps.updateLifeTimeFuelCost(
      userId: userId,
      cloudVehicleId: vehicle.cloudId,
      lifeTimeFuelCost: totalCost,
    );
  }
}

// Updating current odometer number
Future<void> updateCurrentOdometerNumber(String vehicleCloudId, String userId, double newOdometerValue) async {
  final vehicleReadOps = VehicleCloudReadOperations();
  final vehicleWriteOps = VehicleCloudWriteOperations();

  final vehicle = await vehicleReadOps.getVehicleByCloudId(userId, vehicleCloudId);

  if (vehicle == null) return;

  final current = vehicle.odometerCurrent ?? 0.0;
  if (current >= newOdometerValue) return;

  await vehicleWriteOps.updateVehiclePatch(
    userId: userId,
    cloudVehicleId: vehicleCloudId,
    patch: {
      'odometerCurrent': newOdometerValue,
    },
  );
}

Map<int, String> getLocalizedMonthNames(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  return {
    1: loc.january,
    2: loc.february,
    3: loc.march,
    4: loc.april,
    5: loc.may,
    6: loc.june,
    7: loc.july,
    8: loc.august,
    9: loc.september,
    10: loc.october,
    11: loc.november,
    12: loc.december,
  };
}

// Locale mapping for language support

class LanguageProvider with ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
