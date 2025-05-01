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
    setState((){
    _vehicleInfoFuture = VehicleOperations().getVehicleById(widget.vehicleId, userId!);
    });
}

  @override
  Widget build(BuildContext context,) {
    final screenSize = MediaQuery.of(context).size;
    final double titleFontSize = screenSize.width * 0.06;
    return Scaffold(
      appBar: AppBar(
        // Custom backspace button
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white
            ),
          onPressed: () {
            navigateToMyVehicles(context);
          },
        ),
        title: Text(
          'Vehicle Information',
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 44),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          //IconButton(
          //  icon: const Icon(Icons.arrow_back),
          //  onPressed: () {
          //    navigateToHomePage(context);
          //  },
          //),
          PopupMenuButton<String>(
            onSelected: (choice) {
              if (choice == 'Exit') {
                navigateToHomePage(context);
              }
              if (choice == 'signout') {
                navigateToLogin(context);
              }
              if (choice == 'editVehicle'){ 
                navigateToEditVehiclePage(context, widget.vehicleId);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'editVehicle',
                child: Text('Edit Information'),
              ),
              const PopupMenuItem(
                value: 'Exit',
                child: Text('Return to HomePage'),
              ),
              const PopupMenuItem(
                value: 'signout',
                child: Text('Sign Out'),
              ),
            ],
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

  Widget buildVehicleButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold)),
          child: FittedBox(child: Text(label)),
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
              style: const TextStyle(fontSize: 22),
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
            Text(
              "Mileage: ${data.odometerCurrent}",
              style: const TextStyle(fontSize: 18),
            ),
            
            const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: Column(
                  children:[
                    Row(
                      children: [
                        Expanded(
                        child: buildVehicleButton('Fuel Data', () {
                          navigateToAddFuelRecordPage(context, data.vehicleId!);
                         }),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: buildVehicleButton('Maintenance Data', () {
                            navigateToAddFuelRecordPage(context, data.vehicleId!);
                         }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child:buildVehicleButton('Unarchive', () {
                            navigateToDisplayFuelRecordPage(context, data.vehicleId!);
                         }),
                        ),
                        const SizedBox(width: 16.0),
                         Expanded( 
                          child: buildVehicleButton('Delete Vehicle', () {
                            navigateToEditVehiclePage(
                              context, 
                              data.vehicleId!,
                              onReturn: () {
                                setState(() {
                                  _vehicleInfoFuture;
                                });
                              }
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}