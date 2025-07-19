import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
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
        SnackBar(content: Text(AppLocalizations.of(context)!.fillInTwoFields)),
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
  // Validator for numerical input fields
  String? validateDecimalField(
    String? value, {
      required double max,
      int maxDecimalPlaces = 3,
    }
  ) {
    if (value == null || value.trim().isEmpty) return AppLocalizations.of(context)!.emptyMessageText;
    final parsed = double.tryParse(value);
    if (parsed == null) return AppLocalizations.of(context)!.enterValidNumber;
    if (parsed < 0) return AppLocalizations.of(context)!.noNegatives;
    if (parsed > max) return AppLocalizations.of(context)!.enterRealisticValue;
    final decimalMatch = RegExp(r'^\d+(\.\d{1,' + maxDecimalPlaces.toString() + r'})?$');
    if (!decimalMatch.hasMatch(value)) return AppLocalizations.of(context)!.maxDecimalPlacesMessage(maxDecimalPlaces);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final prefs = Provider.of<UserPreferences>(context, listen: false);
    String? userId = authState.userId;

    //Auto filling the date field
    if (dateController.text.isEmpty) {
      final now = DateTime.now();
      dateController.text = DateFormat(prefs.dateFormat).format(now);
      isoDateToStore = now.toIso8601String();
    }

    return ConfirmableBackScaffold(
      title: AppLocalizations.of(context)!.addFuelRecordButton,
      onConfirmBack: () async { 
        final shouldPop = await confirmDiscardChanges(context);
          if (shouldPop && context.mounted) {
          navigateToSpecificVehiclePage(context, widget.vehicleId);
        }
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: fuelAmountController,
                maxLength: 8,
                decoration:  InputDecoration(
                  labelText: AppLocalizations.of(context)!.fuelAmountLabel,
                  hintText: AppLocalizations.of(context)!.fuelAmountLabelHint,
                ),
                validator: (value) => validateDecimalField(value, max: 5000),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),

              TextFormField(
                controller: fuelPriceController,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fuelPriceLabel,
                  hintText: AppLocalizations.of(context)!.fuelPriceLabelHint,
                  prefix: Text(prefs.currencySymbol),
                ),
                validator: (value) => validateDecimalField(value, max: 5000),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),

              TextFormField(
                controller: refuelCostController,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.totalFuelCostLabel,
                  hintText: AppLocalizations.of(context)!.totalFuelCostLabelHint,
                  prefix: Text(prefs.currencySymbol),
                ),
                validator: (value) => validateDecimalField(value, max: 5000),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              
              TextFormField(
                controller: odometerAmountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.odometerLabel,
                  hintText: AppLocalizations.of(context)!.odometerLabelHint,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                   return validateDecimalField(value, max: 2000000);
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
                  label: Text(AppLocalizations.of(context)!.calculateMissingFieldLabel),
                ),
              ),
              DateFormatField(
                type: DateFormatType.type4,
                controller: dateController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.dateLabel,
                  hintText: AppLocalizations.of(context)!.enterDateRefuelLabel,
                ),
                onComplete: (date) {
                  if (date != null) {
                    isoDateToStore = date.toIso8601String();
                    setState(() {
                      dateController.text = DateFormat(prefs.dateFormat).format(date);
                    });
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
                          SnackBar(content: Text(AppLocalizations.of(context)!.enterValidDateMessage)),
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
                          SnackBar(content: 
                            Text (
                              AppLocalizations.of(context)!.errorSavingFuelRecordMessage(e.toString())
                            )
                          ),
                        );
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
