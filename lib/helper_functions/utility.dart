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
import 'package:maintenance_manager/data/database_operations.dart';
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

Future<void> incrementLifeTimeFuelCosts(int vehicleId, String userId, double cost) async {
  // Check for blank fuel cost
  if(cost == 0) return;
   final vehicleOps = VehicleOperations();
   final data = await vehicleOps.getVehicleById(vehicleId, userId);
   
   if(cost >= 0.0){
    double oldCost = data.lifeTimeFuelCost ?? 0.0;
    double newCost = oldCost + cost;
    data.lifeTimeFuelCost = newCost;
    await vehicleOps.updateLifeTimeFuelCost(data);
   }
}

Future<void> decrementLifeTimeFuelCosts(int vehicleId, String userId, double cost) async {
  // Check for blank fuel cost
  if(cost == 0) return;
   final vehicleOps = VehicleOperations();
   final data = await vehicleOps.getVehicleById(vehicleId, userId);
   if(cost >= 0.0 && data.lifeTimeFuelCost != null){
    double? oldCost = data.lifeTimeFuelCost;
    double newCost = (oldCost! - cost).clamp(0.0, double.infinity);
    data.lifeTimeFuelCost = newCost;
    await vehicleOps.updateLifeTimeFuelCost(data);
   }
}

Future<void> recalculateFuelForAllVehicles(String userId) async {
  final vehicleOps = VehicleOperations();
  final fuelOps = FuelRecordOperations();

  final vehicles = await vehicleOps.getAllVehicles(userId);

  for (final vehicle in vehicles) {
    final fuelRecords = await fuelOps.getAllFuelRecordsByVehicleId(userId, vehicle.vehicleId!);

    final totalCost = fuelRecords.fold(0.0, (sum, record) {
      return sum + (record.refuelCost ?? 0.0);
    });

    vehicle.lifeTimeFuelCost = totalCost;
    await vehicleOps.updateLifeTimeFuelCost(vehicle);
  }
}

// Updating current odometer number
Future<void> updateCurrentOdometerNumber(int vehicleId, String userId, double newOdometerValue) async {
  final vehicleOps = VehicleOperations();
  final vehicle = await vehicleOps.getVehicleById(vehicleId, userId);

  if (vehicle.odometerCurrent! >= newOdometerValue) return;
  if (vehicle.odometerCurrent! < newOdometerValue) {
    vehicle.odometerCurrent = newOdometerValue;
  }
  await vehicleOps.updateVehicle(vehicle);
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
