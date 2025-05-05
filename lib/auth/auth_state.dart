/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Authorization function to set the userId to be used during the duration of application runtime.
 This is to enable the usage of multiple accounts on a single device where only relevant data to a user will be displayed.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/database.dart';
import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  int? userId;

  Future<void> setUser(String email) async {
    final id = await getUserIdByEmail(email); // Await the Future
    
    // Check for null user id, if so throw exception
    if (id == null) { 
      throw Exception ("No user found with the email: $email");
    }

    userId = id;
    notifyListeners();
  }
}
DatabaseRepository dbRepository = DatabaseRepository.instance;

Future<int?> getUserIdByEmail(String email) async {
  final db = await dbRepository.database;
  final result = await db.query('user', columns: ['userId'], where: 'email = ?', whereArgs: [email]);
  return result.isNotEmpty ? result.first['userId'] as int? : null;
}