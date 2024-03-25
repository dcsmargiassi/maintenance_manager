/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: My Vehicles display page which will display all the vehicles stored in the LOCAL device. Upon click,
  navigation function will bring to page displaying specific vehicle information related to device.
  - Minimum information is displayed on each card, just showing vehicle Nickname, make, model, and year
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

class DisplayVehicleLists extends StatefulWidget {
  const DisplayVehicleLists({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DisplayVehicleListsState createState() => _DisplayVehicleListsState();
}

class _DisplayVehicleListsState extends State<DisplayVehicleLists> {
@override
void initState() {
  super.initState();
}
  
  @override
  Widget build(BuildContext context) {
    VehicleOperations vehicleOperations = VehicleOperations();
    return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Vehicles',
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
      body: SafeArea(
        child: FutureBuilder<List<VehicleInformationModel>>(
          future: vehicleOperations.getAllVehicles(),
            builder: (BuildContext context, AsyncSnapshot<List<VehicleInformationModel>> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                 itemCount: snapshot.data!.length,
                 itemBuilder: (context, index){
                    return _displayVehicles(snapshot.data![index]);
                  });
              }
             else {
                return Center(child: Text("No Vehicles Entered"),
                );
              }
            } 
        ,)  
      ),
    ),
    debugShowCheckedModeBanner: true,
    );
  }
  Widget _displayVehicles(VehicleInformationModel data){
    return GestureDetector(
      onTap: () {
          navigateToSpecificVehiclePage(context, data);
      },
      child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data.vehicleNickName}",
              style: TextStyle(fontSize: 24),
              ),
            Row(children: [
              Expanded(
                flex:1,
                child: Text(
                  "${data.make}",
                  style: TextStyle(fontSize: 18),
                  )), 
              Expanded(
                flex:2,
                child: Text(
                  "${data.model}",
                style: TextStyle(fontSize: 18),
                )),
              Expanded(
                flex:3,
                child: Text(
                  "${data.year}",
                  style: TextStyle(fontSize: 18),
                  ))
            ],
          )
        ],
      ),
      ),
      //onTap: () {
      //    navigateToSpecificVehiclePage(context, data);
      //}
      )
    );
  }
}