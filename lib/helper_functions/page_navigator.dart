/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various navigation functions to navigate the different pages on the application.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import "package:flutter/material.dart";
import "package:maintenance_manager/add_fuel_record_form.dart";
import "package:maintenance_manager/add_vehicle_form.dart";
import "package:maintenance_manager/create_account.dart";
import "package:maintenance_manager/homepage.dart";
import "package:maintenance_manager/login_page.dart";
import 'dart:async';
import "package:maintenance_manager/my_vehicles.dart";
import "package:maintenance_manager/vehicle_information.dart";

void navigateToAddVehicleFormPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddVehicleFormApp()), // Create an instance of the AddVehicleForm class.
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
    MaterialPageRoute(builder: (context) => SignInPage()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}

void navigateToAddFuelRecordPage(BuildContext context, int? vehicleId) { 
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddFuelRecordFormApp()),
    ).then((_) {
     if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}