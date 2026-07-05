import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  const PrimaryActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Example Usage
// PrimaryActionButton(
//   text: AppLocalizations.of(context)!.saveMaintenanceRecord,
//   icon: Icons.save,
//   onPressed: _saveMaintenanceRecord,
// ),
