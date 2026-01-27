import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/vehicle_local_database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_manager/auth/auth_state.dart';

class ManageDataPage extends StatefulWidget {
  const ManageDataPage({super.key});

  @override
  ManageDataPageState createState() => ManageDataPageState();
}

class ManageDataPageState extends State<ManageDataPage> {
  bool isDeleting = false;
  final TextEditingController passwordController = TextEditingController();

  Future<void> deleteAccount() async {
    final localizations = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isDeleting = true);

    try {
      final email = user.email!;
      final password = await _promptForPassword();
      if (password == null) {
        setState(() => isDeleting = false);
        return;
      }
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);

      // Deleting user auth account
      final firestore = FirebaseFirestore.instance;
      final settingsDocRef = firestore.collection('settings').doc(user.uid);
      final userDocRef = firestore.collection('users').doc(user.uid);
      await settingsDocRef.delete();
      await userDocRef.delete();
      await user.delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.accountDeletedMessage)),
      );
      navigateToCreateAccountPage(context);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() => isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToDeleteAccountMessage(e.toString()))),
      );
    }
  }

  Future<String?> _promptForPassword() async {
  final localizations = AppLocalizations.of(context)!;
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      final TextEditingController passwordController = TextEditingController();
      return AlertDialog(
        title: Text(localizations.reenterPasswordTitle),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: localizations.passwordFieldLabel),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(localizations.cancelButton)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, passwordController.text),
            child: Text(localizations.confirmButton),
          ),
        ],
      );
    },
  );
}

  Future<void> deleteAppData() async {
    final localizations = AppLocalizations.of(context)!;
    setState(() => isDeleting = true);

    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    if (userId == null) {
      setState(() => isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.userNotLoggedInMessage)),
      );
      return;
    }

    try {
      await VehicleOperations().deleteAllVehicles(userId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.appDataDeletedMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failedToDeleteAppDataMessage(e.toString()))),
      );
    } finally {
      setState(() => isDeleting = false);
    }
  }

  Future<bool?> showConfirmDialog(String title, String content) {
    final localizations = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(localizations.cancelButton)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(localizations.deleteButton)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.manageDataTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDeleting
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showConfirmDialog(
                        localizations.confirmAppDataDeletionTitle,
                        localizations.confirmAppDataDeletionContent,
                      );
                      if (confirm == true) {
                        await deleteAppData();
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: Text(localizations.deleteAppDataButton),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showConfirmDialog(
                        localizations.confirmAccountDeletionTitle,
                        localizations.confirmAccountDeletionContent,
                      );
                      if (confirm == true) {
                        await deleteAccount();
                      }
                    },
                    icon: const Icon(Icons.delete_forever),
                    label: Text(localizations.deleteAccountButton),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
      ),
    );
  }
  @override
  void dispose() { 
    passwordController.dispose();
    super.dispose();
  }
}