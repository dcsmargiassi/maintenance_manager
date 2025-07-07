import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

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

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() {
      userData = doc.data();
      isLoading = false;
    });
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
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // User info fields with empty fallback
            _buildInfoRow('Username', getField('username')),
            _buildInfoRow('Email', getField('email')),
            _buildInfoRow('First Name', getField('firstName')),
            _buildInfoRow('Last Name', getField('lastName')),
            _buildInfoRow('Email Verified', getField('emailVerified')),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                navigateToEditProfilePage(context);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
