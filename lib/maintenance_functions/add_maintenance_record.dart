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
import 'package:maintenance_manager/data/cloud/write/maintenance_cloud_write.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/reusable_widgets.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/maintenance_functions/maintenance_prefill.dart';
import 'package:provider/provider.dart';

class AddMaintenanceRecordFormApp extends StatefulWidget {
  final String vehicleCloudId;

  const AddMaintenanceRecordFormApp({
    super.key,
    required this.vehicleCloudId,
  });

  @override
  State<AddMaintenanceRecordFormApp> createState() =>
      AddMaintenanceRecordFormAppState();
}

class AddMaintenanceRecordFormAppState
    extends State<AddMaintenanceRecordFormApp> {
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

  String _selectedMaintenanceType = MaintenanceTypes.oilChange;
  String? isoDateToStore;
  bool hasAutofilled = false; // Limit of 1 use of autofill per form
  bool canAutofillMaintenanceType(String type) {
    return {
      MaintenanceTypes.oilChange,
      MaintenanceTypes.battery,
      MaintenanceTypes.bodyExterior,
    }.contains(type);
  }

  @override
  void initState() {
    super.initState();
    isoDateToStore = DateTime.now().toIso8601String();
  }

  String? _validateRequiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emptyMessageText;
    }
    return null;
  }

  String? _validateOptionalNumber(String? value, {double max = 2000000}) {
    if (value == null || value.trim().isEmpty) return null;

    final parsed = double.tryParse(value);
    if (parsed == null) return AppLocalizations.of(context)!.enterValidNumber;
    if (parsed < 0) return AppLocalizations.of(context)!.noNegatives;
    if (parsed > max) return AppLocalizations.of(context)!.enterRealisticValue;

    return null;
  }

  String? _validateRequiredNumber(String? value, {double max = 1000000}) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emptyMessageText;
    }

    final parsed = double.tryParse(value);
    if (parsed == null) return AppLocalizations.of(context)!.enterValidNumber;
    if (parsed < 0) return AppLocalizations.of(context)!.noNegatives;
    if (parsed > max) return AppLocalizations.of(context)!.enterRealisticValue;

    return null;
  }

  void _resetDynamicDetailsForType(String type) {
    for (final controller in _detailControllers.values) {
      controller.dispose();
    }

    _detailControllers.clear();
    _details.clear();

    setState(() {
      _selectedMaintenanceType = type;
    });
  }

  TextEditingController _controllerForDetailField(String fieldKey) {
    return _detailControllers.putIfAbsent(
      fieldKey,
      () => TextEditingController(),
    );
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
        _resetDynamicDetailsForType(value);
      },
    );
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: DropdownButtonFormField<String>(
          value: _details[fieldKey] as String?,
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
        validator: isNumber ? (value) => _validateOptionalNumber(value) : null,
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

  //Function to, if applicable, autofill details upon click of button for maintenance fields. QOL feature
  Future<void> _autofillDetails() async {
    if (hasAutofilled) return;

    final userId = Provider.of<AuthState>(context, listen: false).userId;

    final prefill = await MaintenancePrefillService().getPrefillDetails(
      userId: userId,
      vehicleCloudId: widget.vehicleCloudId,
      maintenanceType: _selectedMaintenanceType,
    );

    setState(() {
      _details.addAll(prefill);
      hasAutofilled = true;

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

  Future<void> _submitMaintenanceRecord() async {
    if (!_formKey.currentState!.validate()) return;

    if (isoDateToStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.enterValidDateMessage),
        ),
      );
      return;
    }

    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    final cleanedDetails = Map<String, dynamic>.from(_details)
      ..removeWhere((key, value) {
        if (value == null) return true;
        if (value is String && value.trim().isEmpty) return true;
        return false;
      });

    final record = MaintenanceRecordCloudModel(
      id: '',
      userId: userId,
      vehicleCloudId: widget.vehicleCloudId,
      maintenanceType: _selectedMaintenanceType,
      title: titleController.text.trim(),
      date: isoDateToStore!,
      createdAt: null,
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
      attachmentUrls: const [],
    );

    try {
      await MaintenanceCloudWriteOperations().createMaintenanceRecord(record);

      await incrementLifeTimeMaintenanceCosts(
        widget.vehicleCloudId,
        userId,
        record.totalCost,
      );

      if (record.odometer != null) {
        await updateCurrentOdometerNumber(
          widget.vehicleCloudId,
          userId,
          record.odometer!,
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
        SnackBar(content: Text('Error saving maintenance record: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    if (dateController.text.isEmpty) {
      final now = DateTime.now();
      dateController.text = DateFormat(prefs.dateFormat).format(now);
      isoDateToStore = now.toIso8601String();
    }

    return ConfirmableBackScaffold(
      title: 'Add Work',
      onConfirmBack: () async {
        final shouldPop = await confirmDiscardChanges(context);
        if (shouldPop && context.mounted) {
          navigateToSpecificVehiclePage(context, widget.vehicleCloudId);
        }
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMaintenanceTypeDropdown(),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Example: Oil Change, Front Brakes, Tire Rotation',
                ),
                validator: _validateRequiredText,
              ),
              DateFormatField(
                type: DateFormatType.type4,
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Maintenance Date',
                  hintText: 'Enter maintenance date',
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
                validator: (value) => _validateOptionalNumber(value),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: totalCostController,
                decoration: InputDecoration(
                  labelText: 'Total Cost',
                  prefix: Text(prefs.currencySymbol),
                ),
                validator: (value) => _validateRequiredNumber(value),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: shopNameController,
                decoration: const InputDecoration(
                  labelText: 'Shop / Mechanic',
                  hintText: 'Optional',
                ),
              ),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Optional',
                ),
              ),
              if (_prefillService.canAutofill(_selectedMaintenanceType) &&
                  !hasAutofilled)
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
                  onPressed: _submitMaintenanceRecord,
                  child: const Text('Save Maintenance Record'),
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
