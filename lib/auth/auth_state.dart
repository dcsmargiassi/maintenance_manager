/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Authorization function to set the userId to be used during the duration of application runtime.
 This is to enable the usage of multiple accounts on a single device where only relevant data to a user will be displayed.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthState extends ChangeNotifier {
  User? _user;
  bool isLoading = true;

  User? get user => _user;
  String? get userId => _user?.uid;

  AuthState() {
    _initialize();
  }
  Future<void> _initialize() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;

      // Checking for lastLogin in Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      final data = doc.data();
      if (data != null && data['lastLogin'] != null) {
        final lastLogin = (data['lastLogin'] as Timestamp).toDate();
        final now = DateTime.now();
        // if last login was more than 30 days ago, sign them out
        if (now.difference(lastLogin).inDays > 30) {
          await FirebaseAuth.instance.signOut();
          _user = null;
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void setUser(User? user){
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
