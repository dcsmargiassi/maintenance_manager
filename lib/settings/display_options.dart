import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:provider/provider.dart';

class DisplayOptionsPage extends StatefulWidget {
  const DisplayOptionsPage({super.key});

  @override
  State<DisplayOptionsPage> createState() => _DisplayOptionsPageState();
}

class _DisplayOptionsPageState extends State<DisplayOptionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<String> _languages = ['English (US)', 'Spanish'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'AUD', 'MXN', 'MXV'];
  final List<String> _distanceUnits = ['Miles', 'Kilometers'];
  final List<String> _dateFormats = ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];
  final List<String> _themes = ['Light'];

  String? _selectedLanguage;
  String? _selectedCurrency;
  String? _selectedDistanceUnit;
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
    if (_currentUser == null) return;

    try {
      final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _selectedLanguage = data['language'] ?? _languages.first;
          _selectedCurrency = data['currency'] ?? _currencies.first;
          _selectedDistanceUnit = data['distanceUnit'] ?? _distanceUnits.first;
          _selectedDateFormat = data['dateFormat'] ?? _dateFormats.first;
          _selectedTheme = data['theme'] ?? _themes.first;
          _isLoading = false;
        });
      } else {
        setDefaults();
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
      setDefaults();
    }
  }

  void setDefaults() {
    setState(() {
      _selectedLanguage = _languages.first;
      _selectedCurrency = _currencies.first;
      _selectedDistanceUnit = _distanceUnits.first;
      _selectedDateFormat = _dateFormats.first;
      _selectedTheme = _themes.first;
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    if (_currentUser == null) return;

    setState(() => _isSaving = true);

    try {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'language': _selectedLanguage,
        'currency': _selectedCurrency,
        'distanceUnit': _selectedDistanceUnit,
        'dateFormat': _selectedDateFormat,
        'theme': _selectedTheme,
      }, SetOptions(merge: true));
      
      if(!mounted) return;

      Provider.of<UserPreferences>(context, listen: false).update(
        currency: _selectedCurrency,
        distanceUnit: _selectedDistanceUnit,
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
              value: _selectedLanguage,
              decoration: const InputDecoration(labelText: 'Language'),
              items: _languages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
              onChanged: (val) => setState(() => _selectedLanguage = val),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(labelText: 'Currency'),
              items: _currencies.map((cur) => DropdownMenuItem(value: cur, child: Text(cur))).toList(),
              onChanged: (val) => setState(() => _selectedCurrency = val),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedDistanceUnit,
              decoration: const InputDecoration(labelText: 'Distance Units'),
              items: _distanceUnits.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
              onChanged: (val) => setState(() => _selectedDistanceUnit = val),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedDateFormat,
              decoration: const InputDecoration(labelText: 'Date Format'),
              items: _dateFormats.map((format) => DropdownMenuItem(value: format, child: Text(format))).toList(),
              onChanged: (val) => setState(() => _selectedDateFormat = val),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(labelText: 'Theme'),
              items: _themes.map((theme) => DropdownMenuItem(value: theme, child: Text(theme))).toList(),
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