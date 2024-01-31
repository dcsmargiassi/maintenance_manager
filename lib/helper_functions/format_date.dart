/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Various helper functions to perform various tasks in the application.
 - Date conversion functions from string to date format and vice versa.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

String formatDateToString(DateTime date) {
  // Format the DateTime to a string in a desired format
  return date.toIso8601String();
}

DateTime parseStringToDate(String dateString) {
  // Parse the formatted string back to DateTime
  return DateTime.parse(dateString);
}