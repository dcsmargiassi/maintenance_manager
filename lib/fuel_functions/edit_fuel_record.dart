/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Edit Fuel Record page. Allows the user to edit previously entered information for fuel forms.
 - Allows any previous values to be altered.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
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
    final data = await fuelOps.getFuelRecord(widget.vehicleId, userId!, widget.fuelRecordId);

    // Convert the doubles stored to strings for editing
    setState(() {
      fuelData = data;
      fuelAmountController.text = data.fuelAmount.toString();
      fuelPriceController.text = data.fuelPrice.toString();
      refuelCostController.text = data.refuelCost.toString();
      odometerAmountController.text = data.odometerAmount.toString();
      dateController.text = data.date!;
    });
    }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthState>(context, listen: false).userId;

    if (fuelData == null) {
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
            navigateToDisplayFuelRecordPage(context, widget.vehicleId);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Fuel Record'),
            // Custom backspace button
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white
              ),
              onPressed: () {
                navigateToDisplayFuelRecordPage(context, widget.vehicleId);
              },
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: fuelAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Amount', 
                      hintText: 'Enter Fuel Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please Enter Fuel Amount';
                      if (!isValidNumber(value)) return 'Please enter valid Number';
                      return null;
                    }
                  ),
                  TextFormField(
                    controller: fuelPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Fuel Price',
                      hintText: 'Enter Fuel Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please Enter Fuel Amount';
                      if (!isValidNumber(value)) return 'Please enter valid Number'; 
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: refuelCostController,
                    decoration: const InputDecoration(
                      labelText: 'Refuel Cost',
                      hintText: 'Enter Refuel Cost'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please Enter Total Cost';
                      if (!isValidNumber(value)) return 'Please enter valid Number'; 
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: odometerAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Odometer (Optional)',
                      hintText: 'Enter current Odometer Number'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      if (!isValidNumber(value)) return 'Please enter valid number';
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                 
                  DateFormatField(
                    type: DateFormatType.type4,
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'Enter purchase date of car'),
                    onComplete: (date) {
                      if (date != null) {
                        dateController.text = formatDateToString(date);
                      }
                    },
                  ),

                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedFuelRecord = FuelRecords(
                          fuelRecordId: widget.fuelRecordId,
                          vehicleId: widget.vehicleId,
                          userId: userId,
                          fuelAmount: double.tryParse(fuelAmountController.text) ?? 0.0,
                          fuelPrice: double.tryParse(fuelPriceController.text) ?? 0.0,
                          refuelCost: double.tryParse(refuelCostController.text) ?? 0.0,
                          odometerAmount: odometerAmountController.text.trim().isEmpty
                            ? null
                            : double.tryParse(odometerAmountController.text),
                          date: dateController.text,
                          notes: null,
                        );

                        await FuelRecordOperations().updateFuelRecord(updatedFuelRecord);
                        _loadFuelData();
                        if (!context.mounted) return;
                          navigateToDisplayFuelRecordPage(context, widget.vehicleId);
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
    fuelAmountController.dispose();
    fuelPriceController.dispose();
    refuelCostController.dispose();
    odometerAmountController.dispose();
    dateController.dispose();
    super.dispose();
  }
}