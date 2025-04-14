/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Helper function to make user id accessbile anywhere in application
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maintenance_manager/auth/auth_state.dart';

int? getUserId(BuildContext context) {
  return Provider.of<AuthState>(context, listen: false).userId;
}