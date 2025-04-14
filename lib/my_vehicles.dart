/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: My Vehicles display page which will display all the vehicles stored in the LOCAL device. Upon click,
  navigation function will bring to page displaying specific vehicle information related to device.
  - Minimum information is displayed on each card, just showing vehicle Nickname, make, model, and year
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:provider/provider.dart';

class DisplayVehicleLists extends StatefulWidget {
  const DisplayVehicleLists({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DisplayVehicleListsState createState() => _DisplayVehicleListsState();
}

class _DisplayVehicleListsState extends State<DisplayVehicleLists> {
  late Future<List<VehicleInformationModel>> _vehiclesFuture;

  @override
  void initState() {
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;
    _vehiclesFuture = VehicleOperations().getAllVehiclesByUserId(userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double titleFontSize = screenSize.width * 0.06;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Vehicles',
          style: TextStyle(
            // ignore: prefer_const_constructors
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 44, 43, 44),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) {
              if (choice == 'Exit') {
                navigateToHomePage(context);
              }
              if (choice == 'signout') {
                navigateToLogin(context);
              }
            },
            itemBuilder: (context) => [
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
        child: FutureBuilder<List<VehicleInformationModel>>(
          future: _vehiclesFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<VehicleInformationModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _displayVehicles(snapshot.data![index]);
                },
              );
            } else {
              return const Center(
                child: Text("No Vehicles Entered"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _displayVehicles(VehicleInformationModel data) {
    return GestureDetector(
      onTap: () {
        navigateToSpecificVehiclePage(context, data.vehicleId!);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data.vehicleNickName}",
                style: const TextStyle(fontSize: 24),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${data.make}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${data.model}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "${data.year}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}