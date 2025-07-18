import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  final bool showGlobalActions;
  const HomePage({super.key, this.showGlobalActions = true});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Declared variables
    String myVehicles = localizations.myVehiclesButton;
    String archivedVehicles = localizations.archivedVehiclesButton;
    String addRemoveVehicle = localizations.addVehicleButton;
    const double buttonFontSize = 20.0;
    const double homeScreenButtonHeight = 50.0;
    const double homeScreenButtonWidth = 225.0;
    const double buttonSpacingBoxHeight = 50.0;
      return Scaffold(
        appBar: AppBar(
          // Disabling backspace button
          automaticallyImplyLeading: false,
          title:  Text(
            localizations.applicationName,
          ),
          actions: [
            buildAppNavigatorMenu(context),
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
            Image.asset(
              'assets/icon/1024.png',
              width: 200,
              height: 200,
            ),

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
                style: TextStyle(
                  fontSize: buttonFontSize,
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
                  style: TextStyle(
                    fontSize: buttonFontSize,
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
                  style: TextStyle(
                    fontSize: buttonFontSize,
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
              'Version: 0.6.1',
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