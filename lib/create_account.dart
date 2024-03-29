/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Create account page allows all new users of the application to create an account. The page takes the
 input of email, username, password, firstname, and lastname. The page uses the package flutter_pw_validator to meet the
 required parameters specified below.
 - To be added features include the storing of last login as well as the prompt to enable/disable notifications.
 - The page, for privacy, allows the toggling of obscuring the text on password input allowing them to double check what they entered.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/user.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController lastLoginController = TextEditingController();
  final TextEditingController emailNotificationsController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
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
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 180,
                child: FlutterPwValidator(
                  controller: passwordController,
                  minLength: 8,
                  uppercaseCharCount: 2,
                  lowercaseCharCount: 2,
                  numericCharCount: 2,
                  specialCharCount: 1,
                  width: 400,
                  height: 150,
                  onSuccess: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password is valid'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onFail: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password is invalid'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              TextField(
                controller: firstNameController,
                obscureText: false,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                obscureText: false,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  User newUser = User(
                    email: emailController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    emailNotifications: emailNotificationsController.hashCode,
                  );
                  await UserOperations().createUser(newUser);
                  // ignore: use_build_context_synchronously
                  final authState = Provider.of<AuthState>(context, listen: false);
                  authState.setUser(emailController.text);
                  // ignore: use_build_context_synchronously
                  navigateToHomePage(context);
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}