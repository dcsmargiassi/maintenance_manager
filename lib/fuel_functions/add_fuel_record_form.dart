import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:provider/provider.dart';

class AddFuelRecordFormApp extends StatefulWidget {
  final int vehicleId;
  const AddFuelRecordFormApp({super.key, required this.vehicleId});

  @override
  AddFuelRecordFormAppState createState() => AddFuelRecordFormAppState();
}

class AddFuelRecordFormAppState extends State<AddFuelRecordFormApp> {
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

  String? isoDateToStore;
  @override
  void initState() {
    super.initState();
    isoDateToStore = DateTime.now().toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    String? userId = authState.userId;
    final screenSize = MediaQuery.of(context).size;
    final double titleFontSize = screenSize.width * 0.06;

    return Scaffold(
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
        title: Text(
          'Add Fuel Record',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: const Color.fromARGB(255, 44, 43, 44),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (choice) {
              if (choice == 'Exit') {
                navigateToHomePage(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Exit',
                child: Text('Return to HomePage'),
              ),
            ],
          ),
        ],
      ),
      body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) return;
            final shouldPop = await confirmDiscardChanges(context);
            if (shouldPop && context.mounted) {
            navigateToSpecificVehiclePage(context, widget.vehicleId);
            }
          },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: fuelAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Fuel Amount',
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
                    labelText: 'Fuel Price',
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
                    labelText: 'Total Cost',
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
                    labelText: 'Odometer',
                    hintText: 'Enter current odometer number (Optional)',
                  ),
                  validator: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      final parsedValue = double.tryParse(value);
                      if (parsedValue == null){
                      return 'Please enter some text';
                      }
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),

                const SizedBox(height: buttonSpacingBoxHeight),

                DateFormatField(
                  type: DateFormatType.type4,
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'Enter date of refuel',
                  ),
                  onComplete: (date) {
                    if (date != null) {
                      // Convert to iso8601 string for database
                      final isoDate = date.toIso8601String();
                      isoDateToStore = isoDate;
                      // Convert to make readable in form
                      dateController.text = formatDateToString(date);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        //Check for valid date selection
                        if (isoDateToStore == null){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a valid date.')),
                          );
                          return;
                        }
                      // Creating fuel record instance
                      final fuelRecords = FuelRecords(
                          fuelRecordId: null,
                          userId: userId,
                          vehicleId: widget.vehicleId,
                          fuelAmount: double.parse(fuelAmountController.text),
                          fuelPrice: double.parse(fuelPriceController.text),
                          refuelCost: double.parse(refuelCostController.text),
                          odometerAmount: double.parse(odometerAmountController.text),
                          date: isoDateToStore,//dateController.text,
                          notes: null,
                        );
                      //Create an instance of VehicleOperations
                      final FuelRecordOperations fuelOperations = FuelRecordOperations();
                      try {
                        await fuelOperations.createFuelRecord(fuelRecords);
                        if (!context.mounted) return;

                          // Updating lifetime fuel costs.
                          await incrementLifeTimeFuelCosts(widget.vehicleId, userId!, double.parse(refuelCostController.text));

                          if (!context.mounted) return;
                          // Navigate back to specific vehicle page
                          navigateToSpecificVehiclePage(context, widget.vehicleId);
                        }
                        catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text ("Error saving fuel record: $e")),
                          );
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
    fuelAmountController.dispose();
    fuelPriceController.dispose();
    refuelCostController.dispose();
    odometerAmountController.dispose();
    dateController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
