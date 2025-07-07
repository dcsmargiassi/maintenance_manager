/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Exterior Details Wdiget - Collect all information regarding exterior parts
 - Windshield Wipers
 - Exterior lights
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:flutter/material.dart';

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
    return Column(
      children: [

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: driverWindshieldWiperController,
          decoration: const InputDecoration(
            labelText: 'Driver Side Windshield Wiper',
            hintText: 'Ex WW-1801-PF'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: passengerWindshieldWiperController,
          decoration: const InputDecoration(
            labelText: 'Passenger Side Windshield Wiper',
            hintText: 'Ex WW-1901-PF'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),


        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: rearWindshieldWiperController,
          decoration: const InputDecoration(
            labelText: 'Rear Windshield Wiper',
            hintText: 'Ex WW-1701-PF'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),
          
        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: headlampHighBeamController,
          decoration: const InputDecoration(
            labelText: 'Headlamp High Beam',
            hintText: 'Ex H7LL'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: headlampLowBeamController,
          decoration: const InputDecoration(
            labelText: 'Headlamp Low Beam',
            hintText: 'Ex H11LL'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: turnLampController,
          decoration: const InputDecoration(
            labelText: 'Turn Lamp',
            hintText: 'Ex T20'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: backupLampController,
          decoration: const InputDecoration(
            labelText: 'Backup Lamp',
            hintText: 'Ex 921'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: fogLampController,
          decoration: const InputDecoration(
            labelText: 'Fog Lamp',
            hintText: 'Ex H11'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: brakeLampController,
          decoration: const InputDecoration(
            labelText: 'Brake Lamp',
            hintText: 'Ex LED'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),

        TextFormField(
          controller: licensePlateLampController,
          decoration: const InputDecoration(
            labelText: 'License Plate Lamp',
            hintText: 'Ex C5W'
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty){ 
              return null;
            }
            if(value.length > 20){
              return 'Max 20 characters allowed';
            }
            return null;
          }
        ),

        SizedBox(height: sizedBoxHeight),
          
      ],
    );
  }
}