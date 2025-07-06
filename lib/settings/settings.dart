import 'package:flutter/material.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_manager/auth/auth_state.dart';

class DisplaySettings extends StatefulWidget{
  const DisplaySettings({super.key}); 

  @override
  DisplaySettingsState createState() => DisplaySettingsState();
}

class DisplaySettingsState extends State<DisplaySettings> {
  bool pushNotificationsEnabled = true;
  
  @override
  void initState() {
    super.initState();
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
                  onChanged: (value) {
                    setState(() {
                      pushNotificationsEnabled = value;
                    });
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
                  title: const Text('Licenses'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    showLicensePage(context: context);
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}