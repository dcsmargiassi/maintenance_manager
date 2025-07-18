/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Edit Fuel Record page. Allows the user to edit previously entered information for fuel forms.
 - Allows any previous values to be altered.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:provider/provider.dart';

class EditFuelForm extends StatefulWidget {
  final int vehicleId;
  final int fuelRecordId;
  const EditFuelForm({super.key, required this.vehicleId, required this.fuelRecordId});

  @override
  State<EditFuelForm> createState() => _EditFuelFormState();
}

class _EditFuelFormState extends State<EditFuelForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fuelAmountController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();
  final TextEditingController refuelCostController = TextEditingController();
  final TextEditingController odometerAmountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  FuelRecords? fuelData;


  @override
  void initState() {
    super.initState();
    _loadFuelData();
  }

  Future<void> _loadFuelData() async {
    final fuelOps = FuelRecordOperations();
    final userId = Provider.of<AuthState>(context, listen: false).userId;
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    final data = await fuelOps.getFuelRecord(widget.vehicleId, userId!, widget.fuelRecordId);

    // Convert the doubles stored to strings for editing
    setState(() {
      fuelData = data;
      fuelAmountController.text = data.fuelAmount.toString();
      fuelPriceController.text = data.fuelPrice.toString();
      refuelCostController.text = data.refuelCost.toString();
      odometerAmountController.text = data.odometerAmount.toString();
      dateController.text = dateController.text = formatStoredDateForDisplay(data.date!, prefs.dateFormat);
    });
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
    final userId = authState.userId;
    //final userId = Provider.of<AuthState>(context, listen: false).userId;

    // Get user display preferences
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    if (fuelData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }
    return ConfirmableBackScaffold(
      title: AppLocalizations.of(context)!.editFuelRecordButton,
      showActions: false,
      onConfirmBack: () async {
        final shouldPop = await confirmDiscardChanges(context);
        if (shouldPop && context.mounted) {
          navigateToDisplayFuelRecordPage(context, widget.vehicleId);
        }
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: fuelAmountController,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fuelAmountLabel, 
                  hintText: AppLocalizations.of(context)!.fuelAmountLabelHint),
                validator: (value) => validateDecimalField(value, max: 5000),
              ),

              TextFormField(
                controller: fuelPriceController,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.fuelPriceLabel,
                  hintText: AppLocalizations.of(context)!.fuelPriceLabelHint,
                  prefix: Text(prefs.currencySymbol)
                  ),
                validator: (value) => validateDecimalField(value, max: 5000),
              ),

              TextFormField(
                controller: refuelCostController,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.totalFuelCostLabel,
                  hintText: AppLocalizations.of(context)!.totalFuelCostLabelHint,
                  prefix: Text(prefs.currencySymbol)
                ),
                validator: (value) => validateDecimalField(value, max: 5000),
              ),

              TextFormField(
                controller: odometerAmountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.odometerLabel,
                  hintText: AppLocalizations.of(context)!.odometerLabelHint),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                   return validateDecimalField(value, max: 2000000);
                },
              ),
              const SizedBox(height: 20),

              DateFormatField(
                type: DateFormatType.type4,
                controller: dateController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.dateLabel,
                  hintText: AppLocalizations.of(context)!.enterDateRefuelLabel,
                ),
                onComplete: (date) {
                  if (date != null) {
                    // format using user preference
                    final formatter = DateFormat(prefs.dateFormat);
                    setState(() {
                      dateController.text = formatter.format(date);
                    });
                  }
                },
              ),

              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Adjust the VehicleInformation table's lifeTimeFuelCost
                    final newRefuelCost = double.tryParse(refuelCostController.text) ?? 0.0;
                    await decrementLifeTimeFuelCosts(widget.vehicleId, userId!, fuelData!.refuelCost!);
                    await incrementLifeTimeFuelCosts(widget.vehicleId, userId, newRefuelCost);

                    // Store date with ISO 8601 format
                    final storedDate = DateFormat(prefs.dateFormat).parse(dateController.text).toIso8601String();

                    final updatedFuelRecord = FuelRecords(
                      fuelRecordId: widget.fuelRecordId,
                      vehicleId: widget.vehicleId,
                      userId: userId,
                      fuelAmount: double.tryParse(fuelAmountController.text) ?? 0.0,
                      fuelPrice: double.tryParse(fuelPriceController.text) ?? 0.0,
                      refuelCost: double.tryParse(refuelCostController.text) ?? 0.0,
                      odometerAmount: odometerAmountController.text.trim().isEmpty
                        ? 0.0
                        : double.tryParse(odometerAmountController.text),
                      date: storedDate,
                      notes: null,
                    );
                    await FuelRecordOperations().updateFuelRecord(updatedFuelRecord);
                    _loadFuelData();
                    if (!context.mounted) return;
                      navigateToDisplayFuelRecordPage(context, widget.vehicleId);
                  }
                },
                child: Text(AppLocalizations.of(context)!.updateButton),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    fuelAmountController.dispose();
    fuelPriceController.dispose();
    refuelCostController.dispose();
    odometerAmountController.dispose();
    dateController.dispose();
    super.dispose();
  }
}