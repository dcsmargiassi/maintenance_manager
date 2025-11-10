/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Create account page allows all new users of the application to create an account. The page takes the
 input of email, username, password, firstname, and lastname. The page uses the package flutter_pw_validator to meet the
 required parameters specified below.
 - To be added features include the storing of last login as well as the prompt to enable/disable notifications.
 - The page, for privacy, allows the toggling of obscuring the text on password input allowing them to double check what they entered.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/helper_functions/encryption_helper.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController lastLoginController = TextEditingController();
  final TextEditingController emailNotificationsController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool _isObscure = true;
  bool privacyAnalytics = false;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      
      title: AppLocalizations.of(context)!.createAccount,
      onBack:() => navigateToLogin(context),
      showActions: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
            'assets/icon/1024.png',
            width: 200,
            height: 200,
          ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.username),
              ),
              TextField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 180,
                child: FlutterPwValidator(
                  controller: passwordController,
                  minLength: 8,
                  uppercaseCharCount: 2,
                  lowercaseCharCount: 2,
                  numericCharCount: 2,
                  specialCharCount: 1,
                  width: 400,
                  height: 150,
                  successColor: Colors.green,
                  failureColor: Colors.red,
                  onSuccess: () {},
                  onFail: () {
                  },
                ),
              ),
              TextField(
                controller: firstNameController,
                obscureText: false,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.firstName),
              ),
              TextField(
                controller: lastNameController,
                obscureText: false,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastName),
              ),

              const SizedBox(height: 16.0),

              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.enablePrivacyAnalytics),
                subtitle: Text(AppLocalizations.of(context)!.privacyAnalyticsSubtitle),
                value: privacyAnalytics,
                onChanged: (value) {
                  setState(() {
                    privacyAnalytics = value;
                  });
                },
              ),

              const SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () async {
                  final authState = Provider.of<AuthState>(context, listen: false);
                  try {
                    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    final user = userCredential.user;
                    if (!context.mounted) return;
                    if (user == null) throw Exception(AppLocalizations.of(context)!.genericError);

                    // Send verification email
                    await user.sendEmailVerification();

                    final now = Timestamp.now();

                    // Encrypting sensitive details
                    final encryptedUserName = await encryptField(usernameController.text.trim());
                    final encyptedFirstName = await encryptField(firstNameController.text.trim());
                    final encryptedLastName = await encryptField(lastNameController.text.trim());

                    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
                    final settingsDoc = FirebaseFirestore.instance
                        .collection('settings')
                        .doc(user.uid);
                    // Save user details in Firestore
                    await userDoc.set({
                      'userId': user.uid,
                      'email': emailController.text.trim(),
                      'emailVerified': user.emailVerified,
                      'username': encryptedUserName,
                      'firstName': encyptedFirstName,
                      'lastName': encryptedLastName,
                      'phoneNumber': phoneNumberController.text.trim(),
                      'lastLogin': now,
                      'createdAt': now,
                      'lastPasswordChange': now,
                      'failedLoginAttempts': 0,
                    });

                    // Save user settings details in Firestore as subcollection
                    await settingsDoc.set({
                      'pushNotifications': true,
                      'darkModeEnabled': false,
                      'languageCode': "",
                      'acceptedTermsVersion': 1,
                      'privacyAnalytics': privacyAnalytics,
                      'enableCloudSync': true,
                      'currency': 'USD',
                      'distanceUnit': 'Miles',
                      'dateFormat': 'MM/dd/yyyy',
                      'theme': 'Light',
                    });

                    if (!context.mounted) return;
                    authState.setUser(user);
                    await analytics.setAnalyticsCollectionEnabled(privacyAnalytics);
                    // Analytics event - account creation (If enabled)
                    if(privacyAnalytics) {
                      await analytics.logEvent(name: 'account_created');
                    }

                    if (!context.mounted) return;
                    var username = usernameController;
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.welcomeUser(username)
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );

                    navigateToHomePage(context);

                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() { 
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailNotificationsController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}