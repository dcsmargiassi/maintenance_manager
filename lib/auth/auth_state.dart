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
  bool _isGuest = false;

  User? get user => _user;
  String? get userId => _user?.uid;
  bool get isGuest => _isGuest;

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

  Future<void> setUser(User? user) async {
    _user = user;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      _isGuest = data?['isGuest'] == true;
    } else {
      _isGuest = false;
    }
    notifyListeners();
  }

  Future<void> clearUser() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    _isGuest = false;
    notifyListeners();
  }
}

class UserPreferences extends ChangeNotifier {
  String currency;
  String distanceUnit;
  String dateFormat;
  String theme;

  factory UserPreferences.defaults() {
  return UserPreferences(
    currency: 'USD',
    distanceUnit: 'Miles',
    dateFormat: 'MM/DD/YYYY',
    theme: 'Light',
  );
}

  UserPreferences({
    required this.currency,
    required this.distanceUnit,
    required this.dateFormat,
    required this.theme,
  });

  String get currencySymbol {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'AUD':
        return 'A\$';
      case 'MXN':
        return 'Mex\$';
      default:
        return currency;
    }
  }

  void update({
    String? currency,
    String? distanceUnit,
    String? dateFormat,
    String? theme,
  }) {
    if (currency != null) this.currency = currency;
    if (distanceUnit != null) this.distanceUnit = distanceUnit;
    if (dateFormat != null) this.dateFormat = dateFormat;
    if (theme != null) this.theme = theme;
    notifyListeners();
  }
}
