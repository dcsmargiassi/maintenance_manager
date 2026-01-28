import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maintenance_manager/data/cloud_sync_service.dart';
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
import 'package:firebase_auth/firebase_auth.dart';

// DEBUG
bool _didRunBackfillThisSession = false;
String? _didRunBackfillForUserId;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("🔔 Handling a background message: ${message.messageId}");
}

Future<void> _saveTokenToFirestore(String token) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('tokens')
      .doc(token)
      .set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': defaultTargetPlatform.toString(),
      });
  }
}

// Initializes push notifications safely on iOS & Android
Future<void> _initPushNotifications() async {
  final messaging = FirebaseMessaging.instance;

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Ask for iOS notification permissions
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('✅ User granted notification permission');
  } else {
    debugPrint('🚫 Notification permission not granted');
  }

  // iOS only: wait for APNs token (needed before getToken)
  messaging.onTokenRefresh.listen((newToken) {
    debugPrint('🔄 FCM Token refreshed: $newToken');
  });

  // Optional: attempt to get token, but handle null safely
  try {
    final fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      debugPrint('📱 FCM Token: $fcmToken');
      await _saveTokenToFirestore(fcmToken);
    } else {
      debugPrint('⚠️ FCM Token not available yet (iOS sandbox)');
    }
  } catch (e) {
    debugPrint('⚠️ Error fetching FCM token: $e');
  }

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('💬 Received a foreground message: ${message.notification?.title}');
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint('🔄 Token refreshed: $newToken');
  });
}

final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

// Initialization of remote config for cloud writing settings
Future<void> initRemoteConfig() async {
  await remoteConfig.setDefaults({
    'enableCloudWrite': false, // safe default
  });

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(minutes: 5),
  ));

  await remoteConfig.fetchAndActivate();
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("***FIREBASE INITIALIZED***");
  }catch (e, st) { 
    debugPrint('X Firebase init failed: $e\n$st');
  }

  // Call to initialize push notification connection
  await _initPushNotifications();

  // Call to initialize remote config connection
  await initRemoteConfig();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  try {
    await DatabaseRepository.instance.database;
  } catch (e) {
    debugPrint('Error initializing Database: $e');
  }

  // DEBUG TESTING DEFAULT VALUE: FALSE Only utilize during testing of syncing data to cloud database
   const bool kResetCloudSyncOnStartup =
      bool.fromEnvironment('RESET_CLOUD_SYNC', defaultValue: false);

  if (kResetCloudSyncOnStartup) {
    await resetAllCloudSyncState(); // sets isCloudSynced=0, cloudId=null
    debugPrint('Reset cloud sync state on startup');
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

Future<void> resetAllCloudSyncState() async {
  final db = await DatabaseRepository.instance.database;

  // All tables that participate in cloud sync
  final tables = [
    'vehicleInformation',
    'engineDetails',
    'batteryDetails',
    'exteriorDetails',
    'fuelRecords',
  ];

  await db.transaction((txn) async {
    for (final table in tables) {
      final updated = await txn.update(
        table,
        {
          'isCloudSynced': 0,
          'cloudId': null,
        },
      );
      
      debugPrint('🔁 Reset $table → rows affected: $updated');
    }
  });

  debugPrint('✅ All cloud sync state reset complete');
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

              // DEBUG
              final uid = authState.userId;
                if (uid != null &&
                    (!_didRunBackfillThisSession || _didRunBackfillForUserId != uid)) {
                  _didRunBackfillThisSession = true;
                  _didRunBackfillForUserId = uid;

                  await CloudBackfillService.instance.runOnce(uid);
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