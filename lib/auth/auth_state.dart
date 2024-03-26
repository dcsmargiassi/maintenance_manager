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
    int? id = await getUserIdByEmail(email); // Await the Future
    userId = id!;
    notifyListeners();
  }
}
DatabaseRepository dbRepository = DatabaseRepository.instance;

Future<int?> getUserIdByEmail(String email) async {
  final db = await dbRepository.database;
  var result = await db.query('user', columns: ['userId'], where: 'email = ?', whereArgs: [email]);
  return result.isNotEmpty ? result.first['userId'] as int? : null;
}