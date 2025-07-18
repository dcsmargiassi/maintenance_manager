import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/encryption_helper.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool emailVerified = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        userData = null;
        isLoading = false;
      });
      return;
    }

    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    final emailVerifiedStatus = refreshedUser?.emailVerified ?? false;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();

    if (data != null) {
    final updates = <String, dynamic>{};

    if (data['emailVerified'] != emailVerifiedStatus) {
      updates['emailVerified'] = emailVerifiedStatus;
    }

    // Handle decryption of encrypted fields
    final decryptedFields = <String, String>{};
    for (final field in ['username', 'firstName', 'lastName']) {
      final value = data[field];
      if (value != null && value is String && value.contains(':')) {
        try {
          final decrypted = await decryptField(value);
          decryptedFields[field] = decrypted;
        } catch (e) {
          decryptedFields[field] = '[Error Decrypting]';
        }
      } else if (value != null) {
        decryptedFields[field] = value;
      } else {
        decryptedFields[field] = '';
      }
    }

    // Merge decrypted data into local copy
    final mergedData = {
      ...data,
      ...updates,
      ...decryptedFields,
    };

    // Migration of pre-encryption values
    final migrationUpdates = <String, dynamic>{};

for (final field in ['username', 'firstName', 'lastName']) {
  final value = data[field];
  if (value != null && value is String && !value.contains(':')) {
    try {
      final encrypted = await encryptField(value);
      migrationUpdates[field] = encrypted;
    } catch (_) {
    }
  }
}

if (migrationUpdates.isNotEmpty) {
  await docRef.update(migrationUpdates);
}
    setState(() {
      userData = mergedData;
      emailVerified = emailVerifiedStatus;
      isLoading = false;
    });
    }
    else {
      setState(() {
      userData = {};
      emailVerified = emailVerifiedStatus;
      isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String getField(String key) {
      if (userData == null) return '';
      final value = userData![key];
      return value != null ? value.toString() : '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchUserData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // User info fields with empty fallback
            _buildInfoRow(AppLocalizations.of(context)!.username, getField('username')),
            _buildInfoRow(AppLocalizations.of(context)!.email, getField('email')),
            _buildInfoRow(AppLocalizations.of(context)!.firstName, getField('firstName')),
            _buildInfoRow(AppLocalizations.of(context)!.lastName, getField('lastName')),
            _buildInfoRow(AppLocalizations.of(context)!.emailVerified, emailVerified ? 
            AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.home),
              label: Text(AppLocalizations.of(context)!.backToHome),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                navigateToEditProfilePage(context);
              },
              icon: const Icon(Icons.edit),
              label: Text(AppLocalizations.of(context)!.editProfile),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            if (!emailVerified)
              ElevatedButton.icon(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && !user.emailVerified) {
                    await user.sendEmailVerification();
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      // ignore: use_build_context_synchronously
                      SnackBar(content: Text(AppLocalizations.of(context)!.verificationEmailSent)),
                    );
                  }
                },
                icon: const Icon(Icons.email),
                label: Text(AppLocalizations.of(context)!.sendVerificationEmail),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
              text: value.isNotEmpty ? value : '—',
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
