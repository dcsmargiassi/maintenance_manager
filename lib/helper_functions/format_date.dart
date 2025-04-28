/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various helper functions to perform various tasks in the application.
 - Date conversion functions from string to date format and vice versa.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:intl/intl.dart';

String formatDateToString(DateTime date) {
  // Format the DateTime to a string in a desired format
  return DateFormat('MM/dd/yyyy').format(date);
}

DateTime parseStringToDate(String dateString) {
  // Parse the formatted string back to DateTime
  return DateFormat('MM/dd/yyyy').parse(dateString);
}
