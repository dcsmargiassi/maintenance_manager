/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Authorization function to set the userId to be used during the duration of application runtime.
 This is to enable the usage of multiple accounts on a single device where only relevant data to a user will be displayed.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  String? get userId => _user?.uid;

  void setUser(User? user){
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
