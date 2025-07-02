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
  const DisplayVehicleLists({super.key});

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
    return Scaffold(
      appBar: AppBar(
        // Custom backspace button
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white
            ),
          onPressed: () {
            navigateToHomePage(context);
          },
        ),
        title: const Text(
          'My Vehicles',
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) async {
              switch (choice) {
              case 'Profile':
                await navigateToProfilePage(context);
                break;
              case 'HomePage':
                await navigateToHomePage(context);
                break;
              case 'Settings':
                await navigateToHomePage(context);
                break;
              case 'signout':
                await navigateToLogin(context);
                break;
            }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'HomePage',
                child: Text('HomePage'),
              ),
              PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
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
                maxLines: 1,
                style: const TextStyle(fontSize: 22),
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