/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Engine Details Wdiget - Collect all information regarding engine details
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
    return Column(
      children: [
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
              "1.0 L", "1.2 L", "1.3 L",
              "1.5 L", "1.6 L", "1.7 L",
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Engine Size',
              hintText: 'Select engine size',
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

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
              "I1", "I2", "I2",
              "i3", "i4", "6i",
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Engine Type',
              hintText: 'Select cylinder count plus type',
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

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
              "Gas", "Diesel", "Hybrid",
              "Electric",
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Engine type',
              hintText: 'Select engine type',
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
          ),
        ),

        TextFormField(
          controller: oilFilterController,
          decoration: const InputDecoration(
            labelText: 'Engine Size Ex. 1.5L',
            hintText: 'Ex S7317XL'),
          ),
        TextFormField(
          controller: engineFilterController,
          decoration: const InputDecoration(
            labelText: 'Engine Filter',
            hintText: 'Ex FA-1785'),
          ),
          
      ],
    );
  }
}