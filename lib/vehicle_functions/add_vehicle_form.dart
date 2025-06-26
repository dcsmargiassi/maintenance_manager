import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/battery_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/engine_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/vehicle_details.dart';
import 'package:provider/provider.dart';

// Creating object for vehicle information database
 VehicleOperations vehicleInformation = VehicleOperations();

 // Creating object for engine details database
 EngineDetailsOperations engineDetails = EngineDetailsOperations();

 // Creating object for Miscellaneous details database
 BatteryDetailsOperations batteryDetails = BatteryDetailsOperations();

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
                await navigateToHomePage(context);
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  ),
                ),
              ],
            ),
            // EXTENDED DETAILS
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if form is invalid
                  if (_formKey.currentState!.validate()) {
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
                    odometerBuy: double.tryParse(odometerBuyController.text),
                    odometerSell: null,
                    odometerCurrent: double.tryParse(odometerCurrentController.text),
                    purchasePrice: double.tryParse(purchasePriceController.text),
                    sellPrice: null,
                    archived: archiveController,
                  );
                  VehicleOperations vehicleOperations = VehicleOperations();
                  int vehicleId = await vehicleOperations.createVehicle(vehicleInformation);
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
                  BatteryDetailsModel batteryDetails = BatteryDetailsModel(
                    userId: userId!,
                    vehicleId: vehicleId,
                    batterySeriesType: batterySeriesTypeController.text,
                    batterySize: batterySizeController.text,
                    coldCrankAmps: double.tryParse(coldCrankAmpsController.text),
                  );
                  BatteryDetailsOperations batteryDetailsOperations = BatteryDetailsOperations();
                  await batteryDetailsOperations.insertBatteryDetails(batteryDetails);
                  //Create an instance of VehicleOperations
                  //VehicleOperations vehicleOperations = VehicleOperations();
                  //await vehicleOperations.createVehicle(vehicleInformation);
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