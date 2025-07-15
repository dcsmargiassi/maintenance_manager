import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
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
        title: const Text(
          'Settings',
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
                  title: const Text('Enable Push Notifications'),
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
                  title: const Text('Privacy Analytics'),
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
                  title: const Text('Display Options'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToDisplayOptionsPage(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToPrivacyPolicy(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToTermsOfServicePage(context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Licenses'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    showLicensePage(context: context);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text('Reset Password'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    navigateToResetPasswordPage(context);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Manage Data'),
                onTap: () {
                  navigateToManageDataPage(context);
                },
              ),
              AboutListTile(
                icon: const Icon(Icons.info_outline),
                applicationName: 'Vehicle Record Tracker',
                applicationIcon: Image.asset('assets/icon/1024.png',
                width: 124, height: 124),
                applicationVersion: '0.6.0',
                applicationLegalese: '© 2025 Vehicle Record Tracker',
                aboutBoxChildren: [
                  const SizedBox(height: 10),
                  const Text('This app helps you track your fuel records.'),
                  const Text('For support: vehiclerecordtracker@gmail.com'),
                ],
              ),
            ],
          ),
        ),
    );
  }
}