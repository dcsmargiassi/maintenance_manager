import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _message = AppLocalizations.of(context)!.resetPasswordEmailSent;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = AppLocalizations.of(context)!.genericErrorWithDetail(e.message ?? 'Unknown error');
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.resetPassword)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.enterEmailMessage),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(AppLocalizations.of(context)!.sendResetEmail),
            ),
            const SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(
                  color: _message.startsWith("Error") ? Colors.red : Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}