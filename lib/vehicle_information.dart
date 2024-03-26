////import 'package:flutter/material.dart';
////import 'package:maintenance_manager/auth/auth_state.dart';
////import 'package:maintenance_manager/data/database_operations.dart';
////import 'package:maintenance_manager/helper_functions/page_navigator.dart';
////import 'package:maintenance_manager/models/vehicle_information.dart';
////import 'package:provider/provider.dart';
////
////class DisplayVehicleInfo extends StatefulWidget {
////  const DisplayVehicleInfo({Key? key, required String vehicleId}) : super(key: key);
////
////  @override
////  DisplayVehicleInfoState createState() => DisplayVehicleInfoState();
////}
////
////class DisplayVehicleInfoState extends State<DisplayVehicleInfo> {
////  @override
////  void initState() {
////
////    final authState = Provider.of<AuthState>(context, listen: false);
////    final userId = authState.userId;
////    super.initState();
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    VehicleOperations vehicleOperations = VehicleOperations();
////    return Scaffold(
////      appBar: AppBar(
////        title: const Text(
////          'My Vehicles',
////          style: TextStyle(
////              color: Color.fromARGB(255, 255, 255, 255),
////              fontSize: 32,
////              fontWeight: FontWeight.bold),
////        ),
////        backgroundColor: const Color.fromARGB(255, 44, 43, 44),
////        elevation: 0.0,
////        centerTitle: true,
////        actions: [
////          PopupMenuButton<String>(
////            onSelected: (choice) {
////              if (choice == 'Exit') {
////                navigateToHomePage(context); // Go back to the previous page.
////              }
////              if (choice == 'signout') {
////                navigateToLogin(context); // Go back to the previous page.
////              }
////            },
////            itemBuilder: (context) => [
////              const PopupMenuItem(
////                value: 'Exit',
////                child: Text('Return to HomePage'),
////              ),
////              const PopupMenuItem(
////                value: 'signout',
////                child: Text('Sign Out'),
////              ),
////            ],
////          ),
////        ],
////      ),
////      body: SafeArea(
////        child: FutureBuilder<List<VehicleInformationModel>>(
////          future: vehicleOperations.getAllVehicles(),
////          builder: (BuildContext context,
////              AsyncSnapshot<List<VehicleInformationModel>> snapshot) {
////            if (snapshot.hasData) {
////              return ListView.builder(
////                  itemCount: snapshot.data!.length,
////                  itemBuilder: (context, index) {
////                    return _displayVehicleDetails(snapshot.data![index]);
////                  });
////            } else {
////              return const Center(
////                child: Text("No Vehicles Entered"),
////              );
////            }
////          },
////        ),
////      ),
////    );
////  }
////
////Widget _displayVehicleDetails(VehicleInformationModel data) {
////  return Card(
////    child: Padding(
////      padding: const EdgeInsets.all(10.0),
////      child: Column(
////        crossAxisAlignment: CrossAxisAlignment.start,
////        children: [
////          Text(
////            "Vehicle Nickname: ${data.vehicleNickName}",
////            style: const TextStyle(fontSize: 24),
////          ),
////          const SizedBox(height: 10),
////          Text(
////            "Make: ${data.make}",
////            style: const TextStyle(fontSize: 18),
////          ),
////          Text(
////            "Model: ${data.model}",
////            style: const TextStyle(fontSize: 18),
////          ),
////          Text(
////            "Year: ${data.year}",
////            style: const TextStyle(fontSize: 18),
////          ),
////          Text(
////            "Version: ${data.version}",
////            style: const TextStyle(fontSize: 18),
////          ),
////          Text(
////            "VIN: ${data.vin}",
////            style: const TextStyle(fontSize: 18),
////          ),
////          // Add more fields as needed
////          const SizedBox(height: 20),
////          Row(
////            mainAxisAlignment: MainAxisAlignment.end,
////            children: [
////              ElevatedButton(
////                onPressed: () {
////                  // Navigate to add fuel record page
////                 // navigateToAddFuelRecordPage(context, data.vehicleId);
////                },
////                child: const Text('Add Fuel Record'),
////              ),
////              const SizedBox(width: 10),
////              ElevatedButton(
////                onPressed: () {
////                  // Navigate to add maintenance record page
////                  //navigateToAddMaintenanceRecordPage(context, data.vehicleId);
////                },
////                child: const Text('Add Maintenance Record'),
////              ),
////            ],
////          ),
////        ],
////      ),
////    ),
////  );
////}
////}

import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:provider/provider.dart';


class DisplayVehicleInfo extends StatefulWidget {
  final int vehicleId;

   const DisplayVehicleInfo({Key? key, required this.vehicleId}) : super(key: key);

  @override
  DisplayVehicleInfoState createState() => DisplayVehicleInfoState();
}

class DisplayVehicleInfoState extends State<DisplayVehicleInfo> {
  late Future<VehicleInformationModel> _vehicleInfoFuture;
  @override
  void initState() {
  super.initState();
  final authState = Provider.of<AuthState>(context, listen: false);
  final userId = authState.userId;
  _vehicleInfoFuture = VehicleOperations().getVehicleById(widget.vehicleId, userId!);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicle Information',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 44),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              navigateToHomePage(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<VehicleInformationModel>(
          future: _vehicleInfoFuture,
          builder: (BuildContext context, AsyncSnapshot<VehicleInformationModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _displayVehicleDetails(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return const Center(
                child: Text("No Vehicle Found"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _displayVehicleDetails(VehicleInformationModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle Nickname: ${data.vehicleNickName}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              "Make: ${data.make}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Model: ${data.model}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Year: ${data.year}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Version: ${data.version}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "VIN: ${data.vin}",
              style: const TextStyle(fontSize: 18),
            ),
            // Add more fields as needed
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to add fuel record page
                    //navigateToAddFuelRecordPage(context, data.vehicleId);
                  },
                  child: const Text('Add Fuel Record'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to add maintenance record page
                    //navigateToAddMaintenanceRecordPage(context, data.vehicleId);
                  },
                  child: const Text('Add Maintenance Record'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}