import 'package:flutter/material.dart';
//import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:maintenance_manager/data/database_operations.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

class DisplayVehicleLists extends StatefulWidget {
  DisplayVehicleLists({Key? key}) : super(key: key);

  @override
  _DisplayVehicleListsState createState() => _DisplayVehicleListsState();
}

class _DisplayVehicleListsState extends State<DisplayVehicleLists> {
@override
void initState() {
  super.initState();
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: FutureBuilder(
        future: VehicleOperations().getAllVehicles(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return _displayVehicles();
                });
            }
            else {
              return Center(child: Text("No Vehicles Entered"),
              );
            }
      },)),
    );
  }
  Widget _displayVehicles(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NickName:",
              style: TextStyle(fontSize: 24),
              ),
            Row(children: [
              Expanded(
                flex:1,
                child: Text(
                  "Make:",
                  style: TextStyle(fontSize: 18),
                  )), 
              Expanded(
                flex:2,
                child: Text("Model:",
                style: TextStyle(fontSize: 18),
                )),
              Expanded(
                flex:3,
                child: Text(
                  "Year:",
                  style: TextStyle(fontSize: 18),
                  ))
            ],
          )
        ],
      ),
      ),
    );
  }
}







////class VehicleListScreen extends StatefulWidget {
////  const VehicleListScreen({super.key});
////
////  @override
////  // ignore: library_private_types_in_public_api
////  _VehicleListScreenState createState() => _VehicleListScreenState();
////}
////
////class _VehicleListScreenState extends State<VehicleListScreen> {
////  List<Map<String, dynamic>> vehicles = [];
////
////  @override
////  void initState() {
////    super.initState();
////    // Call your database helper function to fetch all vehicles
////    _loadVehicles();
////  }
////
////  Future<void> _loadVehicles() async {
////    VehicleOperations vehicleOperations = VehicleOperations();
////
////    // Call the function to get all vehicles
////    List<Map<String, dynamic>> allVehicles = (await vehicleOperations.getAllVehicles()).cast<Map<String, dynamic>>();
////
////    // Update the state with the fetched vehicles
////    setState(() {
////      vehicles = allVehicles;
////    });
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return Scaffold(
////      appBar: AppBar(
////        title: const Text('Vehicle List'),
////      ),
////      body: _buildVehicleList());
////  }
////
////  Widget _buildVehicleList() {
////    return ListView.builder(
////      itemCount: vehicles.length,
////      itemBuilder: (context, index) {
////        //Map<String, dynamic> vehicle = vehicles[index];
////        VehicleInformation vehicle = vehicles[index] as VehicleInformation;
////        return ListTile(
////          title: Text('${vehicle.vehicleNickName}'),
////          subtitle: Text('${vehicle.make} ${vehicle.model} ${vehicle.year}'),
////          //title: Text('${vehicles[index]['vehicleNickname']}'),
////          //subtitle: Text('${vehicles[index]['make']} ${vehicles[index]['model']} ${vehicles[index]['year']}'),
////          onTap: () {
////            // Navigate to the vehicle details page with the selected vehicle information
////            Navigator.push(
////              context,
////              MaterialPageRoute(builder: (context) => VehicleDetailsScreen(vehicle: vehicles[index])),
////            );
////          },
////        );
////      },
////    );
////  }
////}
////
////class VehicleDetailsScreen extends StatelessWidget {
////  final Map<String, dynamic> vehicle;
////
////  const VehicleDetailsScreen({Key? key, required this.vehicle}) : super(key: key);
////
////  @override
////  Widget build(BuildContext context) {
////    return Scaffold(
////      appBar: AppBar(
////        title: const Text('Vehicle Details'),
////      ),
////      body: Column(
////        crossAxisAlignment: CrossAxisAlignment.start,
////        children: [
////          Text('Nickname: ${vehicle['vehicleNickname']}'),
////          Text('Make: ${vehicle['make']}'),
////          Text('Model: ${vehicle['model']}'),
////          Text('Year: ${vehicle['year']}'),
////          // Add more details as needed
////        ],
////      ),
////    );
////  }
////}
