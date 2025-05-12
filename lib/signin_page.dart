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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/create_account.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
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
                final authState = Provider.of<AuthState>(context, listen: false);
                authState.setUser(FirebaseAuth.instance.currentUser);
                // Check for blank email or password
                if(emailController.text.isEmpty || passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill in all fields.")),
                  );
                  return;
                }
                try {
                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text.trim(), 
                    password: passwordController.text.trim(),
                );

                if (userCredential.user != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    navigateToHomePage(context);
                  });
                } 
                }
                on FirebaseAuthException catch (e) {
                  debugPrint("Sign in error: $e");
                  const SnackBar(content: Text("Login attempt failed due to server issue, try again!"), // ${e.message}
                  duration: Duration(seconds: 3),
                  );
                }
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
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}