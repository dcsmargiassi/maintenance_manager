/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various helper functions to perform various tasks in the application.
 - Date conversion functions from string to date format and vice versa.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:intl/intl.dart';

String parseAndStoreDate(String userInput, String userFormat) {
  final date = DateFormat(userFormat).parse(userInput);
  return date.toIso8601String().split('T').first; // Only store date portion, disregard timestamp
}

String formatStoredDateForDisplay(String storedDate, String userFormat) {
  try {
    final date = DateTime.parse(storedDate);
    return DateFormat(userFormat).format(date);
  } catch (e) {
    return "Invalid Date";
  }
}

String formatDateForUser(String? storedDate, String userFormat) {
  if (storedDate == null || storedDate.isEmpty) return "Unknown Date";
  try {
    final date = DateTime.parse(storedDate);
    return DateFormat(userFormat).format(date);
  } catch (e) {
    return "Invalid Date";
  }
}

String formatDateToString(DateTime date) {
  // Format the DateTime to a string in a desired format
  return DateFormat('MM/dd/yyyy').format(date);
}

DateTime parseStringToDate(String dateString) {
  // Parse the formatted string back to DateTime
  return DateFormat('MM/dd/yyyy').parse(dateString);
}

String formatDateDisplayToString(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "Unknown Date";

  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('MM/dd/yyyy').format(date);
  } catch (e) {
    return "Invalid Date";
  }
}
