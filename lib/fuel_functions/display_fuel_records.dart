/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Display Vehicle Fuel records
 - Allow user to select duration of display from 3, 6, and 12 month or all time duration
 - Two display options: Display point for each refuel or a point on graph at each month highlighting monthly cost
 - Below chart, display total cost
 - Future implementation Allow multiple vehicles to be displayed at once
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:maintenance_manager/data/database_operations.dart';
//import 'package:maintenance_manager/helper_functions/get_user_id.dart';


class DisplayFuelRecords extends StatefulWidget{
  final int vehicleId;
  const DisplayFuelRecords({super.key, required this.vehicleId});

  @override
  State<DisplayFuelRecords> createState() => _DisplayFuelRecords();
}



class _DisplayFuelRecords extends State<DisplayFuelRecords> {
  @override
  void initState() {
    super.initState();
    _loadFuelData();
  }

  Future<void> _loadFuelData() async {
    //final fuelOps = FuelRecordOperations();
    //final userId = getUserId(context);
    //final data = await fuelOps.getFuelRecordsByVehicleId(widget.vehicleId);

    setState(() {

    });
  }
    
    // Controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Graphs'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          )
        )
      )
    );
  }
}

  