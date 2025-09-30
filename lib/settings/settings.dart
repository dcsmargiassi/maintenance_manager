import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class DisplaySettings extends StatefulWidget{
  const DisplaySettings({super.key}); 

  @override
  DisplaySettingsState createState() => DisplaySettingsState();
}

class DisplaySettingsState extends State<DisplaySettings> {
  bool pushNotificationsEnabled = true;
  bool privacyAnalytics = false;

  @override
  void initState() {
    super.initState();
    loadUserPreference();
  }
  
  Future<void> loadUserPreference() async {
  final authState = Provider.of<AuthState>(context, listen: false);
  final userId = authState.userId;
  if (userId == null) return;

  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final data = doc.data();

  if (data != null && mounted) {
    setState(() {
      pushNotificationsEnabled = data['pushNotifications'] ?? true;
      privacyAnalytics = data['privacyAnalytics'] ?? false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final userId = authState.userId;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        // Custom backspace button
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white
            ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          localizations.settingsTitle,
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: Text(localizations.enablePushNotifications),
                  value: pushNotificationsEnabled,
                  onChanged: (value) async {
                    setState(() {
                      pushNotificationsEnabled = value;
                    });
                    if(userId != null) {
                      await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'pushNotifications': value});
                    }
                  },
                ),
              ),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.analytics),
                  title: Text(localizations.privacyAnalytics),
                  value: privacyAnalytics,
                  onChanged: (value) async {
                    setState(() {
                      privacyAnalytics = value;
                    });
                    if(userId != null) {
                      await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'privacyAnalytics': value});
                      await FirebaseAnalytics.instance
                      .setAnalyticsCollectionEnabled(value);
                    }
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.display_settings),
                  title: Text(localizations.displayOptions),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToDisplayOptionsPage(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(localizations.privacyPolicy),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToPrivacyPolicy(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.article),
                  title: Text(localizations.termsOfService),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToTermsOfServicePage(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.article),
                  title: Text(localizations.licenses),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    showLicensePage(context: context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.password),
                  title: Text(localizations.resetPassword),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToResetPasswordPage(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(localizations.recalculateFuelTotalsTitle),
                  subtitle: Text(localizations.recalculateFuelTotalsSubtitle),
                  leading: Icon(Icons.calculate),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(localizations.recalculateFuelTotalsDialogTitle),
                        content: Text(localizations.recalculateFuelTotalsDialogBody),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(localizations.cancelButton,)),
                          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(localizations.recalculateFuelTotalsConfirm)),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await recalculateFuelForAllVehicles(userId!);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations.recalculateFuelTotalsSuccess)),
                      );
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: Text(localizations.manageData),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  navigateToManageDataPage(context);
                },
              ),
              AboutListTile(
                icon: Icon(Icons.info_outline),
                applicationName: localizations.applicationName,
                applicationIcon: Image.asset('assets/icon/1024.png',
                width: 124, height: 124),
                applicationVersion: '0.6.4',
                applicationLegalese: localizations.applicationLegalese,
                aboutBoxChildren: [
                  const SizedBox(height: 10),
                  Text(localizations.aboutDescription1),
                  Text(localizations.aboutDescription2),
                ],
              ),
            ],
          ),
        ),
    );
  }
}