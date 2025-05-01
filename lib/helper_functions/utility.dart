/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Utility File for general checks across the app.
 - Valid number check
 - Valid integer check
 - Valid date check
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/

bool isValidNumber(String? input) {
  if (input == null) return false;
  return double.tryParse(input) != null;
}

bool isValidInteger(String? input) {
  if (input == null) return false;
  return int.tryParse(input) != null;
}

bool isValidDate(String input) {
  final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$'); // MM/DD/YYYY
  if (!dateRegex.hasMatch(input)) return false;
  try {
    final parts = input.split('/');
    final month = int.parse(parts[0]);
    final day = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    DateTime parsed = DateTime(year, month, day);
    return parsed.month == month && parsed.day == day && parsed.year == year;
  } catch (_) {
    return false;
  }
}