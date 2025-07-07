import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/models/fuel_records.dart';
import 'package:provider/provider.dart';

class DisplayFuelLists extends StatefulWidget {
  final int vehicleId;
  const DisplayFuelLists({super.key, required this.vehicleId});

  @override
  DisplayFuelListsState createState() => DisplayFuelListsState();
}

class DisplayFuelListsState extends State<DisplayFuelLists> {
  late Future<List<FuelRecords>> _fuelRecordsFuture;
  final List<String> _sortByType = ["Newest", "Oldest", "Low to High", "High to Low"];
  String _selectedSortType = "Newest";

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
      case "Newest":
        records.sort((a, b) => b.date!.compareTo(a.date!));
        break;
      case "Oldest":
        records.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case "Low to High":
        records.sort((a, b) => (a.refuelCost ?? 0).compareTo(b.refuelCost ?? 0));
        break;
      case "High to Low":
        records.sort((a, b) => (b.refuelCost ?? 0).compareTo(a.refuelCost ?? 0));
        break;
    }
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
            //Navigator.pop(context);
            navigateToSpecificVehiclePage(context, widget.vehicleId);
          },
        ),
        title: const Text(
          'Fuel Records',
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
                await navigateToSettingsPage(context);
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      hint: const Text("Select Sort Type"),
                      value: _selectedSortType,
                      isExpanded: true,
                      items: _sortByType.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
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
                    child: const Text("Sort"),
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
                          decrementLifeTimeFuelCosts(widget.vehicleId, record.userId!, record.fuelPrice!);
                          await FuelRecordOperations().deleteFuelRecord(record.fuelRecordId!);
                          setState(() {
                            records.removeAt(index);
                          });
                        });
                      },
                    );
                  } 
                  else {
                    return const Center(child: Text("No Fuel Records Found"));
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
    // Implementation of slide to left to delete a fuel record on confirmation
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
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to delete this fuel record?"),
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
                        formatDateDisplayToString(data.date),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${data.refuelCost}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${data.fuelAmount} gallons @ \$${data.fuelPrice}/gal",
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