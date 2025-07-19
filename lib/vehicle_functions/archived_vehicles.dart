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
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:provider/provider.dart';

class DisplayArchivedVehicleLists extends StatefulWidget {
  const DisplayArchivedVehicleLists({super.key});

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
                    child: DropdownButton<VehicleInformationModel>(
                      hint: Text(AppLocalizations.of(context)!.selectVehicleHint),
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
                          final archiveDate = DateTime.now();
                          final date = formatDateToString(archiveDate);
                          setState(() => _isLoading = true);
                          await VehicleOperations().archiveVehicleById(_selectedVehicle!.vehicleId!, date);
                          setState(() {
                            _vehiclesFuture = VehicleOperations().getAllArchivedVehiclesByUserId(userId!);
                          });
                          _nonArchivedVehicles = await VehicleOperations().getAllVehiclesByUserId(userId!);
                          _selectedVehicle = null;
                          setState(() => _isLoading = false);
                        },
                    child: Text(AppLocalizations.of(context)!.archiveButtonLabel),
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