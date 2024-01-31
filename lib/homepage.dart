//import 'package:final_project/Pages/add_vehicle_form.dart';
import 'package:flutter/material.dart';
//import 'add_vehicle_form.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

  // Declared variables
  String myVehicles = 'My Vehicles';
  String archivedVehicles = 'Archived Vehicles';
  String addRemoveVehicle = 'Add Vehicle';
  const double buttonFontSize = 20.0;
  const double homeScreenButtonHeight = 50.0;
  const double homeScreenButtonWidth = 225.0;
  const double buttonSpacingBoxHeight = 50.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Maintenance Manager',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: buttonFontSize,
            fontWeight: FontWeight.bold
          )
        ),
          backgroundColor: const Color.fromARGB(255, 44, 43, 44),
          elevation: 0.0,
          centerTitle: true,
      ),
      // Creation of sized box containing child 'column' to properly align and space buttons appropriately
      // ignore: sized_box_for_whitespace
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
          const SizedBox(height: buttonSpacingBoxHeight), // Used to add spacing between each button
        SizedBox(
          width: homeScreenButtonWidth,
          height: homeScreenButtonHeight,
          child: ElevatedButton(
            onPressed: () {
              //Call Function here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 4,
            ),
            child: Text ((myVehicles),
              style: const TextStyle(fontSize: buttonFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: buttonSpacingBoxHeight),

        SizedBox(// Setting the button sizes
          width: homeScreenButtonWidth,
          height: homeScreenButtonHeight,
          child: ElevatedButton(
            onPressed: () {
                //Call Function here
              navigateToAddVehicleFormPage(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 4,
            ),
              child: Text ((addRemoveVehicle),
                style: const TextStyle(fontSize: buttonFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,

                ),
              ),
          ),
        ),

        const SizedBox(height: buttonSpacingBoxHeight),
        // Elevated Button for archived vehicles
        // Input: Click
        // Output: Open list view of all archived vehicles.
        SizedBox(// Setting the button sizes
          width: homeScreenButtonWidth,
          height: homeScreenButtonHeight,
          child: ElevatedButton(
            onPressed: () {
                //Call Function here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 4,
            ),
              child: Text ((archivedVehicles),
                style: const TextStyle(fontSize: buttonFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,

                ),
              ),
          ),
        ),
        const SizedBox(height: buttonSpacingBoxHeight),
        const Material(
          color: Colors.transparent,
          child: Text(
            'Version: 0.0.0',
            style: TextStyle(fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.grey
            ),
          )
        )
          ],
        ),
      ),
    );
  }
}
