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
  int _numFilledFields = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Variable Declarations
  static const double buttonSpacingBoxHeight = 50.0; 
  String selectedUnit = "Miles Per Hour";

  String? isoDateToStore;
  @override
  void initState() {
    super.initState();
    isoDateToStore = DateTime.now().toIso8601String();
    fuelAmountController.addListener(_updateNumFilledFields);
    fuelPriceController.addListener(_updateNumFilledFields);
    refuelCostController.addListener(_updateNumFilledFields);
    //Auto filling the date field
    final now = DateTime.now();
    isoDateToStore = now.toIso8601String();
    dateController.text = formatDateToString(now);
  }

  void _updateNumFilledFields() {
    int count = 0;
    if (fuelAmountController.text.trim().isNotEmpty) count++;
    if (fuelPriceController.text.trim().isNotEmpty) count++;
    if (refuelCostController.text.trim().isNotEmpty) count++;

    setState(() {
      _numFilledFields = count;
    });
  }

  void _calculateMissingField() {
    double? amount = double.tryParse(fuelAmountController.text);
    double? price = double.tryParse(fuelPriceController.text);
    double? cost = double.tryParse(refuelCostController.text);

    int filled = 0;
    if (amount != null) filled++;
    if (price != null) filled++;
    if (cost != null) filled++;

    if (filled != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill 2 of the fields above.')),
      );
      return;
    }

    if (amount != null && price != null && cost == null) {
      double newCost = amount * price;
      refuelCostController.text = newCost.toStringAsFixed(2);
    } else if (amount != null && cost != null && price == null && amount != 0) {
      double newPrice = cost / amount;
      fuelPriceController.text = newPrice.toStringAsFixed(2);
    } else if (price != null && cost != null && amount == null && price != 0) {
      double newAmount = cost / price;
      fuelAmountController.text = newAmount.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    String? userId = authState.userId;

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
        title: const Text(
          'Add Fuel Record',
        ),
        centerTitle: true,
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
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: fuelAmountController,
                  maxLength: 8,
                  decoration: const InputDecoration(
                    labelText: 'Fuel Amount',
                    hintText: 'Enter amount of fuel',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    // Parsing value
                    final parsed = double.tryParse(value);
                    if(parsed == null){
                      return 'Please enter valid cost';
                    }
                    // Max/min fuel limit
                    if (parsed > 5000){
                      return 'Enter a realistic cost';
                    }
                    if (parsed < 0){
                      return 'No negatives';
                    }
                    // check decimal places
                    final decimalMatch = RegExp(r'^\d+(\.\d{1,3})?$');
                    if(!decimalMatch.hasMatch(value)) {
                      return 'Max 3 decimal places allowed';
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),

                TextFormField(
                  controller: fuelPriceController,
                  maxLength: 8,
                  decoration: const InputDecoration(
                    labelText: 'Fuel Price',
                    hintText: 'Enter price of fuel',
                    prefix: Text('\$'),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    // Parsing value
                    final parsed = double.tryParse(value);
                    if(parsed == null){
                      return 'Please enter valid cost';
                    }
                    // Max/min cost limit
                    if (parsed > 5000){
                      return 'Enter a realistic cost';
                    }
                    if (parsed < 0){
                      return 'No negatives';
                    }
                    // check decimal places
                    final decimalMatch = RegExp(r'^\d+(\.\d{1,3})?$');
                    if(!decimalMatch.hasMatch(value)) {
                      return 'Max 3 decimal places allowed';
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),

                TextFormField(
                  controller: refuelCostController,
                  maxLength: 8,
                  decoration: const InputDecoration(
                    labelText: 'Total Cost',
                    hintText: 'Total Cost of Fuel',
                    prefix: Text("\$"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cost of fuel';
                    }
                    // Parsing value
                    final parsed = double.tryParse(value);
                    if(parsed == null){
                      return 'Please enter valid cost';
                    }
                    // Max/min cost limit
                    if (parsed > 5000){
                      return 'Enter a realistic cost';
                    }
                    if (parsed < 0){
                      return 'No negatives';
                    }
                    // check decimal places
                    final decimalMatch = RegExp(r'^\d+(\.\d{1,3})?$');
                    if(!decimalMatch.hasMatch(value)) {
                      return 'Max 3 decimal places allowed';
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
                    if (value != null && value.trim().isNotEmpty) {
                      final parsedValue = double.tryParse(value);
                      if (parsedValue == null){
                      return 'Please enter a number';
                      }
                      if (parsedValue < 0) {
                        return 'No negatives';
                      }
                      if(parsedValue > 2500000){
                        return 'Please enter realistic value';
                      }
                      // Check decimal places
                      final decimalMatch = RegExp(r'^\d+(\.\d{1,2})?$');
                        if(!decimalMatch.hasMatch(value)) {
                          return 'Max 2 decimal places allowed';
                        }
                    }
                    return null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),

                const SizedBox(height: buttonSpacingBoxHeight),

                // Button to calculate missing field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: _numFilledFields == 2 ? _calculateMissingField : null,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate Missing Field'),
                  ),
                ),

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
                          odometerAmount: odometerAmountController.text.trim().isEmpty
                            ? 0.0
                            : double.parse(odometerAmountController.text),
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
