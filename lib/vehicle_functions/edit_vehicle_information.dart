/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Edit Vehicle information page. Allows the user to edit previously entered information for specified vehicle.
 - Allows any previous values to be altered.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/cloud_models/battery_detail_records.dart';
import 'package:maintenance_manager/cloud_models/engine_detail_records.dart';
import 'package:maintenance_manager/cloud_models/exterior_detail_records.dart';
import 'package:maintenance_manager/cloud_models/vehicle_detail_records.dart';
import 'package:maintenance_manager/data/cloud/read/battery_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/read/engine_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/read/exterior_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/read/vehicle_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/write/battery_cloud_write.dart';
import 'package:maintenance_manager/data/cloud/write/engine_cloud_write.dart';
import 'package:maintenance_manager/data/cloud/write/exterior_cloud_write.dart';
import 'package:maintenance_manager/data/cloud/write/vehicle_cloud_write.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/battery_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/engine_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/exterior_details.dart';
import 'package:maintenance_manager/vehicle_functions/vehicle_stats/vehicle_details.dart';
import 'package:provider/provider.dart';

class EditVehicleForm extends StatefulWidget {
  final String vehicleCloudId;
  
  final dynamic archivedStatus;
  const EditVehicleForm({super.key, required this.vehicleCloudId, required this.archivedStatus});

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
  late double lifeTimeFuelCost;
  late double lifeTimeMaintenanceCost;

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
  TextEditingController exteriorDetailsIdController = TextEditingController();
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
  VehicleInformationCloudModel? vehicleData;
  EngineDetailsCloudModel? engineData;
  BatteryDetailsCloudModel? batteryData;
  ExteriorDetailsCloudModel? exteriorData;
  
  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    final userId = Provider.of<AuthState>(context, listen: false).userId;
    final vehicleOps = VehicleCloudReadOperations();
    final engineOps = EngineCloudReadOperations();
    final batteryOps = BatteryCloudReadOperations();
    final exteriorOps = ExteriorCloudReadOperations();
    final dataVehicle = await vehicleOps.getVehicleByCloudId(userId, widget.vehicleCloudId);
    final dataEngine = await engineOps.getEngineDetails(userId, widget.vehicleCloudId);
    final dataBattery = await batteryOps.getBatteryDetails(userId, widget.vehicleCloudId);
    final dataExterior = await exteriorOps.getExteriorDetails(userId, widget.vehicleCloudId);
  
