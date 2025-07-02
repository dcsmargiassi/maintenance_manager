import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';

class HomePage extends StatelessWidget {
  final bool showGlobalActions;
  const HomePage({super.key, this.showGlobalActions = true});

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
        // Disabling backspace button
        automaticallyImplyLeading: false,
        title: const Text(
          'Vehicle Record Tracker',
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) async {
              switch (choice) {
              case 'Profile':
                await navigateToProfilePage(context);
                break;
              case 'HomePage':
                await navigateToHomePage(context);
                break;
              case 'Settings':
                await navigateToHomePage(context);
                break;
              case 'signout':
                await navigateToLogin(context);
                break;
            }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'HomePage',
                child: Text('HomePage'),
              ),
              PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'signout',
                child: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
          const SizedBox(height: buttonSpacingBoxHeight),

        SizedBox(
          width: homeScreenButtonWidth,
          height: homeScreenButtonHeight,
          child: ElevatedButton(
            onPressed: () {
              navigateToMyVehicles(context);
            },
            style: ElevatedButton.styleFrom(
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
              navigateToAddVehicleFormPage(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 4,
            ),
              child: Text ((addRemoveVehicle),
                style: const TextStyle(fontSize: buttonFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white
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
                navigateToArchivedVehicles(context);
            },
            style: ElevatedButton.styleFrom(
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
            'Version: 0.5.2',
            style: TextStyle(fontSize: 12,
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