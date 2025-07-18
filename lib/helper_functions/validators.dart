import 'package:flutter/material.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

String? validateRequiredText(String? value, BuildContext context) {
  if (value == null || value.trim().isEmpty) {
    return AppLocalizations.of(context)!.requiredFieldError;
  }
  return null;
}

String? validateMaxLength(String? value, int maxLength, BuildContext context) {
  if (value != null && value.length > maxLength) {
    return AppLocalizations.of(context)!.maxLengthError(maxLength);
  }
  return null;
}

//Max of 2 decimal places unless specified
String? validateNumber(String? value, BuildContext context, {
  int? maxInt,
  int? minInt,
  int maxDecimalPlaces = 2,
  bool allowEmpty = true,
}) {
  if (value == null || value.trim().isEmpty) {
    return allowEmpty ? null : AppLocalizations.of(context)!.requiredFieldError;
  }

  final parsed = double.tryParse(value);
  if (parsed == null) {
    return AppLocalizations.of(context)!.invalidNumberError;
  }

  if (minInt != null && parsed < minInt) {
    return AppLocalizations.of(context)!.negativeNotAllowedError;
  }

  if (maxInt != null && parsed > maxInt) {
    return AppLocalizations.of(context)!.tooLargeError;
  }

  // Build dynamic regex for maxDecimalPlaces
  final decimalPattern = maxDecimalPlaces == 0
      ? r'^\d+$'
      : r'^\d+(\.\d{1,' + maxDecimalPlaces.toString() + r'})?$';
  final decimalRegex = RegExp(decimalPattern);
  //final decimalMatch = RegExp(r'^\d+(\.\d{1,2})?$');
  if (!decimalRegex.hasMatch(value)) {
    return AppLocalizations.of(context)!.maxDecimalPlacesError(maxDecimalPlaces);
  }

  return null;
}