    setState(() {
      vehicleData = dataVehicle!;
      engineData = dataEngine;
      batteryData = dataBattery;
      exteriorData = dataExterior;

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
      archiveController = dataVehicle.archived;
      lifeTimeFuelCost = dataVehicle.lifeTimeFuelCost;
      lifeTimeMaintenanceCost = dataVehicle.lifeTimeMaintenanceCost;
      licensePlateController.text = dataVehicle.licensePlate!;

      engineSizeController.text = dataEngine?.engineSize ?? '';
      cylinderController.text = dataEngine?.cylinders ?? '';
      engineTypeController.text = dataEngine?.engineType ?? '';
      oilWeightController.text = dataEngine?.oilWeight ?? '';
      oilCompositionController.text = dataEngine?.oilComposition ?? '';
      oilClassController.text = dataEngine?.oilClass ?? '';
      oilFilterController.text = dataEngine?.oilFilter ?? '';
      engineFilterController.text = dataEngine?.engineFilter ?? '';

      batterySeriesTypeController.text = dataBattery?.batterySeriesType ?? '';
      batterySizeController.text = dataBattery?.batterySize ?? '';
      coldCrankAmpsController.text = dataBattery?.coldCrankAmps.toString() ?? '';

      driverWindshieldWiperController.text = dataExterior.driverWindshieldWiper.toString();
      passengerWindshieldWiperController.text = dataExterior.passengerWindshieldWiper.toString();
      rearWindshieldWiperController.text = dataExterior.rearWindshieldWiper.toString();
      headlampHighBeamController.text = dataExterior.headlampHighBeam.toString();
      headlampLowBeamController.text = dataExterior.headlampLowBeam.toString();
      turnLampController.text = dataExterior.turnLamp.toString();
      backupLampController.text = dataExterior.backupLamp.toString();
      fogLampController.text = dataExterior.fogLamp.toString();
      brakeLampController.text = dataExterior.brakeLamp.toString();
      licensePlateLampController.text = dataExterior.licensePlateLamp.toString();
    });
    }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    // ignore: unnecessary_null_comparison
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
            navigateToSpecificVehiclePage(context, widget.vehicleCloudId);
          }
          if(widget.archivedStatus == 1){
            navigateToSpecificArchivedVehiclePage(context, widget.vehicleCloudId);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.editVehicle),
          ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.car_rental, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.vehicleDetails,
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
                  title: Row(
                    children: [
                      Icon(Icons.engineering_sharp, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.engineDetails,
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
                  title: Row(
                    children: [
                      Icon(Icons.battery_std, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.batteryDetails,
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
            ExpansionTile(
              title: Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.exteriorDetails,
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
                    licensePlateLampController: licensePlateLampController,
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

                    final vehicleInformation = VehicleInformationCloudModel(
                      cloudId: widget.vehicleCloudId,
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
                      lifeTimeFuelCost: lifeTimeFuelCost,
                      lifeTimeMaintenanceCost: lifeTimeMaintenanceCost,
                      licensePlate: licensePlateController.text,
                    );
                    VehicleCloudWriteOperations vehicleOperations = VehicleCloudWriteOperations();
                    await vehicleOperations.updateVehicle(vehicleInformation);

                    // Engine Details

                    EngineDetailsCloudModel engineDetails = EngineDetailsCloudModel(
                      cloudId: 'engineDetails',
                      userId: userId,
                      vehicleCloudId: widget.vehicleCloudId,
                      engineSize: engineSizeController.text,
                      cylinders: cylinderController.text,
                      engineType: engineTypeController.text,
                      oilWeight: oilWeightController.text,
                      oilComposition: oilCompositionController.text,
                      oilClass: oilClassController.text,
                      oilFilter: oilFilterController.text,
                      engineFilter: engineFilterController.text,
                    );
                    EngineCloudWriteOperations engineDetailsOperations = EngineCloudWriteOperations();
                    await engineDetailsOperations.updateEngineDetails(engineDetails);
                    
                    // Battery Details

                    BatteryDetailsCloudModel batteryDetails = BatteryDetailsCloudModel(
                      cloudId: 'batteryDetails',
                      userId: userId,
                      vehicleCloudId: widget.vehicleCloudId,
                      batterySeriesType: batterySeriesTypeController.text,
                      batterySize: batterySizeController.text,
                      coldCrankAmps: double.tryParse(coldCrankAmpsController.text),
                    );
                    BatteryCloudWriteOperations batteryDetailsOperations = BatteryCloudWriteOperations();
                    await batteryDetailsOperations.updateBatteryDetails(batteryDetails);

                    // Exterior Details

                    // Exterior Details

                  ExteriorDetailsCloudModel exteriorDetails = ExteriorDetailsCloudModel( 
                    cloudId: 'exteriorDetails',
                    userId: userId, 
                    vehicleCloudId: widget.vehicleCloudId, 
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
                  ExteriorCloudWriteOperations exteriorDetailsOperations = ExteriorCloudWriteOperations();
                  await exteriorDetailsOperations.updateExteriorDetails(exteriorDetails);
                  //final exists = await exteriorDetailsOperations.exteriorDetailsExists(userId, widget.vehicleCloudId);
                  //if (exists) {
                  //  await exteriorDetailsOperations.updateExteriorDetails(exteriorDetails);
                  //} else {
                  //  await exteriorDetailsOperations.insertExteriorDetails(exteriorDetails);
                  //}
                    if (!context.mounted) return;
                    if(archiveController == 0){
                      navigateToSpecificVehiclePage(context, widget.vehicleCloudId);
                    }
                    else {
                      navigateToSpecificArchivedVehiclePage(context, widget.vehicleCloudId);
                    }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.submitButton),
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
    exteriorDetailsIdController.dispose();
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