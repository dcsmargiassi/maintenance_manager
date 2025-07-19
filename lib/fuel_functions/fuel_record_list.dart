import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
import 'package:maintenance_manager/settings/display_constants.dart';
import 'package:provider/provider.dart';

class DisplayFuelLists extends StatefulWidget {
  final int vehicleId;
  const DisplayFuelLists({super.key, required this.vehicleId});

  @override
  DisplayFuelListsState createState() => DisplayFuelListsState();
}

class DisplayFuelListsState extends State<DisplayFuelLists> {
  late Future<List<FuelRecords>> _fuelRecordsFuture;
  final List<String> _sortKeys =  ['newest', 'oldest', 'lowToHigh', 'highToLow'];
  String _selectedSortType = 'newest';

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId!;
    _fuelRecordsFuture = FuelRecordOperations().getAllFuelRecordsByVehicleId(userId, widget.vehicleId);
  }

  // Sort function based on user input, default is newest to oldest.
  void _sortRecords(List<FuelRecords> records) {
    switch (_selectedSortType) {
      case 'newest':
        records.sort((a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));
        break;
      case 'oldest':
        records.sort((a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
        break;
      case 'lowToHigh':
        records.sort((a, b) => (a.refuelCost ?? 0).compareTo(b.refuelCost ?? 0));
        break;
      case 'highToLow':
        records.sort((a, b) => (b.refuelCost ?? 0).compareTo(a.refuelCost ?? 0));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final Map<String, String> sortLabels = {
    'newest': localizations.sortNewest,
    'oldest': localizations.sortOldest,
    'lowToHigh': localizations.sortLowToHigh,
    'highToLow': localizations.sortHighToLow,
  };
  final userId = FirebaseAuth.instance.currentUser?.uid;
    return CustomScaffold(
      title: localizations.fuelRecordsTitle,
      onBack: () async {
        final vehicleOps = VehicleOperations();
        final vehicle = await vehicleOps.getVehicleById(widget.vehicleId, userId!);
        if(!context.mounted) return;
        if (vehicle.archived == 0) {
          navigateToSpecificVehiclePage(context, widget.vehicleId);
        } else {
          navigateToSpecificArchivedVehiclePage(context, widget.vehicleId);
        }
      },
      showActions: true,
      showBackButton: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text(localizations.selectSortTypeLabel),
                      value: _selectedSortType,
                      isExpanded: true,
                      items: _sortKeys.map((key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(sortLabels[key]!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSortType = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => setState(() {}), 
                    child: Text(localizations.sortButton),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<FuelRecords>>(
                future: _fuelRecordsFuture,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } 
                  else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<FuelRecords> records = snapshot.data!;
                    // sort before calling display
                    _sortRecords(records);

                    // Check for deleted fuel record, if so remove at specified index and refresh
                    return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        // if deleted, .deletefuel record function will be caleld, removing record/updating state
                        return _displayFuelRecords(record, () async {
                          // Decrement lifetime fuel costs prior to fully deleting record
                          decrementLifeTimeFuelCosts(widget.vehicleId, record.userId!, record.refuelCost!);
                          await FuelRecordOperations().deleteFuelRecord(record.fuelRecordId!);
                          setState(() {
                            records.removeAt(index);
                          });
                        });
                      },
                    );
                  } 
                  else {
                    return Center(child: Text(localizations.noRecordsFoundMessage));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayFuelRecords(FuelRecords data, VoidCallback onDelete) {
    final prefs = Provider.of<UserPreferences>(context, listen: false);
    // Implementation of slide to left to delete a fuel record on confirmation
    var distanceVolume = "gallon";
    if( prefs.distanceUnit == "Miles") {
      distanceVolume = "gallons";
    }
    else {
      distanceVolume = "liters";
    }
    final displayUnit = distanceUnits[prefs.distanceUnit] ?? prefs.distanceUnit;
    return Dismissible(
      key: Key(data.fuelRecordId.toString()),
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
            title: Text(AppLocalizations.of(context)!.confirmDeleteButton),
            content: Text(AppLocalizations.of(context)!.confirmFuelRecordDeleteMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.deleteButton, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onDelete(); 
      },
      child: GestureDetector(
        onTap: () {
          navigateToEditFuelRecordPage(context, data.vehicleId!, data.fuelRecordId!);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon to display a gas station pump
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.local_gas_station,
                    size: 64,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDateForUser(data.date, prefs.dateFormat),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${prefs.currencySymbol}${data.refuelCost}",
                        style: const TextStyle(fontSize: 16),
                      ), 
                      Text(
                        "${data.fuelAmount} $distanceVolume @ ${prefs.currencySymbol}${data.fuelPrice}/$displayUnit",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}