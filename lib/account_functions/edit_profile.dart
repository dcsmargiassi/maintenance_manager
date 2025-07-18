import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data != null) {
      _firstNameController.text = data['firstName'] ?? '';
      _lastNameController.text = data['lastName'] ?? '';
      _usernameController.text = data['username'] ?? '';
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        AppLocalizations.of(context)!.firstName: _firstNameController.text.trim(),
        AppLocalizations.of(context)!.lastName: _lastNameController.text.trim(),
        AppLocalizations.of(context)!.username: _usernameController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericSuccess)),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)), // Failed to update
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editProfile)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.firstName),
                validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.firstNameHint : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.lastName),
                validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.lastNameHint : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.username),
                validator: (val) => val == null || val.isEmpty ? AppLocalizations.of(context)!.usernameHint : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: saveProfile,
                child: Text(AppLocalizations.of(context)!.saveChanges),
              ),
            ],
          ),
        ),
      ),
    );
  }
}