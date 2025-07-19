/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Exterior Details Wdiget - Collect all information regarding exterior parts
 - Windshield Wipers
 - Exterior lights
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/validators.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class ExteriorDetailsSection extends StatelessWidget {
  // Controllers
  final TextEditingController driverWindshieldWiperController; // Ex 1.5 L
  final TextEditingController passengerWindshieldWiperController; // Ex 4 Cylinder ( I4)
  final TextEditingController rearWindshieldWiperController; // Gas, diesel, hybrid Etc.
  final TextEditingController headlampHighBeamController; // H7LL
  final TextEditingController headlampLowBeamController; // H11LL
  final TextEditingController turnLampController; // T20
  final TextEditingController backupLampController; // 921
  final TextEditingController fogLampController;
  final TextEditingController brakeLampController;
  final TextEditingController licensePlateLampController;
  final double sizedBoxHeight = 20.0;

  const ExteriorDetailsSection({
    super.key,
    required this.driverWindshieldWiperController,
    required this.passengerWindshieldWiperController,
    required this.rearWindshieldWiperController,
    required this.headlampHighBeamController,
    required this.headlampLowBeamController,
    required this.turnLampController,
    required this.backupLampController,
    required this.fogLampController,
    required this.brakeLampController,
    required this.licensePlateLampController,

  });
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: driverWindshieldWiperController,
          decoration: InputDecoration(
            labelText: localizations.driverWiperLabel,
            hintText: localizations.driverWiperHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: passengerWindshieldWiperController,
          decoration: InputDecoration(
            labelText: localizations.passengerWiperLabel,
            hintText: localizations.passengerWiperHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),


        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: rearWindshieldWiperController,
          decoration: InputDecoration(
            labelText: localizations.rearWiperLabel,
            hintText: localizations.rearWiperHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),
          
        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: headlampHighBeamController,
          decoration: InputDecoration(
            labelText: localizations.highBeamLabel,
            hintText: localizations.highBeamHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: headlampLowBeamController,
          decoration: InputDecoration(
            labelText: localizations.lowBeamLabel,
            hintText: localizations.lowBeamHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: turnLampController,
          decoration: InputDecoration(
            labelText: localizations.turnLampLabel,
            hintText: localizations.turnLampHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: backupLampController,
          decoration: InputDecoration(
            labelText: localizations.backupLampLabel,
            hintText: localizations.backupLampHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: fogLampController,
          decoration: InputDecoration(
            labelText: localizations.fogLampLabel,
            hintText: localizations.fogLampHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: brakeLampController,
          decoration: InputDecoration(
            labelText: localizations.brakeLampLabel,
            hintText: localizations.brakeLampHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: licensePlateLampController,
          decoration: InputDecoration(
            labelText: localizations.licenseLampLabel,
            hintText: localizations.licenseLampHint
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            final maxLengthError = validateMaxLength(value, 20, context);
            if (maxLengthError != null) return maxLengthError;
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),
          
      ],
    );
  }
}