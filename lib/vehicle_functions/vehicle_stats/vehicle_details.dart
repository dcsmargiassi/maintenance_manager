/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Vehicle Details Wdiget - Collect all information regarding vehicle details
 - Link total list of all car Makes and Models
 https://www.autoevolution.com/cars/
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';

class VehicleDetailsSection extends StatefulWidget {
    // Controllers
  final int archiveController = 0;
  final TextEditingController vehicleNickNameController;
  final TextEditingController vinController;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController versionController;
  final TextEditingController yearController;
  final TextEditingController purchaseDateController;
  final TextEditingController sellDateController;
  final TextEditingController odometerBuyController;
  final TextEditingController odometerSellController;
  final TextEditingController odometerCurrentController;
  final TextEditingController purchasePriceController;
  final TextEditingController sellPriceController;
  final double sizedBoxHeight = 20.0;

  const VehicleDetailsSection({
    super.key,
    required this.vehicleNickNameController,
    required this.vinController,
    required this.makeController,
    required this.modelController,
    required this.versionController,
    required this.yearController, 
    required this.purchaseDateController,
    required this.sellDateController, // Verison 2 autoset when archived
    required this.odometerBuyController,
    required this.odometerSellController,//Version 2 Autoset when archvied
    required this.odometerCurrentController, 
    required this.purchasePriceController,
    required this.sellPriceController, // Version 2
  });

  @override
  State<VehicleDetailsSection> createState() => VehicleDetailsSectionState();
}

class VehicleDetailsSectionState extends State<VehicleDetailsSection> {
  final double sizedBoxHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    String selectedUnit = "Miles Per Hour";
    return Column(
      children: [

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.vehicleNickNameController,
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

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.vinController,
          decoration: const InputDecoration(
            labelText: 'VIN',
            hintText: 'Enter VIN of car',
          ),
          validator: (String? value) {
            //if (value == null || value.isEmpty) {
            //  return 'Please enter some text';
            //}
            return null;
          },
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: widget.makeController.text.isNotEmpty ? widget.makeController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            widget.makeController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              "AC", "Acura", "Alfa Romeo", "Alpine", "Ariel", "Aro", "Artega", "Aston Martin", "Audi",  "Aurus",
               "BMW", "Bristol", "Bufori", "Bugatti", "Buick",
               "Cadillac" "Caterham", "Chevrolet", "Chrysler", "Citroen", "Cupra", "Dacia", "Daewoo", "Daihatsu",
               "Datsun", "DeLorean", "Dodge", "Donkervoort", "Dr Motor", "DS Automobiles", "Eagle", "Ferrari",
               "Fiat", "Fisker", "Ford", "FSO", "Geely", "Genesis", "GMC", "Gordon Murray Automotive", "GTA Motor",
               "Hindustan", "Holden", "Honda", "Hummer", "Hyundai", "Ineos", "Infiniti", "Isuzu", "Jaguar", "Jeep",
               "Karma", "KIA", "Koenigsegg", "KTM", "Lada", "Lamborgihini", "Lancia", "Land Rover", "Lexus",
               "Light Year", "Lincoln", "Lotus", "Lucid Motors", "Mahindra", "Marussia", "Maruti Suzuki", "Maserati",
               "Maybach", "Mazda", "Mclaren", "Mercedes-AMG", "Mercury", "MG", "Mini", "Mitsubishi", "Morgan",
               "NIO", "Nissan", "OldsMobile", "Opel", "Pagani", "Panoz", "Perodua", "Peugeot", "Pininfarina",
               "Plymouth", "Polestar", "Pontiac", "Porsche", "Proton", "Qoros", "Ram Trucks", "Renault", "Rimac",
               "Rivian", "Rolls-Royce", "SAAB", "Saleen", "Samsung", "Santana", "Saturn", "Scion", "Seat", "Skoda",
               "Smart", "Spyker", "SSANGYONG", "Subaru", "Suzuki", "Tata Motors", "Tesla", "Toyota", "TVR", "Vauxhall",
               "VinFast", "Volswagen", "Volvo", "Wiesmann", "Xpeng", "Zender", "Zenvo"
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Make',
              hintText: 'Search make',
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
          controller: widget.modelController,
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

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.versionController,
          decoration: const InputDecoration(
            labelText: 'Submodel',
            hintText: 'Enter submodel of car',
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: widget.yearController.text.isNotEmpty ? widget.yearController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if (value != null) {
              widget.yearController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final currentYear = DateTime.now().year;
            final List<String> yearOptions = [
            for (int year = currentYear + 1; year >= 1900; year--) year.toString(),
            ];
            return yearOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList(); 
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Year',
              hintText: 'Select Model Year',
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
          controller: widget.odometerCurrentController,
          decoration: const InputDecoration(
            labelText: 'Current Mileage',
            hintText: 'Enter current mileage of car',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            if(!isValidNumber(widget.odometerCurrentController.text)){
              return 'Current Mileage must be a number';
            }
            return null;
          },
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: selectedUnit.isNotEmpty ? selectedUnit : null,
          mode: Mode.form,
          onChanged: (value) {
            if (value != null) {
              selectedUnit = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final List<String> selectedUnit = [
            "Miles per Hour", "Kilometers per Hour"
            ];
            return selectedUnit;
          },
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Speedometer Reading',
              hintText: '',
              border: OutlineInputBorder(),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: false,
            fit: FlexFit.loose,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Purchase History',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DateFormatField(
          type: DateFormatType.type4,
          controller: widget.purchaseDateController,
          decoration: const InputDecoration(
            labelText: 'Purchase Date',
            hintText: 'Enter purchase date of car',
          ),
          onComplete: (date) {
          setState(() {
            widget.purchaseDateController.text = formatDateToString(date!);
          });
          },
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.purchasePriceController,
          decoration: const InputDecoration(
            labelText: 'Purchase Price',
            hintText: 'Enter Original Price',
            prefix: Text('\$ '),
          ),
          validator: (String? value) {
            if (value != null && value.trim().isNotEmpty) {
              if(!isValidNumber(widget.purchasePriceController.text)){
              return 'Purchase price must be a number';
              }
            }
            return null;
          },
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.odometerBuyController,
          decoration: const InputDecoration(
            labelText: 'Original Odometer Number',
            hintText: 'Enter odometer number when purchased',
          ),
          validator: (String? value) {
            if (value != null && value.trim().isNotEmpty) {
              if(!isValidNumber(widget.odometerBuyController.text)){
              return 'Odometer reading must be a number';
              }
            }
            return null;
          },
        ),

        SizedBox(height: sizedBoxHeight),
      ],
    );
  }
}