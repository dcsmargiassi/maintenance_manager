/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various navigation functions to navigate the different pages on the application.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import "package:flutter/material.dart";
import 'package:maintenance_manager/fuel_functions/add_fuel_record_form.dart';
import 'package:maintenance_manager/vehicle_functions/add_vehicle_form.dart';
import "package:maintenance_manager/create_account.dart";
import 'package:maintenance_manager/vehicle_functions/archived_vehicles.dart';
import 'package:maintenance_manager/vehicle_functions/edit_vehicle_information.dart';
import "package:maintenance_manager/homepage.dart";
import "package:maintenance_manager/login_page.dart";
import 'dart:async';
import 'package:maintenance_manager/vehicle_functions/my_vehicles.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_information.dart';
import 'package:maintenance_manager/fuel_functions/display_fuel_records.dart';

void navigateToAddVehicleFormPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddVehicleFormApp()),
  );  
}

Completer<void> navigationCompleter = Completer<void>();
void navigateToHomePage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToMyVehicles(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DisplayVehicleLists()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToArchivedVehicles(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DisplayArchivedVehicleLists()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToSpecificVehiclePage(BuildContext context, int vehicleId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DisplayVehicleInfo(vehicleId: vehicleId),
      ),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

Future<void> navigateToEditVehiclePage(
  BuildContext context, 
  int vehicleId, {
    VoidCallback? onReturn,
  }) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditVehicleForm(vehicleId: vehicleId)),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
    if (onReturn != null) {
      onReturn();
    }
  });
}

void navigateToCreateAccountPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CreateAccountPage()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignInPage()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToAddFuelRecordPage(BuildContext context, int vehicleId)  { 
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddFuelRecordFormApp(vehicleId: vehicleId)),
    ).then((_) {
     if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToDisplayFuelRecordPage(BuildContext context, int vehicleId) { 
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DisplayFuelRecords(vehicleId: vehicleId)),
    ).then((_) {
     if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}