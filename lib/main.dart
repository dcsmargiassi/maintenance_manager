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
            backgroundColor: Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF007BFF),
            onPrimary: Colors.white,
            secondary: Color(0xFF616161),
            onSecondary: Colors.white,
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
              color: const Color(0xFF2C2C2C),
            ),
          titleMedium: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.normal,
              color: Colors.black,//const Color(0xFF007BFF),
            ),
            labelLarge: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
              elevation: 1,
              minimumSize: const Size(0, 14),
              textStyle: TextStyle(
                fontSize: screenSize.width * 0.045,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF007BFF),
            textStyle: TextStyle(
              fontSize: screenSize.width * 0.045,
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF007BFF),
              side: const BorderSide(color: Color(0xFF007BFF), width: 1),
            textStyle: TextStyle(
              fontSize: screenSize.width * 0.043,
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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