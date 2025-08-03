/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Consolidate the code for global navigation into one area. Allow access to homepage, profile, sign out
    and settings
  - Consolidate the Scaffold code into one area where actions(Custom App Bar with navigation) are enabled by default
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

PopupMenuButton<String> buildAppNavigatorMenu(BuildContext context) {
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
          await navigateToSettingsPage(context);
          break;
        case 'signout':
          AuthState().clearUser();
          await navigateToLogin(context);
          break;
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(value: 'Profile', child: Text(AppLocalizations.of(context)!.profileButton)),
      PopupMenuItem(value: 'HomePage', child: Text(AppLocalizations.of(context)!.homepageButton)),
      PopupMenuItem(value: 'Settings', child: Text(AppLocalizations.of(context)!.settingsButton)),
      PopupMenuItem(value: 'signout', child: Text(AppLocalizations.of(context)!.signoutButton)),
    ],
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showActions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.showActions = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(title),
      actions: showActions ? [buildAppNavigatorMenu(context)] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Custom scaffold for general pages, no leaving page confirmation
class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final bool showActions;
  final bool showBackButton;

  const CustomScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onBack,
    this.showActions = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        onBack: onBack,
        showActions: showActions,
        showBackButton: showBackButton,
      ),
      body: body,
    );
  }
}

class ConfirmableBackScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Future<void> Function()? onConfirmBack;
  final bool showActions;
  final bool showBackButton;

  const ConfirmableBackScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onConfirmBack,
    this.showActions = true,
    this.showBackButton = true,
  });

  Future<void> _handleBack(BuildContext context) async {
    if (onConfirmBack != null) {
      await onConfirmBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => _handleBack(context),
              )
            : null,
        title: Text(title),
        actions: showActions ? [buildAppNavigatorMenu(context)] : null,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) return;
          await _handleBack(context);
        },
        child: body,
      ),
    );
  }
}