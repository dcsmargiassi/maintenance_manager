/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Edit Vehicle information page. Allows the user to edit previously entered information for specified vehicle.
 - Allows any previous values to be altered.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';
import 'package:maintenance_manager/models/exterior_detail_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/battery_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/engine_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/vehicle_details.dart';
import 'package:provider/provider.dart';

class EditVehicleForm extends StatefulWidget {
  final int vehicleId;
  
  final dynamic archivedStatus;
  const EditVehicleForm({super.key, required this.vehicleId, required this.archivedStatus});

  @override
  State<EditVehicleForm> createState() => _EditVehicleFormState();
}

class _EditVehicleFormState extends State<EditVehicleForm> {
  final _formKey = GlobalKey<FormState>();

  // Vehicle Controllers
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
  late int archiveController = 0;
  final TextEditingController licensePlateController = TextEditingController();

  // Engine Controllers
  TextEditingController engineDetailsIdController = TextEditingController();
  final TextEditingController engineSizeController = TextEditingController(); // Ex 1.5 L
  final TextEditingController cylinderController = TextEditingController(); // Ex 4 Cylinder ( I4)
  final TextEditingController engineTypeController = TextEditingController(); // Gas, diesel, hybrid Etc.
  final TextEditingController oilWeightController = TextEditingController(); //5W-20, 5W-30, etc
  final TextEditingController oilCompositionController = TextEditingController(); // Synthetic Blend, Conventional, etc
  final TextEditingController oilClassController = TextEditingController(); // Standard, Diesel, High Mileage
  final TextEditingController oilFilterController = TextEditingController(); // Ex S7317XL
  final TextEditingController engineFilterController = TextEditingController(); // Ex FA-1785

  // Battery Controllers
  TextEditingController batteryDetailsIdController = TextEditingController();
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

  String selectedUnit = "Miles Per Hour";
  VehicleInformationModel? vehicleData;
  


  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    final vehicleOps = VehicleOperations();
    final engineOps = EngineDetailsOperations();
    final batteryOps = BatteryDetailsOperations();
    final userId = Provider.of<AuthState>(context, listen: false).userId;
    final dataVehicle = await vehicleOps.getVehicleById(widget.vehicleId, userId!);
    final dataEngine = await engineOps.getEngineDetailsByVehicleId(userId, widget.vehicleId);
    final dataBattery = await batteryOps.getBatteryDetailsByVehicleId(userId, widget.vehicleId);
    int? engineDetailsId;
    int? batteryDetailsId;
    engineDetailsId = dataEngine.engineDetailsId;
    batteryDetailsId = dataBattery.batteryDetailsId!;
  
