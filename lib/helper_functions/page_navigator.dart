/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various navigation functions to navigate the different pages on the application.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/account_functions/create_account.dart';
import 'package:maintenance_manager/account_functions/edit_profile.dart';
import 'package:maintenance_manager/account_functions/password_reset.dart';
import 'package:maintenance_manager/account_functions/profile_page.dart';
import 'package:maintenance_manager/fuel_functions/edit_fuel_record.dart';
import 'package:maintenance_manager/account_functions/signin_page.dart';
import 'package:maintenance_manager/homepage.dart';
import 'package:maintenance_manager/settings/display_options.dart';
import 'package:maintenance_manager/settings/manage_data.dart';
import 'package:maintenance_manager/settings/privacy_policy_display.dart';
import 'package:maintenance_manager/settings/settings.dart';
import 'package:maintenance_manager/settings/terms_of_service_display.dart';
import 'package:maintenance_manager/vehicle_functions/guest_vehicle_information.dart';
import 'package:maintenance_manager/vehicle_functions/my_vehicles.dart';
import 'package:maintenance_manager/vehicle_functions/add_vehicle_form.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_information.dart';
import 'package:maintenance_manager/vehicle_functions/edit_vehicle_information.dart';
import 'package:maintenance_manager/vehicle_functions/archived_vehicles.dart';
import 'package:maintenance_manager/vehicle_functions/archived_vehicle_information.dart';
import 'package:maintenance_manager/fuel_functions/add_fuel_record_form.dart';
import 'package:maintenance_manager/fuel_functions/fuel_record_list.dart';

Completer<void> navigationCompleter = Completer<void>();

// Authentication and home Pages

Future<void> navigateToCreateAccountPage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CreateAccountPage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToLogin(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignInPage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToHomePage(BuildContext context, {VoidCallback? onReturn, bool showGlobalActions = true}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToProfilePage(BuildContext context, {VoidCallback? onReturn, bool showGlobalActions = true}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ProfilePage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToEditProfilePage(BuildContext context, {VoidCallback? onReturn, bool showGlobalActions = true}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EditProfilePage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToResetPasswordPage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
  ).then((_) => onReturn?.call());
}

// Settings Page
Future<void> navigateToSettingsPage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DisplaySettings()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToPrivacyPolicy(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToTermsOfServicePage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const TermsOfServicePage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToManageDataPage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ManageDataPage()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToDisplayOptionsPage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DisplayOptionsPage()),
  ).then((_) => onReturn?.call());
}

// Vehicle Functions

Future<void> navigateToMyVehicles(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DisplayVehicleLists()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToAddVehicleFormPage(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddVehicleFormApp()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToSpecificVehiclePage(BuildContext context, int vehicleId, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DisplayVehicleInfo(vehicleId: vehicleId)),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToGuestVehicleDisplayPage(BuildContext context, {VoidCallback? onReturn,}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const GuestDisplayVehicleInfoPage(),
    ),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToEditVehiclePage(BuildContext context, int vehicleId, int archivedStatus, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditVehicleForm(vehicleId: vehicleId, archivedStatus: archivedStatus,)),
  ).then((_) => onReturn?.call());
}

// Archived Vehicles

Future<void> navigateToArchivedVehicles(BuildContext context, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const DisplayArchivedVehicleLists()),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToSpecificArchivedVehiclePage(BuildContext context, int vehicleId, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DisplayArchivedVehicleInfo(vehicleId: vehicleId)),
  ).then((_) => onReturn?.call());
}

// Fuel Records

Future<void> navigateToAddFuelRecordPage(BuildContext context, int vehicleId, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddFuelRecordFormApp(vehicleId: vehicleId)),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToDisplayFuelRecordPage(BuildContext context, int vehicleId, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DisplayFuelLists(vehicleId: vehicleId)),
  ).then((_) => onReturn?.call());
}

Future<void> navigateToEditFuelRecordPage(BuildContext context, int vehicleId, int fuelRecordId, {VoidCallback? onReturn}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditFuelForm(vehicleId: vehicleId, fuelRecordId: fuelRecordId,)),
  ).then((_) => onReturn?.call());
}