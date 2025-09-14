/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: The login page allows an existing user to login to their account or if new, navigate to the create account
 page. This is the default page each user first sees when opening the application. Currently, users must login by providing
 their email used for login and a password. This helps to ensure that usernames can be repeated as it will be associated with 
 a unique email account.
 - A feature to be added is the forgot password navigation page which will take care of users who have forgotten their
 password, but remember the associated email for the account.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/account_functions/password_reset.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/account_functions/create_account.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.of(context)!.signIn,
      showActions: false,
      showBackButton: false,
      body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/icon/1024.png',
            width: 250,
            height: 250,
          ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
              ),
              TextField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password,
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final authState = Provider.of<AuthState>(context, listen: false);
                  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                  //authState.setUser(FirebaseAuth.instance.currentUser);
                  // Check for blank email or password
                  if(emailController.text.isEmpty || passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.fillInAllFields)),
                    );
                    return;
                  }
                  try {
                    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(), 
                      password: passwordController.text.trim(),
                  );

                  if (userCredential.user != null) {
                    final userId = userCredential.user!.uid;

                    // Fetch user document
                    final documentReference = FirebaseFirestore.instance.collection('users').doc(userId);
                    // Updating the last time a user logged in
                    await documentReference.update({
                      'lastLogin': FieldValue.serverTimestamp(),
                    });
                    final documentSnapshot = await documentReference.get();
                    final data = documentSnapshot.data() ?? {};

                    // If pushNotifications or other fields is missing add to user database
                    final Map<String, dynamic> updates = {};
                    if (!data.containsKey('pushNotifications')) {
                      updates['pushNotifications'] = true;
                    }
                    if (!data.containsKey('darkModeEnabled')) {
                      updates['darkModeEnabled'] = false;
                    }
                    if (!data.containsKey('phoneNumber')) {
                      updates['phoneNumber'] = "";
                    }
                    if (!data.containsKey('languageCode')) {
                      updates['languageCode'] = "";
                    }
                    if (!data.containsKey('acceptedTermsVersion')) {
                      updates['acceptedTermsVersion'] = 1;
                    }
                    if (!data.containsKey('privacyAnalytics')) {
                      updates['privacyAnalytics'] = false;
                    }
                    if (updates.isNotEmpty) {
                      await documentReference.update(updates);
                    }

                    // Defining app language locale
                    final supportedCodes = [
                      'en', 'en-GB', 'es', 'fr', 'de', 'it'
                    ];
                    String? languageCode = (data['languageCode'] ?? "").toString();
                    if (languageCode.isEmpty) {
                      // User has no saved preference default to device language, or English US
                      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
                      final candidate = supportedCodes.contains(deviceLocale.toString())
                          ? deviceLocale.toString()
                          : (supportedCodes.contains(deviceLocale.languageCode) ? deviceLocale.languageCode : 'en');
                      languageCode = candidate;

                      await documentReference.update({'languageCode': languageCode});

                      languageProvider.setLocale(Locale(languageCode));
                    }
                    if(!mounted) return;
                    authState.setUser(FirebaseAuth.instance.currentUser);

                    if(!mounted) return;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      navigateToHomePage(context);
                    });
                  } 
                  }
                  on FirebaseAuthException catch (e) {
                    debugPrint("Sign in error: $e");
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      // ignore: use_build_context_synchronously
                      content: Text(e.message ?? AppLocalizations.of(context)!.genericError), // ${e.message}
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.signIn),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                  );
                },
                child: Text(AppLocalizations.of(context)!.createAccount),
              ),
              // Continue as Guest button
              TextButton(
                onPressed: () async {
                  final authState = Provider.of<AuthState>(context, listen: false);
                  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
              
                  try {
                    final guestUser = await FirebaseAuth.instance.signInAnonymously();
                    if (guestUser.user != null) {
                      final userId = guestUser.user!.uid;
                      final documentReference = FirebaseFirestore.instance.collection('users').doc(userId);
              
                      // Create initial anonymous user doc
                      await documentReference.set({
                        'createdAt': FieldValue.serverTimestamp(),
                        'isGuest': true,
                        'languageCode': '',
                        'pushNotifications': false,
                        'darkModeEnabled': false,
                        'acceptedTermsVersion': 1,
                      });
              
                      // Set app language
                      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
                      final candidate = ['en', 'es', 'fr', 'de', 'it'].contains(deviceLocale.languageCode)
                          ? deviceLocale.languageCode
                          : 'en';
                      await documentReference.update({'languageCode': candidate});
                      languageProvider.setLocale(Locale(candidate));
              
                      authState.setUser(guestUser.user);
              
                      if (!mounted) return;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        navigateToHomePage(context);
                      });
                    }
                  } catch (e) {
                    debugPrint("Guest login error: $e");
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      // ignore: use_build_context_synchronously
                      SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.continueAsGuest),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                  );
                },
                child: Text(AppLocalizations.of(context)!.resetPassword),
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
    passwordController.dispose();
    super.dispose();
  }
}