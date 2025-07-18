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
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/validators.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController licensePlateController;
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
    required this.licensePlateController,
  });

  @override
  State<VehicleDetailsSection> createState() => VehicleDetailsSectionState();
}

class VehicleDetailsSectionState extends State<VehicleDetailsSection> {
  final double sizedBoxHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    String selectedUnit = "Miles Per Hour";
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    return Column(
      children: [

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.vehicleNickNameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.nicknameLabel,
            hintText: AppLocalizations.of(context)!.nicknameHint,
          ),
          validator: (String? value) {
            final requiredError = validateRequiredText(value, context);
            if (requiredError != null) return requiredError;

            final maxLengthError = validateMaxLength(value, 30, context);
            if (maxLengthError != null) return maxLengthError;

            return null;
          },
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.vinController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.vinLabel,
            hintText: AppLocalizations.of(context)!.vinHint,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            return validateMaxLength(value, 17, context);
          },
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.licensePlateController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.licensePlateLabel,
            hintText: AppLocalizations.of(context)!.licensePlateHint,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            return validateMaxLength(value, 12, context);
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.requiredFieldError;
            }
            return null;
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
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.makeLabel,
              hintText: AppLocalizations.of(context)!.makeHint,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.modelLabel,
            hintText: AppLocalizations.of(context)!.modelHint,
          ),
          validator: (String? value) {
            final requiredError = validateRequiredText(value, context);
            if (requiredError != null) return requiredError;

            final maxLengthError = validateMaxLength(value, 15, context);
            if (maxLengthError != null) return maxLengthError;

            return null;
          },
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.versionController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.submodelLabel,
            hintText: AppLocalizations.of(context)!.submodelHint,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            return validateMaxLength(value, 15, context);
          }
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
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.yearLabel,
              hintText: AppLocalizations.of(context)!.yearHint,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.currentMileageLabel,
            hintText: AppLocalizations.of(context)!.currentMileageHint,
          ),
          validator: (value) {
            final numberError = validateNumber(
              value,
              maxInt: 2500000,
              minInt: 0,
              allowEmpty: true,
              context,
            );
            if (numberError != null) return numberError;

            final lengthError = validateMaxLength(value, 10, context);
            if (lengthError != null) return lengthError;

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
            AppLocalizations.of(context)!.purchaseHistoryTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DateFormatField(
          type: DateFormatType.type4,
          controller: widget.purchaseDateController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.purchaseDateLabel,
            hintText: AppLocalizations.of(context)!.purchaseDateHint,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.purchasePriceLabel,
            hintText: AppLocalizations.of(context)!.purchaseDateHint,
            prefix: Text(prefs.currencySymbol),
          ),
          validator: (value) => validateNumber(
            value,
            maxInt: 1000000,
            minInt: 0,
            allowEmpty: true,
            context,
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: widget.odometerBuyController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.originalOdometerLabel,
            hintText: AppLocalizations.of(context)!.originalOdometerHint,
          ),
          validator: (value) => validateNumber(
            value,
            maxInt: 2500000,
            minInt: 0,
            allowEmpty: true,
            context,
          ),
        ),
        SizedBox(height: sizedBoxHeight),
      ],
    );
  }
}