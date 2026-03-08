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
import 'package:maintenance_manager/cloud_models/vehicle_detail_records.dart';
import 'package:maintenance_manager/data/cloud/read/vehicle_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/write/fuel_cloud_write.dart';
import 'package:maintenance_manager/data/cloud/write/vehicle_cloud_write.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DisplayArchivedVehicleLists extends StatefulWidget {
  const DisplayArchivedVehicleLists({super.key});

  @override
  DisplayVehicleListsState createState() => DisplayVehicleListsState();
}

class DisplayVehicleListsState extends State<DisplayArchivedVehicleLists> {
  late Future<List<VehicleInformationCloudModel>> _vehiclesFuture;
  List<VehicleInformationCloudModel> _nonArchivedVehicles = [];
  VehicleInformationCloudModel? _selectedVehicle;
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
    _vehiclesFuture = VehicleCloudReadOperations().getAllArchivedVehiclesByUserId(userId);
  });
    final vehicles = await VehicleCloudReadOperations().getAllActiveVehiclesByUserId(userId);
    setState(() {
      _nonArchivedVehicles = vehicles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.of(context)!.archivedVehiclesTitle,
      onBack: () {
        navigateToHomePage(context);
        },
        showActions: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<VehicleInformationCloudModel>(
                      hint: Text(AppLocalizations.of(context)!.selectVehicleHint),
                      value: _selectedVehicle,
                      isExpanded: true,
                      items: _nonArchivedVehicles.map((vehicle) {
                        return DropdownMenuItem<VehicleInformationCloudModel>(
                          value: vehicle,
                          child: Text(vehicle.vehicleNickName ?? 'Unnamed Vehicle'),
                        );
                      }).toList(),
                      onChanged: (VehicleInformationCloudModel? newValue) {
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
                          final archiveDate = DateTime.now();
                          final date = formatDateToString(archiveDate);
                          setState(() => _isLoading = true);
                          await VehicleCloudWriteOperations().archiveVehicle(userId: userId, cloudVehicleId: _selectedVehicle!.cloudId, sellDateIso: date);
                          setState(() {
                            _vehiclesFuture = VehicleCloudReadOperations().getAllArchivedVehiclesByUserId(userId);
                          });
                          _nonArchivedVehicles = await VehicleCloudReadOperations().getAllVehicles(userId);
                          _selectedVehicle = null;
                          setState(() => _isLoading = false);
                        },
                    child: Text(AppLocalizations.of(context)!.archiveButtonLabel),
                  ),
                ],
              ),
            ),
            // Deleting a vehicle. Wiping all fuel records and vehicle records.
            Expanded(
              child: FutureBuilder<List<VehicleInformationCloudModel>>(
                future: _vehiclesFuture,
                builder: (BuildContext context, AsyncSnapshot<List<VehicleInformationCloudModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final vehicle = snapshot.data![index];
                        return _displayVehicles(vehicle, () async {
                          final userId = Provider.of<AuthState>(context, listen: false).userId;
                          final vehicleId = vehicle.cloudId;
                          await FuelCloudWriteOperations().deleteAllFuelRecordsByVehicleCloudId(userId, vehicleId);
                          await VehicleCloudWriteOperations().deleteVehicle(userId: userId, cloudVehicleId: vehicleId);
                          setState(() {
                            _vehiclesFuture = VehicleCloudReadOperations().getAllArchivedVehiclesByUserId(userId);
                          });
                          
                        });
                      },
                    );
                  } else {
                    return Center(child: Text(AppLocalizations.of(context)!.noArchivedVehiclesMessage));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayVehicles(VehicleInformationCloudModel data, VoidCallback onDelete) {
    return Dismissible(
      key: Key(data.cloudId.toString()),
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
            title: Text(AppLocalizations.of(context)!.confirmDeletionMessage),
            content: Text(AppLocalizations.of(context)!.confirmDeletionMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.deleteButton, style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onDelete(); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
          (content: Text(AppLocalizations.of(context)!.deleteSnackBarMessage)));
      },
      child: GestureDetector(
        onTap: () {
          navigateToSpecificArchivedVehiclePage(context, data.cloudId);
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
      ),
    );
  }
}