/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: My Vehicles display page which will display all the vehicles stored in the LOCAL device. Upon click,
  navigation function will bring to page displaying specific vehicle information related to device.
  - Minimum information is displayed on each card, just showing vehicle Nickname, make, model, and year
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/cloud_models/vehicle_detail_records.dart';
import 'package:maintenance_manager/data/cloud/read/vehicle_cloud_read.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DisplayVehicleLists extends StatefulWidget {
  const DisplayVehicleLists({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DisplayVehicleListsState createState() => _DisplayVehicleListsState();
}

class _DisplayVehicleListsState extends State<DisplayVehicleLists> {
  late Future<List<VehicleInformationCloudModel>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);

    if (authState.isGuest) {
      _vehiclesFuture = Future.value(_getFakeGuestVehicles());
    } else {
      final userId = authState.userId;
      _vehiclesFuture = VehicleCloudReadOperations().getAllActiveVehiclesByUserId(userId);
    }
  }

  // Fake vehicle entries for guest preview
  List<VehicleInformationCloudModel> _getFakeGuestVehicles() {
    return [
      VehicleInformationCloudModel(
        cloudId: "1",
        userId: '1',
        vehicleNickName: 'Guest Truck',
        vin: "guest*",
        make: 'Ford',
        model: 'F-150',
        year: 2020,
      ),
      VehicleInformationCloudModel(
        cloudId: "2",
        userId: '1',
        vehicleNickName: 'Guest Sedan',
        vin: "guest*",
        make: 'Toyota',
        model: 'Camry',
        year: 2018,
      ),
    ];
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
        title:Text(
          AppLocalizations.of(context)!.myVehiclesButton,
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          buildAppNavigatorMenu(context),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<VehicleInformationCloudModel>>(
          future: _vehiclesFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<VehicleInformationCloudModel>> snapshot) {
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

  Widget _displayVehicles(VehicleInformationCloudModel data) {
    return GestureDetector(
      onTap: () {
        if(data.vin == "guest*"){
          navigateToGuestVehicleDisplayPage(context);
        }
        else{
          final cloudId = data.cloudId;
          if (cloudId.isEmpty) {
            // If this happens, it means mapping isn't setting doc.id → cloudId
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This vehicle isn't synced yet.")),
            );
            return;
          }

          navigateToSpecificVehiclePage(context, cloudId);
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.directions_car,
                  size: 48,
                  color: Colors.black,
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.vehicleNickName ?? "Unnamed Vehicle",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${data.make ?? ""} ${data.model ?? ""} • ${data.year}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}