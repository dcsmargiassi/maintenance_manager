import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';
import 'package:maintenance_manager/models/exterior_detail_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/battery_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/engine_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/exterior_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/vehicle_details.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Creating object for vehicle information database
 VehicleOperations vehicleInformation = VehicleOperations();

 // Creating object for engine details database
 EngineDetailsOperations engineDetails = EngineDetailsOperations();

 // Creating object for battery details database
 BatteryDetailsOperations batteryDetails = BatteryDetailsOperations();

 // Creating object for exterior details database
 ExteriorDetailsOperations exteriorDetails = ExteriorDetailsOperations();

class AddVehicleFormApp extends StatelessWidget {
  const AddVehicleFormApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle Form'),
        // Custom backspace button
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) async {
              switch (choice) {
              case 'Profile':
                await navigateToProfilePage(context);
                break;
              case 'HomePage':
                await navigateToHomePage(context);
                break;
              case 'Settings':
                await navigateToSettingsPage(context);
                break;
              case 'signout':
                await navigateToLogin(context);
                break;
            }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'HomePage',
                child: Text('HomePage'),
              ),
              PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'signout',
                child: Text('Sign Out'),
              ),
            ],
          ),
        ]
      ),
      body: const AddVehicleForm(),
    );
  }
}

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});
  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  // Vehicle Controller Variable Declarations
  final int archiveController = 0;
  final TextEditingController vehicleNickNameController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController sellDateController = TextEditingController();
  final TextEditingController odometerBuyController = TextEditingController();
  final TextEditingController odometerSellController = TextEditingController();
  final TextEditingController odometerCurrentController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController sellPriceController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();

  // Engine Controllers
  final TextEditingController engineSizeController = TextEditingController(); // Ex 1.5 L
  final TextEditingController cylinderController = TextEditingController(); // Ex 4 Cylinder ( I4)
  final TextEditingController engineTypeController = TextEditingController(); // Gas, diesel, hybrid Etc.
  final TextEditingController oilWeightController = TextEditingController(); //5W-20, 5W-30, etc
  final TextEditingController oilCompositionController = TextEditingController(); // Synthetic Blend, Conventional, etc
  final TextEditingController oilClassController = TextEditingController(); // Standard, Diesel, High Mileage
  final TextEditingController oilFilterController = TextEditingController(); // Ex S7317XL
  final TextEditingController engineFilterController = TextEditingController(); // Ex FA-1785

  // Battery Controllers
  final TextEditingController batterySeriesTypeController = TextEditingController(); // Ex BXT
  final TextEditingController batterySizeController = TextEditingController(); // BCI number
  final TextEditingController coldCrankAmpsController = TextEditingController();

  //Exterior Controllers
  final TextEditingController driverWindshieldWiperController = TextEditingController(); // Ex 1.5 L
  final TextEditingController passengerWindshieldWiperController = TextEditingController(); // Ex 4 Cylinder ( I4)
  final TextEditingController rearWindshieldWiperController = TextEditingController(); // Gas, diesel, hybrid Etc.
  final TextEditingController headlampHighBeamController = TextEditingController(); // H7LL
  final TextEditingController headlampLowBeamController = TextEditingController(); // H11LL
  final TextEditingController turnLampController = TextEditingController(); // T20
  final TextEditingController backupLampController = TextEditingController(); // 921
  final TextEditingController fogLampController = TextEditingController();
  final TextEditingController brakeLampController = TextEditingController();
  final TextEditingController licensePlateLampController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Checking Privacy Analytics
  Future<bool> _isPrivacyAnalyticsEnabled(String? userId) async {
  if (userId == null) return false;
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  return doc.data()?['privacyAnalytics'] == false;
}
  // Variable Declarations
  String selectedUnit = "Miles Per Hour"; // Default unit

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    var userId = authState.userId;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[ 
            // Vehicle Details
            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.car_rental, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Vehicle Details",
                  ),
                ],
              ),
              initiallyExpanded: true,
              trailing: const Icon(Icons.expand_more_sharp),
              tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: VehicleDetailsSection(
                    vehicleNickNameController: vehicleNickNameController,
                    vinController: vinController,
                    makeController: makeController,
                    modelController: modelController,
                    versionController: versionController,
                    yearController: yearController,
                    purchaseDateController: purchaseDateController,
                    sellDateController: sellDateController,
                    odometerBuyController: odometerBuyController,
                    odometerSellController: odometerSellController,
                    odometerCurrentController: odometerCurrentController,
                    purchasePriceController: purchasePriceController,
                    sellPriceController: sellPriceController,
                    licensePlateController: licensePlateController,
                  ),
                ),
              ],
            ),
            // EXTENDED DETAILS
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: const [
                      Tooltip(
                        message: "",
                        child: Icon(Icons.info_outline, color: Colors.grey),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Fill these details for future reference on the go!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ENGINE DETAILS

            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.engineering_sharp, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Engine Details",
                  ),
                ],
              ),
              initiallyExpanded: false,
              trailing: const Icon(Icons.expand_more_sharp),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: EngineDetailsSection(
                    engineSizeController: engineSizeController,
                    cylinderController: cylinderController,
                    engineTypeController: engineTypeController,
                    oilWeightController: oilWeightController,
                    oilCompositionController: oilCompositionController,
                    oilClassController: oilClassController,
                    oilFilterController: oilFilterController,
                    engineFilterController: engineFilterController,
                  ),
                ),
              ],
            ),

            // BATTERY DETAILS

            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.battery_std, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Battery Details",
                  ),
                ],
              ),
              initiallyExpanded: false,
              trailing: const Icon(Icons.expand_more_sharp),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BatteryDetailsSection(
                    batterySeriesTypeController: batterySeriesTypeController,
                    batterySizeController: batterySizeController,
                    coldCrankAmpsController: coldCrankAmpsController,
                  ),
                ),
              ],
            ),

            // BRAKE DETAILS

            // FLUID DETAILS

            // CABIN DETAILS

            // Exterior Details

            ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    "Exterior Details",
                  ),
                ],
              ),
              initiallyExpanded: false,
              trailing: const Icon(Icons.expand_more_sharp),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ExteriorDetailsSection(
                    driverWindshieldWiperController: driverWindshieldWiperController,
                    passengerWindshieldWiperController: passengerWindshieldWiperController,
                    rearWindshieldWiperController: rearWindshieldWiperController,
                    headlampHighBeamController: headlampHighBeamController,
                    headlampLowBeamController: headlampLowBeamController,
                    turnLampController: turnLampController,
                    backupLampController: backupLampController,
                    fogLampController: fogLampController,
                    brakeLampController: brakeLampController,
                    licensePlateLampController: licensePlateController,
                  ),
                ),
              ],
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if form is invalid
                  if (_formKey.currentState!.validate()) {

                    // Vehicle Details

                  final vehicleInformation = VehicleInformationModel(
                    userId: userId,
                    vehicleNickName: vehicleNickNameController.text,
                    vin: vinController.text,
                    make: makeController.text,
                    model: modelController.text,
                    version: versionController.text,
                    year: int.tryParse(yearController.text) ?? 0,
                    purchaseDate: purchaseDateController.text,
                    sellDate: null,
                    odometerBuy: double.tryParse(odometerBuyController.text) ?? 0,
                    odometerSell: null,
                    odometerCurrent: double.tryParse(odometerCurrentController.text),
                    purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
                    sellPrice: null,
                    archived: archiveController,
                    licensePlate: licensePlateController.text,
                  );
                  VehicleOperations vehicleOperations = VehicleOperations();
                  int vehicleId = await vehicleOperations.createVehicle(vehicleInformation);

                  // Engine Details

                  EngineDetailsModel engineDetails = EngineDetailsModel(
                    userId: userId,
                    vehicleId: vehicleId,
                    engineSize: engineSizeController.text,
                    cylinders: cylinderController.text,
                    engineType: engineTypeController.text,
                    oilWeight: oilWeightController.text,
                    oilComposition: oilCompositionController.text,
                    oilClass: oilClassController.text,
                    oilFilter: oilFilterController.text,
                    engineFilter: engineFilterController.text,
                  );
                  EngineDetailsOperations engineDetailsOperations = EngineDetailsOperations();
                  await engineDetailsOperations.insertEngineDetails(engineDetails);

                  // Battery Details

                  final ccaText = coldCrankAmpsController.text.trim();
                  final cca = ccaText.isEmpty ? 0.0 : double.parse(ccaText);
                  BatteryDetailsModel batteryDetails = BatteryDetailsModel(
                    userId: userId!,
                    vehicleId: vehicleId,
                    batterySeriesType: batterySeriesTypeController.text,
                    batterySize: batterySizeController.text,
                    coldCrankAmps: cca,
                  );
                  BatteryDetailsOperations batteryDetailsOperations = BatteryDetailsOperations();
                  await batteryDetailsOperations.insertBatteryDetails(batteryDetails);

                  // Exterior Details

                  ExteriorDetailsModel exteriorDetails = ExteriorDetailsModel( 
                    userId: userId, 
                    vehicleId: vehicleId, 
                    driverWindshieldWiper: driverWindshieldWiperController.text, 
                    passengerWindshieldWiper: passengerWindshieldWiperController.text, 
                    rearWindshieldWiper: rearWindshieldWiperController.text, 
                    headlampHighBeam: headlampHighBeamController.text, 
                    headlampLowBeam: headlampLowBeamController.text, 
                    turnLamp: turnLampController.text, 
                    backupLamp: backupLampController.text, 
                    fogLamp: fogLampController.text, 
                    brakeLamp: brakeLampController.text, 
                    licensePlateLamp: licensePlateLampController.text,
                  );
                  ExteriorDetailsOperations exteriorDetailsOperations = ExteriorDetailsOperations();
                  await exteriorDetailsOperations.insertExteriorDetails(exteriorDetails);

                  if (!context.mounted) return;
                  // Check if user has enabled privacy analytics
                  final privacyEnabled = await _isPrivacyAnalyticsEnabled(userId);
                  if (privacyEnabled) {
                    final analytics = FirebaseAnalytics.instance;
                    await analytics.logEvent(
                      name: 'vehicle_created',
                      parameters: {
                        'make': makeController.text.trim(),
                        'model': modelController.text.trim(),
                      },
                    );
                  }
                  if (!context.mounted) return;
                  navigateToHomePage(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    vehicleNickNameController.dispose();
    vinController.dispose();
    makeController.dispose();
    modelController.dispose();
    versionController.dispose();
    yearController.dispose();
    purchaseDateController.dispose();
    sellDateController.dispose();
    odometerBuyController.dispose();
    odometerSellController.dispose();
    odometerCurrentController.dispose();
    purchasePriceController.dispose();
    sellPriceController.dispose();
    licensePlateController.dispose();

    // Engine Controllers
    engineSizeController.dispose();
    cylinderController.dispose();
    engineTypeController.dispose();
    oilWeightController.dispose();
    oilCompositionController.dispose();
    oilClassController.dispose();
    oilFilterController.dispose();
    engineFilterController.dispose();

    // Battery Controllers
    batterySeriesTypeController.dispose();
    batterySizeController.dispose();
    coldCrankAmpsController.dispose();

    super.dispose();
  }
}