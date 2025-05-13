/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Archived Vehicles display page. This page shows the user all vehicles in a scrollable list that they
 have archived. Vehicles here will no longer be editable
 - Top of page has a drop down menu allowing the user to select a vehicle to archive from the MyVehicles page.
 - Option to click on vehicle and display all past maintenance and fuel records.
 - Additional vehicle information is displayed such as lifetime fuel expenses and lifetime maintenance expenses
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:provider/provider.dart';

class DisplayArchivedVehicleLists extends StatefulWidget {
  const DisplayArchivedVehicleLists({Key? key}) : super(key: key);

  @override
  DisplayVehicleListsState createState() => DisplayVehicleListsState();
}

class DisplayVehicleListsState extends State<DisplayArchivedVehicleLists> {
  late Future<List<VehicleInformationModel>> _vehiclesFuture;
  List<VehicleInformationModel> _nonArchivedVehicles = [];
  VehicleInformationModel? _selectedVehicle;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  Future<void> _loadInitialData() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;

    setState(() {
    _vehiclesFuture = VehicleOperations().getAllArchivedVehiclesByUserId(userId!);
  });
    final vehicles = await VehicleOperations().getAllVehiclesByUserId(userId!);
    setState(() {
      _nonArchivedVehicles = vehicles;
    });
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
            navigateToHomePage(context);
          },
        ),
        title: Text(
          'Archived Vehicles',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
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
              if (choice == 'homePage') {
                navigateToHomePage(context);
              }
              if (choice == 'signout') {
                navigateToLogin(context);
              }
            },
            itemBuilder: (context) => [
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<VehicleInformationModel>(
                      hint: const Text("Select Vehicle to Archive"),
                      value: _selectedVehicle,
                      isExpanded: true,
                      items: _nonArchivedVehicles.map((vehicle) {
                        return DropdownMenuItem<VehicleInformationModel>(
                          value: vehicle,
                          child: Text(vehicle.vehicleNickName ?? 'Unnamed Vehicle'),
                        );
                      }).toList(),
                      onChanged: (VehicleInformationModel? newValue) {
                        setState(() {
                          _selectedVehicle = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _selectedVehicle == null || _isLoading
                        ? null : () async {
                          final userId = Provider.of<AuthState>(context, listen: false).userId;
                          setState(() => _isLoading = true);
                          await VehicleOperations().archiveVehicleById(_selectedVehicle!.vehicleId!);
                          setState(() {
                            _vehiclesFuture = VehicleOperations().getAllArchivedVehiclesByUserId(userId!);
                          });
                          _nonArchivedVehicles = await VehicleOperations().getAllVehiclesByUserId(userId!);
                          _selectedVehicle = null;
                          setState(() => _isLoading = false);
                        },
                    child: const Text("Archive"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<VehicleInformationModel>>(
                future: _vehiclesFuture,
                builder: (BuildContext context, AsyncSnapshot<List<VehicleInformationModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final vehicle = snapshot.data![index];
                        return _displayVehicles(vehicle, () async {
                          final userId = Provider.of<AuthState>(context, listen: false).userId;
                          final vehicleId = vehicle.vehicleId!;
                          await FuelRecordOperations().deleteAllFuelRecordsByVehicleId(userId!, vehicleId);
                          await VehicleOperations().deleteVehicle(userId, vehicleId);
                          setState(() {
                            _vehiclesFuture = VehicleOperations().getAllArchivedVehiclesByUserId(userId);
                          });
                          
                        });
                      },
                    );
                  } else {
                    return const Center(child: Text("No Archived Vehicles"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayVehicles(VehicleInformationModel data, VoidCallback onDelete) {
    return Dismissible(
      key: Key(data.vehicleId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to delete this vehicle and all Fuel Records?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onDelete(); 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar
          (content: Text("Vehicle and Fuel records deleted!")));
      },
    child: GestureDetector(
      onTap: () {
        navigateToSpecificArchivedVehiclePage(context, data.vehicleId!);
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
                overflow: TextOverflow.ellipsis,
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
    ),
    );
  }
}