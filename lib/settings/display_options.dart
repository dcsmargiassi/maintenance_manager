import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/settings/display_constants.dart';
import 'package:provider/provider.dart';

class DisplayOptionsPage extends StatefulWidget {
  const DisplayOptionsPage({super.key});

  @override
  State<DisplayOptionsPage> createState() => _DisplayOptionsPageState();
}

class _DisplayOptionsPageState extends State<DisplayOptionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // Maps for languages
  final Map<String, String> _languages = {
    'English (US)': 'en',
    'Spanish': 'es',
    'French': 'fr',
    //'German': 'de',
    //'Italian': 'it',
  };
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'AUD', 'MXN', 'MXV'];
  final List<String> _distanceUnits = ['Miles', 'Kilometers'];
  final List<String> _fuelVolumeUnits = ['Gallons', 'Liters'];
  final List<String> _maintenanceFluidUnits = ['Quarts', 'Liters'];
  final List<String> _dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];
  final List<String> _themes = ['Light'];

  String? _selectedLanguageLabel;
  String? _selectedCurrency;
  String? _selectedDistanceUnit;
  String? _selectedFuelVolumeUnit;
  String? _selectedMaintenanceFluidUnit;
  String? _selectedDateFormat;
  String? _selectedTheme;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    if (_currentUser == null) {
      setDefaults();
      return;
    }

    try {
      final settingsDoc =
          await _firestore.collection('settings').doc(_currentUser!.uid).get();

      if (!mounted) return;

      if (!settingsDoc.exists) {
        setDefaults();
        return;
      }

      final data = settingsDoc.data()!;

      final storedLangCode = data['languageCode'] as String? ?? 'en';
      final defaultLabel = _languages.entries
          .firstWhere(
            (entry) => entry.value == storedLangCode,
            orElse: () => _languages.entries.first,
          )
          .key;

      final prefs = Provider.of<UserPreferences>(
        context,
        listen: false,
      );

      prefs.update(
        currency: data['currency'] as String?,
        distanceUnit: data['distanceUnit'] as String?,
        fuelVolumeUnit: data['fuelVolumeUnit'] as String?,
        maintenanceFluidUnit: data['maintenanceFluidUnit'] as String?,
        dateFormat: data['dateFormat'] as String?,
        theme: data['theme'] as String?,
      );

      setState(() {
        _selectedLanguageLabel = defaultLabel;

        _selectedCurrency = data['currency'] as String? ?? _currencies.first;

        _selectedDistanceUnit =
            data['distanceUnit'] as String? ?? _distanceUnits.first;

        _selectedFuelVolumeUnit =
            data['fuelVolumeUnit'] as String? ?? _fuelVolumeUnits.first;

        _selectedMaintenanceFluidUnit =
            data['maintenanceFluidUnit'] as String? ??
                _maintenanceFluidUnits.first;

        _selectedDateFormat =
            data['dateFormat'] as String? ?? _dateFormats.first;

        _selectedTheme = data['theme'] as String? ?? _themes.first;

        _isLoading = false;
      });

      final languageProvider = Provider.of<LanguageProvider>(
        context,
        listen: false,
      );

      languageProvider.setLocale(
        Locale(storedLangCode),
      );
    } catch (e) {
      debugPrint('Error loading preferences: $e');
      setDefaults();
    }
  }

  void setDefaults() {
    setState(() {
      _selectedLanguageLabel = _languages.keys.first;
      _selectedCurrency = _currencies.first;
      _selectedDistanceUnit = _distanceUnits.first;
      _selectedFuelVolumeUnit = _fuelVolumeUnits.first;
      _selectedMaintenanceFluidUnit = _maintenanceFluidUnits.first;
      _selectedDateFormat = _dateFormats.first;
      _selectedTheme = _themes.first;
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    if (_currentUser == null) {
      setDefaults();
      return;
    }
    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      final langCode = _languages[_selectedLanguageLabel];
      await _firestore.collection('settings').doc(_currentUser!.uid).set({
        'languageCode': langCode,
        'currency': _selectedCurrency,
        'distanceUnit': _selectedDistanceUnit,
        'fuelVolumeUnit': _selectedFuelVolumeUnit,
        'maintenanceFluidUnit': _selectedMaintenanceFluidUnit,
        'dateFormat': _selectedDateFormat,
        'theme': _selectedTheme,
      }, SetOptions(merge: true));
      if (!mounted) return;
      // Force updating local app to reflect current language choice
      final languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      languageProvider.setLocale(Locale(_selectedLanguageLabel!));

      if (!mounted) return;

      if (langCode != null) {
        final languageProvider =
            Provider.of<LanguageProvider>(context, listen: false);
        languageProvider.setLocale(Locale(langCode));
      }

      if (!mounted) return;

      Provider.of<UserPreferences>(context, listen: false).update(
        currency: _selectedCurrency,
        distanceUnit: _selectedDistanceUnit,
        fuelVolumeUnit: _selectedFuelVolumeUnit,
        maintenanceFluidUnit: _selectedMaintenanceFluidUnit,
        dateFormat: _selectedDateFormat,
        theme: _selectedTheme,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Display preferences updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save preferences: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Display Options')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return CustomScaffold(
      title: "Display Options",
      showActions: false,
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLanguageLabel,
              decoration: const InputDecoration(labelText: 'Language'),
              items: _languages.keys
                  .map((label) =>
                      DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLanguageLabel = val),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(labelText: 'Currency'),
              items: _currencies
                  .map((cur) => DropdownMenuItem(value: cur, child: Text(cur)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCurrency = val),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedDistanceUnit,
              decoration: const InputDecoration(labelText: 'Distance Units'),
              items: _distanceUnits
                  .map((unit) =>
                      DropdownMenuItem(value: unit, child: Text(unit)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedDistanceUnit = val),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedFuelVolumeUnit,
              decoration: const InputDecoration(
                labelText: 'Fuel Volume Unit',
              ),
              items: _fuelVolumeUnits.map((unit) {
                final abbreviation = fuelVolumeUnits[unit] ?? unit;

                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text('$unit ($abbreviation)'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFuelVolumeUnit = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedMaintenanceFluidUnit,
              decoration: const InputDecoration(
                labelText: 'Maintenance Fluid Unit',
              ),
              items: _maintenanceFluidUnits.map((unit) {
                final abbreviation = maintenanceFluidUnits[unit] ?? unit;

                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text('$unit ($abbreviation)'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMaintenanceFluidUnit = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedDateFormat,
              decoration: const InputDecoration(labelText: 'Date Format'),
              items: _dateFormats
                  .map((format) =>
                      DropdownMenuItem(value: format, child: Text(format)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedDateFormat = val),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(labelText: 'Theme'),
              items: _themes
                  .map((theme) =>
                      DropdownMenuItem(value: theme, child: Text(theme)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedTheme = val),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSaving ? null : _savePreferences,
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
