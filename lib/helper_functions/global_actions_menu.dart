/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Consolidate the code for global navigation into one area. Allow access to homepage, profile, sign out
    and settings
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';

class GlobalActionsMenu extends StatelessWidget {
  final BuildContext parentContext;

  const GlobalActionsMenu({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
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
    );
  }
}