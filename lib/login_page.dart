/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: The login page allows an existing user to login to their account or if new, navigate to the create account
 page. This is the default page each user first sees when opening the application. Currently, users must login by providing
 their email used for login and a password. This helps to ensure that usernames can be repeated as it will be associated with 
 a unique email account.
 - A feature to be added is the forgot password navigation page which will take care of users who have forgotten their
 password, but remember the associated email for the account.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/create_account.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/user.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // disabling backspace button
        automaticallyImplyLeading: false,
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(labelText: 'Password',
              suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final authState = Provider.of<AuthState>(context, listen: false);
                // Check for blank email or password
                if(emailController.text.isEmpty || passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill in all fields.")),
                  );
                  return;
                }
                try {
                User? user = await UserOperations().getUserByEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );

                if (user != null && user.userId != null) {
                  authState.setUser(emailController.text);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    navigateToHomePage(context);
                  });
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect login attempt. Please try again.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                }
                catch (e) {
                  const SnackBar(content: Text("Login attempt failed due to server issue, try again!"),
                  duration: Duration(seconds: 3),
                  );
                }
                debugPrint("Sign in error: $e");
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                );
              },
              child: const Text('Create an account'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                );
              },
              child: const Text('Lost password? - Not implemented'),
            ),
          ],
        ),
      ),
    );
  }
}