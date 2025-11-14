import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Migration to split user table into a linked settings table

Future<void> migrateUserSettingsIfNeeded() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final firestore = FirebaseFirestore.instance;
  final userDoc = firestore.collection('users').doc(user.uid);
  final settingsDoc = firestore.collection('settings').doc(user.uid);

  final settingsSnap = await settingsDoc.get();
  if (settingsSnap.exists) return;

  final userSnap = await userDoc.get();
  if (!userSnap.exists) return;

  final userData = userSnap.data() ?? {};

  final newSettings = {
    'pushNotifications': userData['pushNotifications'] ?? true,
    'darkModeEnabled': userData['darkModeEnabled'] ?? false,
    'languageCode': userData['languageCode'] ?? 'en',
    'acceptedTermsVersion': userData['acceptedTermsVersion'] ?? 1,
    'privacyAnalytics': userData['privacyAnalytics'] ?? false,
    'enableCloudSync': true,
    'currency': userData['currency'] ?? 'USD',
    'distanceUnit': userData['distanceUnit'] ?? 'Miles',
    'dateFormat': userData['dateFormat'] ?? 'MM/dd/yyyy',
    'theme': userData['theme'] ?? 'Light',
  };

  await settingsDoc.set(newSettings, SetOptions(merge: true));
}