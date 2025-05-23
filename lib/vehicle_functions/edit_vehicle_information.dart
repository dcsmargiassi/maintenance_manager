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
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:provider/provider.dart';

class EditVehicleForm extends StatefulWidget {
  final int vehicleId;
  const EditVehicleForm({super.key, required this.vehicleId});

  @override
  State<EditVehicleForm> createState() => _EditVehicleFormState();
}

class _EditVehicleFormState extends State<EditVehicleForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController vehicleNickNameController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController odometerCurrentController = TextEditingController();

  String selectedUnit = "Miles Per Hour";
  VehicleInformationModel? vehicleData;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    final vehicleOps = VehicleOperations();
    final userId = Provider.of<AuthState>(context, listen: false).userId;
    final data = await vehicleOps.getVehicleById(widget.vehicleId, userId!);

    setState(() {
      vehicleData = data;
      vehicleNickNameController.text = data.vehicleNickName!;
      vinController.text = data.vin!;
      makeController.text = data.make!;
      modelController.text = data.model!;
      versionController.text = data.version!;
      yearController.text = data.year.toString();
      purchaseDateController.text = data.purchaseDate ?? '';
      odometerCurrentController.text = data.odometerCurrent.toString();
    });
    }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    if (vehicleData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
        );
    }
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return;
          final shouldPop = await confirmDiscardChanges(context);
          if (shouldPop == true && context.mounted) {
            navigateToSpecificVehiclePage(context, widget.vehicleId);
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
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: vehicleNickNameController,
                    decoration: const InputDecoration(hintText: 'Enter nickname of car'),
                    validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
                  ),
                  TextFormField(
                    controller: vinController,
                    decoration: const InputDecoration(hintText: 'Enter VIN of car'),
                    validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
                  ),
                  TextFormField(
                    controller: makeController,
                    decoration: const InputDecoration(hintText: 'Enter make of car'),
                    validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
                  ),
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(hintText: 'Enter model of car'),
                    validator: (value) => value!.isEmpty ? 'Please enter some text' : null,
                  ),
                  TextFormField(
                    controller: versionController,
                    decoration: const InputDecoration(hintText: 'Enter submodel of car'),
                  ),
                  TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(hintText: 'Enter year of car'),
                    validator: (value) {
                     if (value!.isEmpty) return 'Please enter the year';
                     if (!isValidInteger(value)) return 'Please enter valid number';
                     return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: odometerCurrentController,
                    decoration: const InputDecoration(hintText: 'Enter current mileage of car'),
                    validator: (value) {
                     if (value!.isEmpty) return 'Please enter current odometer number';
                     if (!isValidNumber(value)) return 'Please enter valid number';
                     return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton<String>(
                    value: selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUnit = newValue!;
                      });
                    },
                    items: <String>['Miles Per Hour', 'Kilometers Per Liter']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DateFormatField(
                    type: DateFormatType.type4,
                    controller: purchaseDateController,
                    decoration: const InputDecoration(hintText: 'Enter purchase date of car'),
                    onComplete: (date) {
                      if (date != null) {
                        purchaseDateController.text = formatDateToString(date);
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedVehicle = VehicleInformationModel(
                          vehicleId: widget.vehicleId,
                          userId: userId,
                          vehicleNickName: vehicleNickNameController.text,
                          vin: vinController.text,
                          make: makeController.text,
                          model: modelController.text,
                          version: versionController.text,
                          year: int.tryParse(yearController.text) ?? 0,
                          purchaseDate: purchaseDateController.text,
                          sellDate: vehicleData!.sellDate,
                          odometerBuy: vehicleData!.odometerBuy,
                          odometerSell: vehicleData!.odometerSell,
                          odometerCurrent: double.tryParse(odometerCurrentController.text) ?? 0.0,
                          purchasePrice: vehicleData!.purchasePrice,
                          sellPrice: vehicleData!.sellPrice,
                          archived: vehicleData!.archived,
                        );

                        await VehicleOperations().updateVehicle(updatedVehicle);
                        _loadVehicleData();
                        if (!context.mounted) return;
                          navigateToSpecificVehiclePage(context, widget.vehicleId);
                      }
                    },
                    child: const Text('Update Vehicle'),
                  ),
                ],
              ),
            ),
        )
      )
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
    odometerCurrentController.dispose();
    super.dispose();
  }
}