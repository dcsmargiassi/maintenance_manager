import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
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
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted')),
      );
      navigateToCreateAccountPage(context);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() => isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  Future<String?> _promptForPassword() async {
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      final TextEditingController passwordController = TextEditingController();
      return AlertDialog(
        title: const Text('Re-enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, passwordController.text),
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}

  Future<void> deleteAppData() async {
    setState(() => isDeleting = true);

    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    if (userId == null) {
      setState(() => isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      await VehicleOperations().deleteAllVehicles(userId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('App data deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete app data: $e')),
      );
    } finally {
      setState(() => isDeleting = false);
    }
  }

  Future<bool?> showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Data'),
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
                        'Confirm App Data Deletion',
                        'This will delete all your app data permanently. Continue?',
                      );
                      if (confirm == true) {
                        await deleteAppData();
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete App Data'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showConfirmDialog(
                        'Confirm Account Deletion',
                        'This will delete your account permanently. Continue?',
                      );
                      if (confirm == true) {
                        await deleteAccount();
                      }
                    },
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Delete Account'),
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