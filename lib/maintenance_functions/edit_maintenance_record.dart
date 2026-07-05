import 'package:date_format_field/date_format_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/cloud_models/maintenance_detail_records.dart';
import 'package:maintenance_manager/constants/maintenance_detail_fields.dart';
import 'package:maintenance_manager/constants/maintenance_field_labels.dart';
import 'package:maintenance_manager/constants/maintenance_field_options.dart';
import 'package:maintenance_manager/constants/maintenance_field_types.dart';
import 'package:maintenance_manager/constants/maintenance_type_labels.dart';
import 'package:maintenance_manager/constants/maintenance_types.dart';
import 'package:maintenance_manager/data/cloud/read/maintenance_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/write/maintenance_cloud_write.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/reusable_widgets.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/helper_functions/validators.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/maintenance_functions/maintenance_prefill.dart';
import 'package:provider/provider.dart';

class EditMaintenanceRecordFormApp extends StatefulWidget {
  final String vehicleCloudId;
  final String maintenanceRecordCloudId;

  const EditMaintenanceRecordFormApp({
    super.key,
    required this.vehicleCloudId,
    required this.maintenanceRecordCloudId,
  });

  @override
  State<EditMaintenanceRecordFormApp> createState() =>
      EditMaintenanceRecordFormAppState();
}