    setState(() {
      vehicleData = dataVehicle;
      vehicleNickNameController.text = dataVehicle.vehicleNickName ?? '';
      vinController.text = dataVehicle.vin ?? '';
      makeController.text = dataVehicle.make ?? '';
      modelController.text = dataVehicle.model ?? '';
      versionController.text = dataVehicle.version ?? '';
      yearController.text = dataVehicle.year.toString();
      purchaseDateController.text = dataVehicle.purchaseDate ?? '';
      sellDateController.text = dataVehicle.sellDate ?? '';
      odometerBuyController.text = dataVehicle.odometerBuy.toString();
      odometerSellController.text = dataVehicle.odometerSell.toString();
      odometerCurrentController.text = dataVehicle.odometerCurrent.toString();
      purchasePriceController.text = dataVehicle.purchasePrice.toString();
      sellPriceController.text = dataVehicle.sellPrice.toString();
      archiveController = dataVehicle.archived!;

      engineDetailsIdController.text = engineDetailsId.toString();
      engineSizeController.text = dataEngine.engineSize!;
      cylinderController.text = dataEngine.cylinders!;
      engineTypeController.text = dataEngine.engineType!;
      oilWeightController.text = dataEngine.oilWeight!;
      oilCompositionController.text = dataEngine.oilComposition!;
      oilClassController.text = dataEngine.oilClass!;
      oilFilterController.text = dataEngine.oilFilter!;
      engineFilterController.text = dataEngine.engineFilter!;

      batteryDetailsIdController.text = batteryDetailsId.toString();
      batterySeriesTypeController.text = dataBattery.batterySeriesType ?? '';
      batterySizeController.text = dataBattery.batterySize ?? '';
      coldCrankAmpsController.text = dataBattery.coldCrankAmps.toString();
    });
    }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    if (vehicleData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text( 'Vehicle Data not found, try again!',
              style: TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon:  const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]
          )
        )
        );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        final shouldPop = await confirmDiscardChanges(context);
        if (shouldPop == true && context.mounted) {
          if(widget.archivedStatus == 0){
            navigateToSpecificVehiclePage(context, widget.vehicleId);
          }
          if(widget.archivedStatus == 1){
            navigateToSpecificArchivedVehiclePage(context, widget.vehicleId);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Custom backspace button
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white
              ),
            onPressed: () async {
              final shouldPop = await confirmDiscardChanges(context);
                if (shouldPop && context.mounted) {
                navigateToSpecificVehiclePage(context, widget.vehicleId);
                }
              },
            ),
          title: const Text('Edit Vehicle'),
          ),
        body: SingleChildScrollView(
          
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: BatteryDetailsSection(
                    batterySeriesTypeController: batterySeriesTypeController,
                    batterySizeController: batterySizeController,
                    coldCrankAmpsController: coldCrankAmpsController,
                  ),
                ),
              ],
            ),  
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if form is invalid
                    if (_formKey.currentState!.validate()) {

                      // Vehicle Details

                    final vehicleInformation = VehicleInformationModel(
                      vehicleId: widget.vehicleId,
                      userId: userId,
                      vehicleNickName: vehicleNickNameController.text,
                      vin: vinController.text,
                      make: makeController.text,
                      model: modelController.text,
                      version: versionController.text,
                      year: int.tryParse(yearController.text) ?? 0,
                      purchaseDate: purchaseDateController.text,
                      sellDate: null,
                      odometerBuy: double.parse(odometerBuyController.text),
                      odometerSell: null,
                      odometerCurrent: double.tryParse(odometerCurrentController.text) ?? 0,
                      purchasePrice: double.parse(purchasePriceController.text),
                      sellPrice: null,
                      archived: archiveController,
                    );
                    VehicleOperations vehicleOperations = VehicleOperations();
                    await vehicleOperations.updateVehicle(vehicleInformation);

                    // Engine Details

                    EngineDetailsModel engineDetails = EngineDetailsModel(
                      engineDetailsId: int.tryParse(engineDetailsIdController.text),
                      userId: userId,
                      vehicleId: widget.vehicleId,
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
                    await engineDetailsOperations.updateEngineDetails(engineDetails);
                    
                    // Battery Details

                    BatteryDetailsModel batteryDetails = BatteryDetailsModel(
                      batteryDetailsId: int.tryParse(batteryDetailsIdController.text),
                      userId: userId!,
                      vehicleId: widget.vehicleId,
                      batterySeriesType: batterySeriesTypeController.text,
                      batterySize: batterySizeController.text,
                      coldCrankAmps: double.tryParse(coldCrankAmpsController.text),
                    );
                    BatteryDetailsOperations batteryDetailsOperations = BatteryDetailsOperations();
                    await batteryDetailsOperations.updateBatteryDetails(batteryDetails);

                    // Exterior Details

                    // Exterior Details

                  ExteriorDetailsModel exteriorDetails = ExteriorDetailsModel( 
                    userId: userId, 
                    vehicleId: widget.vehicleId, 
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
                    if(archiveController == 0){
                      navigateToSpecificVehiclePage(context, widget.vehicleId);
                    }
                    else {
                      navigateToSpecificArchivedVehiclePage(context, widget.vehicleId);
                    }
                    }
                  },
                  child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Vehicle Controllers
    vehicleNickNameController.dispose();
    vinController.dispose();
    makeController.dispose();
    modelController.dispose();
    versionController.dispose();
    yearController.dispose();
    purchaseDateController.dispose();
    odometerBuyController.dispose();
    odometerSellController.dispose();
    odometerCurrentController.dispose();
    purchasePriceController.dispose();
    sellPriceController.dispose();
    licensePlateController.dispose();

    // Engine Controllers
    engineDetailsIdController.dispose();
    engineSizeController.dispose();
    cylinderController.dispose();
    engineTypeController.dispose();
    oilWeightController.dispose();
    oilCompositionController.dispose();
    oilClassController.dispose();
    oilFilterController.dispose();
    engineFilterController.dispose();

    // Battery Controllers
    batteryDetailsIdController.dispose();
    batterySeriesTypeController.dispose();
    batterySizeController.dispose();
    coldCrankAmpsController.dispose();

    //Exterior Controllers
    driverWindshieldWiperController.dispose();
    passengerWindshieldWiperController.dispose();
    rearWindshieldWiperController.dispose();
    headlampHighBeamController.dispose();
    headlampLowBeamController.dispose();
    turnLampController.dispose();
    backupLampController.dispose();
    fogLampController.dispose();
    brakeLampController.dispose();
    licensePlateLampController.dispose();
    super.dispose();
  }
}