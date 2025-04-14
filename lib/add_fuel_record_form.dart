import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:provider/provider.dart';

/// Flutter code sample for [Form].

// Creating object for vehicle information database
 //VehicleOperations vehicleInformation = VehicleOperations();


class AddFuelRecordFormApp extends StatelessWidget {
  const AddFuelRecordFormApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: const Text(
          'Add Fuel Record',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 32,
            fontWeight: FontWeight.bold
          )
        ),
          backgroundColor: const Color.fromARGB(255, 44, 43, 44),
          elevation: 0.0,
          centerTitle: true,
          actions: [
          PopupMenuButton(
            onSelected: (choice) {
              if (choice == 'Exit') {
                Navigator.pop(context); // Go back to the previous page.
              }
            },
            itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Exit',
              child:Text('Return to HomePage'),
            ),
          ]
          ),
          ]
        ),
        body: const AddVehicleForm(),
      ),
      debugShowCheckedModeBanner: false,
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
  final TextEditingController fuelAmountController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();
  final TextEditingController refuelCostController = TextEditingController();
  final TextEditingController odometerAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Variable Declarations
  static const double buttonSpacingBoxHeight = 50.0; 
  String selectedUnit = "Miles Per Hour";
  

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
            TextFormField(
              controller: fuelAmountController,
              decoration: const InputDecoration(
                hintText: 'Enter amount of fuel',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),

            TextFormField(
              controller: fuelPriceController,
              decoration: const InputDecoration(
                hintText: 'Enter price of fuel',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),

            TextFormField(
              controller: refuelCostController,
              decoration: const InputDecoration(
                hintText: 'Total Cost of Fuel',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),

            TextFormField(
              controller: odometerAmountController,
              decoration: const InputDecoration(
                hintText: 'Enter current odometer number',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            const SizedBox(height: buttonSpacingBoxHeight),

            DateFormatField(
              type: DateFormatType.type4,
              controller: dateController,
              decoration: const InputDecoration(
                hintText: 'Enter date of refuel',
              ),
              onComplete: (date) {
              setState(() {
                dateController.text = formatDateToString(date!);
              });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                  final fuelRecords = FuelRecords(
                      fuelRecordId: null,
                      userId: userId,
                      vehicleId: 0,
                      fuelAmount: double.parse(fuelAmountController.text),
                      fuelPrice: double.parse(fuelPriceController.text),
                      refuelCost: double.parse(refuelCostController.text),
                      odometerAmount: double.parse(odometerAmountController.text),
                      date: formatDateToString(dateController.text as DateTime),
                      notes: null,
                    );
                  //Create an instance of VehicleOperations
                  FuelRecordOperations fuelOperations = FuelRecordOperations();
                  await fuelOperations.createFuelRecord(fuelRecords);
                  if (!context.mounted) return;
                    navigationCompleter = Completer<void>();
                    navigateToHomePage(context);
                    await navigationCompleter.future;
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
}
