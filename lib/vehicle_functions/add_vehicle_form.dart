import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';

// Creating object for vehicle information database
 VehicleOperations vehicleInformation = VehicleOperations();

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
        PopupMenuButton(
          onSelected: (choice) {
            if (choice == 'homePage') {
              navigateToHomePage(context);
            }
          },
          itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'homePage',
            child:Text('Return to HomePage'),
          ),
        ]
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
  final TextEditingController purchaseDateController = TextEditingController(); //version 2
  final TextEditingController sellDateController = TextEditingController(); //version 2
  final TextEditingController odometerBuyController = TextEditingController(); //version 2
  final TextEditingController odometerSellController = TextEditingController(); //version 2
  final TextEditingController odometerCurrentController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController(); //version 2
  final TextEditingController sellPriceController = TextEditingController(); //version 2

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Variable Declarations
  static const double buttonSpacingBoxHeight = 50.0; 
  //static const List<String> fuelTypeItemsList = <String>["Miles Per Hour", "Kilometers Per Hour", ];
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
            TextFormField(
              controller: vehicleNickNameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                hintText: 'Enter nickname of car',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            TextFormField(
              controller: vinController,
              decoration: const InputDecoration(
                labelText: 'VIN',
                hintText: 'Enter VIN of car',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            TextFormField(
              controller: makeController,
              decoration: const InputDecoration(
                labelText: 'Make',
                hintText: 'Enter make of car',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            TextFormField(
              controller: modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'Enter model of car',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            TextFormField(
              controller: versionController,
              decoration: const InputDecoration(
                labelText: 'Submodel',
                hintText: 'Enter submodel of car',
              ),
            ),

            TextFormField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
                hintText: 'Enter year of car',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if(!isValidInteger(yearController.text)){
                  return 'Year must be a number';
                }
                return null;
              },
            ),

            const SizedBox(height: buttonSpacingBoxHeight),

            TextFormField(
              controller: odometerCurrentController,
              decoration: const InputDecoration(
                labelText: 'Current Mileage',
                hintText: 'Enter current mileage of car',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if(!isValidNumber(odometerCurrentController.text)){
                  return 'Current Mileage must be a number';
                }
                return null;
              },
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
              decoration: const InputDecoration(
                labelText: 'Purchase Date',
                hintText: 'Enter purchase date of car',
              ),
              onComplete: (date) {
              setState(() {
                purchaseDateController.text = formatDateToString(date!);
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
                  final vehicleInformation = VehicleInformationModel(
                    userId: userId,
                    vehicleNickName: vehicleNickNameController.text,
                    vin: vinController.text,
                    make: makeController.text,
                    model: modelController.text,
                    version: versionController.text,
                    year: int.tryParse(yearController.text) ?? 0,
                    purchaseDate: purchaseDateController.text,
                    sellDate: null,//sellDateController.hashCode,
                    odometerBuy: null,//odometerBuyController.hashCode,
                    odometerSell: null,//odometerSellController.hashCode,
                    odometerCurrent: double.tryParse(odometerCurrentController.text) ?? 0,
                    purchasePrice: null,//purchasePriceController.hashCode,
                    sellPrice: null,//sellPriceController.hashCode
                    archived: archiveController,
                  );
                  //Create an instance of VehicleOperations
                  VehicleOperations vehicleOperations = VehicleOperations();
                  await vehicleOperations.createVehicle(vehicleInformation);
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
}