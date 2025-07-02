//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:maintenance_manager/auth/auth_state.dart';
//import 'package:maintenance_manager/data/database_operations.dart';
//import 'package:maintenance_manager/helper_functions/page_navigator.dart';
//import 'package:maintenance_manager/helper_functions/utility.dart';
//
//class DisplaySettings extends StatefulWidget{
//  DisplaySettings({super.key}) 
//
//  @override
//  DisplaySettingsState createState() {
//  }
//}
//
//class DisplaySettingsState extends State<DisplaySettings> {
//
//  @override
//  void initState() {
//    super.initState();
//    final authState = Provider.of<AuthState>(context, listen: false);
//    final userId = authState.userId!;
//  }
//  
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        // Custom backspace button
//        leading: IconButton(
//          icon: const Icon(
//            Icons.arrow_back,
//            color: Colors.white
//            ),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//        title: const Text(
//          'Settings',
//          ),
//          elevation: 0.0,
//          centerTitle: true,
//        ),
//        body: SafeArea(
//          child: Column(
//            children: [
//
//            ],
//          ),
//        ),
//    );
//  }
//}