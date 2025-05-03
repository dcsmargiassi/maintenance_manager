import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:maintenance_manager/login_page.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:provider/provider.dart';

Future<void> printVehicleTableColumns() async {
  final db = await DatabaseRepository.instance.database;
  final result = await db.rawQuery('PRAGMA table_info(vehicleInformation);');

  for (final row in result) {
    // ignore: avoid_print
    print('Column: ${row['name']}, Type: ${row['type']}');
  }
}

void main() async {
  //Initializing the systems locale based on device settings to utilize date time API
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // Initialize the database connection
  try {
  await DatabaseRepository.instance.database;
  }
  catch(e) {
    // ignore: avoid_print
    print('Error initializing Database: $e');
  }
  printVehicleTableColumns();
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
        final screenSize = MediaQuery.of(context).size;
        final theme = ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 44, 43, 44),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 0, 128, 255),
            onPrimary: Color.fromARGB(255, 0, 0, 0),
            secondary: Color.fromARGB(255, 49, 48, 48),
            onSecondary: Color.fromARGB(255, 204, 190, 190),
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            error: Colors.red,
            onError: Colors.white,
          ),
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: screenSize.width * 0.06,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 48, 48, 48),
            ),
          titleMedium: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.normal,
              color: const Color.fromARGB(255, 0, 128, 255),
            ),
            labelLarge: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 128, 255),
              foregroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: screenSize.width * 0.07,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home:  const SignInPage()
        );
      }
    );
  }
}