import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  try {
    await DatabaseRepository.instance.database;
  } catch (e) {
    debugPrint('Error initializing Database: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(
          create: (_) => UserPreferences(
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthState, LanguageProvider>(
      builder: (context, authState, languageProvider, _) {
        if (authState.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        // Load preferences after login
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
                languageProvider.setLocale(Locale(languageCode));
              }
            }
          });
        } else {
          // Fallback to device locale
          final deviceLocale = PlatformDispatcher.instance.locale;
          languageProvider.setLocale(deviceLocale);
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: languageProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (languageProvider.locale != null) {
              return languageProvider.locale;
            }
            if (deviceLocale != null) {
              for (var locale in supportedLocales) {
                if (locale.languageCode == deviceLocale.languageCode) {
                  return locale;
                }
              }
            }
            return const Locale('en');
          },
          home: _buildHome(authState),
        );
      },
    );
  }

  Widget _buildHome(AuthState authState) {
    if (!authState.initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (authState.user == null) {
      return const SignInPage();
    }
    return const HomePage();
  }
}