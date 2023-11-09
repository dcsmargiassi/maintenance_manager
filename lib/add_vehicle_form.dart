import 'package:flutter/material.dart';

/// Flutter code sample for [Form].

//void main() => runApp(const FormExampleApp());

class AddVehicleFormApp extends StatelessWidget {
  const AddVehicleFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: const Text(
          'Add Vehicle Form',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 32,
            fontWeight: FontWeight.bold
          )
        ),
          backgroundColor: const Color.fromARGB(255, 44, 43, 44),
          elevation: 0.0,
          centerTitle: true,
          actions: [
          PopupMenuButton(
            onSelected: (choice) {
              if (choice == 'Exit') {
                Navigator.pop(context); // Go back to the previous page.
              }
            },
            itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Exit',
              child:Text('Return to HomePage'),
            ),
          ]
          ),
          ]
        ),
        body: const AddVehicleForm(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddVehicleForm extends StatefulWidget {
  const AddVehicleForm({super.key});
  @override
  State<AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<AddVehicleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
