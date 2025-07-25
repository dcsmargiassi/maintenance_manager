/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Battery Details Widget - Collect all information regarding battery details
 - BCI - Battery Council International 
 Link: chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://batterycouncil.org/wp-content/uploads/2023/10/BCI-Group-Sizes.pdf
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:maintenance_manager/helper_functions/validators.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class BatteryDetailsSection extends StatelessWidget {
    // Controllers
    final TextEditingController batterySeriesTypeController; // Ex BXT
    final TextEditingController batterySizeController; // BCI number
    final TextEditingController coldCrankAmpsController;
    final double sizedBoxHeight = 20.0;

    const BatteryDetailsSection({
    super.key,
    required this.batterySeriesTypeController,
    required this.batterySizeController,
    required this.coldCrankAmpsController,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: batterySeriesTypeController,
          decoration: InputDecoration(
            labelText: localizations.seriesTypeLabel,
            hintText: localizations.seriesTypeHint
          ),
        ),

        SizedBox(height: sizedBoxHeight),

        DropdownSearch<String> (
          selectedItem: batterySizeController.text.isNotEmpty ? batterySizeController.text : null,
          mode: Mode.form,
          onChanged: (value) {
            if(value != null) {
            batterySizeController.text = value;
            }
          },
          items: (String? filter, LoadProps? props) async {
            final allOptions = [
              "1", "2", "2E", "2N", "17HF", "19L",
              "21", "21R", "22F", "22HF", "22NF", "24", "24F", "24H", "24R", "24T", "25", "26",
               "26R", "27", "27F", "27H", "27R", "29NF", "33", "34", "34R", "35", "36R", "40R",
                "41", "42", "43", "45", "46", "47", "48", "49", "50", "51", "51R", "52", "53",
                 "54", "55", "56", "57", "58", "58R", "59", "60", "61", "62", "63", "64", "65",
                  "66", "67R", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "85",
                   "86", "90", "91", "92", "93", "94R", "95R", "96R", "97R", "98R", "99", "99R",
                    "100", "101", "102R", "121R", "124", "124R", "140R", "148", "151R", "152R",
                     "153R", "400", "401", "402R", "403",
            ];
            return allOptions.where((item) => filter == null || item.toLowerCase().contains(filter.toLowerCase())).toList();
          },
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: localizations.bciGroupSizeLabel,
              hintText: localizations.bciGroupSizeHint,
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
          controller: coldCrankAmpsController,
          decoration: InputDecoration(
            labelText: localizations.coldCrankAmpsLabel,
            hintText: localizations.coldCrankAmpsHint
          ),
          validator: (String? value) {
            return validateNumber(value, context, maxInt: 1500, minInt: 0, maxDecimalPlaces: 0, allowEmpty: true);
          },
        ),

        SizedBox(height: sizedBoxHeight),

      ],
    );
  }
}