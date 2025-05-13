import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/account_functions/signin_page.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:provider/provider.dart';


class DisplayArchivedVehicleInfo extends StatefulWidget {
  final int vehicleId;

   const DisplayArchivedVehicleInfo({Key? key, required this.vehicleId}) : super(key: key);

  @override
  DisplayVehicleInfoState createState() => DisplayVehicleInfoState();
}

class DisplayVehicleInfoState extends State<DisplayArchivedVehicleInfo> {
  late Future<VehicleInformationModel> _vehicleInfoFuture;

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;
    _vehicleInfoFuture = VehicleOperations().getVehicleById(widget.vehicleId, userId!);
    if(mounted) {
        setState(() {});
      }
  }

  @override
  Widget build(BuildContext context) {
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
            navigateToArchivedVehicles(context);
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
          PopupMenuButton<String>(
            onSelected: (choice) async {
              if (choice == 'editVehicle'){ 
                navigateToEditVehiclePage(context, widget.vehicleId);
              }
              if (choice == 'homePage') {
                navigateToHomePage(context);
              }
              if (choice == 'signout') {
                final navigator = Navigator.of(context);
                final authState = context.read<AuthState>();
                authState.clearUser();
                await FirebaseAuth.instance.signOut();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'editVehicle',
                child: Text('Edit Information'),
              ),
              const PopupMenuItem(
                value: 'homePage',
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

  // Widget to create the buttons for archived vehicle information pages.
  Widget buildVehicleButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis)),
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
              "${data.vehicleNickName}",
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
            Text(
              "Lifetime Fuel Cost: ${data.lifeTimeFuelCost}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Lifetime Repair Cost: ${data.lifeTimeMaintenanceCost}",
              style: const TextStyle(fontSize: 18),
            ),
            // Lifetime Fuel Cost
            // Lifetime Maintenance Cost
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Column(
                children:[
                  Row(
                    children: [
                      buildVehicleButton('Fuel History', () {
                        navigateToDisplayFuelRecordPage(context, data.vehicleId!);
                      }),
                      const SizedBox(width: 16.0), 
                      buildVehicleButton('Work History', () {
                        navigateToAddFuelRecordPage(context, data.vehicleId!);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      buildVehicleButton('Unarchive', () {
                        navigateToDisplayFuelRecordPage(context, data.vehicleId!);
                      }),
                      const SizedBox(width: 16.0),
                      buildVehicleButton('Delete Vehicle', () {
                        navigateToEditVehiclePage(
                          context, 
                          data.vehicleId!,
                          onReturn: () {
                            setState(() {
                              _vehicleInfoFuture = VehicleOperations().getVehicleById(widget.vehicleId, Provider.of<AuthState>(context, listen: false).userId!);
                            });
                          }
                        );
                      }),
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