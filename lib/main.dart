import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/helper_functions/global_theme.dart';
import 'package:maintenance_manager/account_functions/signin_page.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:maintenance_manager/homepage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  //Initializing the systems locale based on device settings to utilize date time API
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();

  // Firebase initializatoin
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // Initialize the database connection
  try {
  await DatabaseRepository.instance.database;
  }
  catch(e) {
    debugPrint('Error initializing Database: $e');
  }
  //printVehicleTableColumns();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<AuthState>(
          builder: (context, authState, _) {
            if (authState.isLoading) {
              // Still checking login status
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              home: authState.user == null
                  ? const SignInPage()
                  : const HomePage(),
            );
          },
        );
      },
    );
  }
}