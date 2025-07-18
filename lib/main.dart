import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/helper_functions/global_theme.dart';
import 'package:maintenance_manager/account_functions/signin_page.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/homepage.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => UserPreferences(
            currency: '\$',
            distanceUnit: 'Miles',
            dateFormat: 'MM/dd/yyyy',
            theme: 'Light',
          ),
        ),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
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

            // Setting app preferences. currency, language, etc.
            if (authState.user != null) {
              Future.microtask(() async {
                final doc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(authState.userId)
                    .get();

                if (!context.mounted) return;

                final data = doc.data();
                if (data != null) {
                  final prefs = Provider.of<UserPreferences>(context, listen: false);
                  prefs.update(
                    currency: data['currency'],
                    distanceUnit: data['distanceUnit'],
                    dateFormat: data['dateFormat'],
                    theme: data['theme'],
                  );
                  final languageCode = data['languageCode'];
                  if (languageCode != null && languageCode.isNotEmpty) {
                    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
                    languageProvider.setLocale(Locale(languageCode));
                    debugPrint('Locale set to: $languageCode');
                  }
                }
              });
            }
            return Consumer<LanguageProvider>(
              builder: (context, languageProvider, _) {
                return MaterialApp(
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: languageProvider.locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  home: authState.user == null ? const SignInPage() : const HomePage(),
                );
              },
            );
          },
        );
      },
    );
  }
}