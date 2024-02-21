/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various navigation functions to navigate the different pages on the application
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import "package:flutter/material.dart";
import "package:maintenance_manager/add_vehicle_form.dart";
import "package:maintenance_manager/homepage.dart";
import 'dart:async';
import "package:maintenance_manager/my_vehicles.dart";

// Function to allow navigation to add vehicle form app page
  void navigateToAddVehicleFormPage(BuildContext context) {
    Navigator.push(
      context,
     MaterialPageRoute(builder: (context) => const AddVehicleFormApp()), // Create an instance of the AddVehicleForm class.
    );  
  }
  //void navigateToHomePage(BuildContext context) {
  //  Navigator.push(
  //    context,
  //    MaterialPageRoute(builder: (context) => const HomePage()), // Create an instance of the AddVehicleForm class.
  //  );  
  //}

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
    MaterialPageRoute(builder: (context) => DisplayVehicleLists()),
  ).then((_) {
    if (!navigationCompleter.isCompleted) {
      navigationCompleter.complete();
    }
  });
}