class EditMaintenanceRecordFormAppState
    extends State<EditMaintenanceRecordFormApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController odometerController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final Map<String, TextEditingController> _detailControllers = {};
  final Map<String, dynamic> _details = {};
  final MaintenancePrefillService _prefillService = MaintenancePrefillService();

  MaintenanceRecordCloudModel? _record;
  String _selectedMaintenanceType = MaintenanceTypes.oilChange;
  String? isoDateToStore;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    final userId = Provider.of<AuthState>(context, listen: false).userId;

    final record =
        await MaintenanceCloudReadOperations().getMaintenanceRecordByCloudId(
      userId: userId,
      vehicleCloudId: widget.vehicleCloudId,
      maintenanceRecordCloudId: widget.maintenanceRecordCloudId,
    );

    if (!mounted) return;

    if (record == null) {
      setState(() => _isLoading = false);
      return;
    }

    final prefs = Provider.of<UserPreferences>(context, listen: false);

    _record = record;
    _selectedMaintenanceType = record.maintenanceType;
    isoDateToStore = record.date;

    titleController.text = record.title;
    dateController.text = formatDateForUser(record.date, prefs.dateFormat);
    odometerController.text = record.odometer?.toString() ?? '';
    totalCostController.text = record.totalCost.toStringAsFixed(2);
    shopNameController.text = record.shopName ?? '';
    notesController.text = record.notes ?? '';

    _details.clear();
    _details.addAll(record.details);

    for (final entry in _details.entries) {
      final fieldType = MaintenanceFieldTypes.typeFor(entry.key);

      if (fieldType != MaintenanceFieldTypes.boolean &&
          fieldType != MaintenanceFieldTypes.dropdown) {
        _detailControllers[entry.key] =
            TextEditingController(text: entry.value?.toString() ?? '');
      }
    }

    setState(() => _isLoading = false);
  }

  TextEditingController _controllerForDetailField(String fieldKey) {
    return _detailControllers.putIfAbsent(
      fieldKey,
      () => TextEditingController(
        text: _details[fieldKey]?.toString() ?? '',
      ),
    );
  }

  void _changeMaintenanceType(String type) {
    for (final controller in _detailControllers.values) {
      controller.dispose();
    }

    _detailControllers.clear();
    _details.clear();

    setState(() {
      _selectedMaintenanceType = type;
    });
  }

  Widget _buildMaintenanceTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedMaintenanceType,
      decoration: const InputDecoration(
        labelText: 'Maintenance Type',
      ),
      items: MaintenanceTypes.all.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(MaintenanceTypeLabels.labelFor(type)),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        _changeMaintenanceType(value);
      },
    );
  }

  //Function to, if applicable, autofill details upon click of button for maintenance fields. QOL feature
  Future<void> _autofillDetails() async {
    final userId = Provider.of<AuthState>(context, listen: false).userId;

    final prefill = await MaintenancePrefillService().getPrefillDetails(
      userId: userId,
      vehicleCloudId: widget.vehicleCloudId,
      maintenanceType: _selectedMaintenanceType,
    );

    setState(() {
      _details.addAll(prefill);

      for (final entry in prefill.entries) {
        final fieldType = MaintenanceFieldTypes.typeFor(entry.key);

        if (fieldType != MaintenanceFieldTypes.boolean &&
            fieldType != MaintenanceFieldTypes.dropdown &&
            fieldType != MaintenanceFieldTypes.dropdownSearch) {
          final controller = _controllerForDetailField(entry.key);
          controller.text = entry.value?.toString() ?? '';
        }
      }
    });
  }

  Widget _buildDynamicDetailsSection() {
    final fields = MaintenanceDetailFields.fieldsFor(_selectedMaintenanceType);

    if (fields.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text(
        'Maintenance Details',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: fields.map(_buildDynamicField).toList(),
    );
  }

  Widget _buildDynamicField(String fieldKey) {
    final label = MaintenanceFieldLabels.labelFor(fieldKey);
    final fieldType = MaintenanceFieldTypes.typeFor(fieldKey);
    final options = MaintenanceFieldOptions.optionsFor(fieldKey);

    if (fieldType == MaintenanceFieldTypes.boolean) {
      return SwitchListTile(
        title: Text(label),
        value: _details[fieldKey] == true,
        onChanged: (value) {
          setState(() {
            _details[fieldKey] = value;
          });
        },
      );
    }

    if (fieldType == MaintenanceFieldTypes.dropdownSearch &&
        options.isNotEmpty) {
      final selectedValue = _details[fieldKey] as String?;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: DropdownSearch<String>(
          selectedItem: selectedValue,
          mode: Mode.form,
          items: (String? filter, LoadProps? props) async {
            return options
                .where(
                  (item) =>
                      filter == null ||
                      item.toLowerCase().contains(filter.toLowerCase()),
                )
                .toList();
          },
          onChanged: (value) {
            setState(() {
              if (value == null || value.trim().isEmpty) {
                _details.remove(fieldKey);
              } else {
                _details[fieldKey] = value;
              }
            });
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),
      );
    }

    if (fieldType == MaintenanceFieldTypes.dropdown && options.isNotEmpty) {
      final existingValue = _details[fieldKey] as String?;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: DropdownButtonFormField<String>(
          value: options.contains(existingValue) ? existingValue : null,
          decoration: InputDecoration(labelText: label),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value == null || value.trim().isEmpty) {
                _details.remove(fieldKey);
              } else {
                _details[fieldKey] = value;
              }
            });
          },
        ),
      );
    }

    if (fieldType == MaintenanceFieldTypes.date) {
      final controller = _controllerForDetailField(fieldKey);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: DateFormatField(
          type: DateFormatType.type4,
          controller: controller,
          decoration: InputDecoration(labelText: label),
          onComplete: (date) {
            if (date == null) return;

            final prefs = Provider.of<UserPreferences>(context, listen: false);

            setState(() {
              controller.text = DateFormat(prefs.dateFormat).format(date);
              _details[fieldKey] = date.toIso8601String();
            });
          },
        ),
      );
    }

    final controller = _controllerForDetailField(fieldKey);
    final isNumber = fieldType == MaintenanceFieldTypes.number;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: isNumber
            ? (value) => validateNumber(
                  value,
                  context,
                  maxInt: 1000000,
                  allowEmpty: true,
                )
            : null,
        onChanged: (value) {
          final trimmed = value.trim();

          if (trimmed.isEmpty) {
            _details.remove(fieldKey);
            return;
          }

          _details[fieldKey] = isNumber ? double.tryParse(trimmed) : trimmed;
        },
      ),
    );
  }

  Future<void> _submitUpdate() async {
    if (_record == null) return;
    if (!_formKey.currentState!.validate()) return;

    if (isoDateToStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.enterValidDateMessage),
        ),
      );
      return;
    }

    final cleanedDetails = Map<String, dynamic>.from(_details)
      ..removeWhere((key, value) {
        if (value == null) return true;
        if (value is String && value.trim().isEmpty) return true;
        return false;
      });

    final updatedRecord = _record!.copyWith(
      maintenanceType: _selectedMaintenanceType,
      title: titleController.text.trim(),
      date: isoDateToStore,
      odometer: odometerController.text.trim().isEmpty
          ? null
          : double.parse(odometerController.text.trim()),
      totalCost: double.parse(totalCostController.text.trim()),
      shopName: shopNameController.text.trim().isEmpty
          ? null
          : shopNameController.text.trim(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      details: cleanedDetails,
    );

    try {
      final oldCost = _record!.totalCost;
      final newCost = double.parse(totalCostController.text.trim());
      final difference = newCost - oldCost;

      await MaintenanceCloudWriteOperations()
          .updateMaintenanceRecord(updatedRecord);

      // Checking for maintenance cost difference after editing maintenance record page
      if (difference > 0) {
        await incrementLifeTimeMaintenanceCosts(
          widget.vehicleCloudId,
          updatedRecord.userId,
          difference,
        );
      } else if (difference < 0) {
        await decrementLifeTimeMaintenanceCosts(
          widget.vehicleCloudId,
          updatedRecord.userId,
          difference.abs(),
        );
      }

      if (!mounted) return;

      navigateToDisplayMaintenanceRecordPage(
        context,
        widget.vehicleCloudId,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating maintenance record: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    if (_isLoading) {
      return const CustomScaffold(
        title: 'Edit Work',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_record == null) {
      return const CustomScaffold(
        title: 'Edit Work',
        body: Center(child: Text('Maintenance record not found')),
      );
    }

    return ConfirmableBackScaffold(
      title: 'Edit Maintenance Record',
      onConfirmBack: () async {
        final shouldPop = await confirmDiscardChanges(context);
        if (shouldPop && context.mounted) {
          navigateToDisplayMaintenanceRecordPage(
            context,
            widget.vehicleCloudId,
          );
        }
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildMaintenanceTypeDropdown(),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) => validateRequiredText(value, context),
              ),
              DateFormatField(
                type: DateFormatType.type4,
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Maintenance Date',
                ),
                lastDate: DateTime.now(),
                onComplete: (date) {
                  if (date == null) return;

                  setState(() {
                    isoDateToStore = date.toIso8601String();
                    dateController.text =
                        DateFormat(prefs.dateFormat).format(date);
                  });
                },
              ),
              TextFormField(
                controller: odometerController,
                decoration: const InputDecoration(
                  labelText: 'Odometer',
                  hintText: 'Optional',
                ),
                validator: (value) => validateNumber(
                  value,
                  context,
                  maxInt: 2000000,
                  allowEmpty: true,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: totalCostController,
                decoration: InputDecoration(
                  labelText: 'Total Cost',
                  prefix: Text(prefs.currencySymbol),
                ),
                validator: (value) => validateNumber(
                  value,
                  context,
                  maxInt: 1000000,
                  allowEmpty: false,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: shopNameController,
                decoration: const InputDecoration(
                  labelText: 'Shop / Mechanic',
                  hintText: 'Optional',
                ),
                validator: (value) => validateMaxLength(value, 100, context),
              ),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Optional',
                ),
                validator: (value) => validateMaxLength(value, 500, context),
              ),
              if (_prefillService.canAutofill(_selectedMaintenanceType))
                PrimaryActionButton(
                  text:
                      "Autofill from Vehicle Details", //AppLocalizations.of(context)!.autofillVehicleDetails,
                  icon: Icons.save,
                  onPressed: _autofillDetails,
                ),
              const SizedBox(height: 16),
              _buildDynamicDetailsSection(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitUpdate,
                  child: const Text('Update Maintenance Record'),
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
    titleController.dispose();
    dateController.dispose();
    odometerController.dispose();
    totalCostController.dispose();
    shopNameController.dispose();
    notesController.dispose();

    for (final controller in _detailControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }
}
