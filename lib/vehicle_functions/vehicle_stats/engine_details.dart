/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Engine Details Wdiget - Collect all information regarding engine details
 - Engine Configurations
 - https://en.wikipedia.org/wiki/Engine_configuration
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class EngineDetailsSection extends StatelessWidget {
  // Controllers
  final TextEditingController engineSizeController; // Ex 1.5 L
  final TextEditingController cylinderController; // Ex 4 Cylinder ( I4)
  final TextEditingController engineTypeController; // Gas, diesel, hybrid Etc.
  final TextEditingController oilWeightController; //5W-20, 5W-30, etc
  final TextEditingController oilCompositionController; // Synthetic Blend, Conventional, etc
  final TextEditingController oilClassController; // Standard, Diesel, High Mileage
  final TextEditingController oilFilterController; // Ex S7317XL
  final TextEditingController engineFilterController; // Ex FA-1785
  final double sizedBoxHeight = 20.0;

  const EngineDetailsSection({
    super.key,
    required this.engineSizeController,
    required this.cylinderController,
    required this.engineTypeController,
    required this.oilWeightController,
    required this.oilCompositionController,
    required this.oilClassController,
    required this.oilFilterController,
    required this.engineFilterController,
  });
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: engineSizeController.text.isNotEmpty ? engineSizeController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            engineSizeController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              "1.0 L", "1.5 L", "1.6 L", "1.7 L", "1.8 L", 
              "2.0 L", "2.2 L", "2.3 L", "2.5 L", "2.6 L", "2.8 L",
              "3.0 L", "3.2 L", "3.3 L", "3.5 L", "3.7 L", "3.8 L", "3.9 L",
              "4.1 L", "4.2 L", "4.3 L", "4.4 L", "4.8 L", "4.9 L",
              "5.0 L", "5.2 L", "5.7 L", "5.8 L", "5.9 L",
              "6.0 L", "6.2 L", "6.6 L", "6.9 L",
              "7.0 L", "7.4 L", "7.5 L", "7.6 L", "7.8 L",
              "8.1 L", "8.2 L", "8.3 L", "8.6 L",
              "9.0 L", "9.1 L", "9.3 L", "10.0 L", "10.4 L", "10.5 L",
              "11.0 L", "11.6 L", "12.0 L", "12.2 L", "13.9 L",
              "14.0 L", "14.2 L", "14.6 L", "14.8 L",
              "15.2 L", "18.0 L", "18.8 L",
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: localizations.engineSizeLabel,
              hintText: localizations.engineSizeHint,
              border: OutlineInputBorder(), 
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: cylinderController.text.isNotEmpty ? cylinderController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            cylinderController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              "I1", "I2", "I3", "i4", "i5", "I6", "I8",
              "V2", "V3", "V4", "V5", "V6", "V8", "V10", "V12", "V14", "V16", "V18",
              "F2", "F4", "F6", "F10", "F12", "F16",
              "W8", "W12", "W16"
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: localizations.cylinderCountLabel,
              hintText: localizations.cylinderCountHint,
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: engineTypeController.text.isNotEmpty ? engineTypeController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            engineTypeController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              localizations.engineTypeGas,
              localizations.engineTypeDiesel,
              localizations.engineTypeHybrid,
              localizations.engineTypeElectric,
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: localizations.engineTypeLabel,
              hintText: localizations.engineTypeHint,
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: oilWeightController,
          decoration: InputDecoration(
            labelText: localizations.oilWeightLabel,
            hintText: localizations.oilWeightHint
          ),
        ),
          
        SizedBox(height: sizedBoxHeight),

                DropdownSearch<String> (
          selectedItem: oilCompositionController.text.isNotEmpty ? oilCompositionController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            oilCompositionController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              localizations.oilCompositionConventional,
              localizations.oilCompositionFullSynthetic,
              localizations.oilCompositionMineral,
              localizations.oilCompositionSyntheticBlend,
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: localizations.oilCompositionLabel,
              hintText: localizations.oilCompositionHint,
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: oilClassController.text.isNotEmpty ? oilClassController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            oilClassController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              "Diesal Engine", "High Mileage", "Racing", "Standard",
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: localizations.oilClassLabel,
              hintText: localizations.oilClassHint,
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: oilFilterController,
          decoration: InputDecoration(
            labelText: localizations.oilFilterLabel,
            hintText: localizations.oilFilterHint
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: engineFilterController,
          decoration: InputDecoration(
            labelText: localizations.engineFilterLabel,
            hintText: localizations.engineFilterHint
          ),
        ),

        SizedBox(height: sizedBoxHeight),
          
      ],
    );
  }
}