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
      title: const Text('Discard changes?'),
      content: const Text('You have unsaved changes. Are you sure you want to leave?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Leave'),
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

// Lifetime Maintenance Calculations