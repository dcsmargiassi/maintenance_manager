import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/data/database_operations.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/models/battery_detail_records.dart';
import 'package:maintenance_manager/models/engine_detail_records.dart';
import 'package:maintenance_manager/models/exterior_detail_records.dart';
import 'package:maintenance_manager/models/vehicle_information.dart';
import 'package:provider/provider.dart';


class DisplayArchivedVehicleInfo extends StatefulWidget {
  final int vehicleId;

   const DisplayArchivedVehicleInfo({super.key, required this.vehicleId});

  @override
  DisplayVehicleInfoState createState() => DisplayVehicleInfoState();
}

class DisplayVehicleInfoState extends State<DisplayArchivedVehicleInfo> {
  late Future<VehicleInformationModel> _vehicleInfoFuture;
  late Future<EngineDetailsModel> _engineDetailsFuture;
  late Future<BatteryDetailsModel> _batteryDetailsFuture;
  late Future<ExteriorDetailsModel> _exteriorDetailsFuture;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  double? _selectedMonthFuelCost;
  double? _selectedYearFuelCost;
  final Map<int, String> monthNames = const {
      1: 'January', 2: 'February', 3: 'March', 4: 'April',
      5: 'May', 6: 'June', 7: 'July', 8: 'August',
      9: 'September', 10: 'October', 11: 'November', 12: 'December',
    };

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    final userId = authState.userId;
    _vehicleInfoFuture = VehicleOperations().getVehicleById(widget.vehicleId, userId!);
    _engineDetailsFuture = EngineDetailsOperations().getEngineDetailsByVehicleId(userId, widget.vehicleId);
    _batteryDetailsFuture = BatteryDetailsOperations().getBatteryDetailsByVehicleId(userId, widget.vehicleId);
    _exteriorDetailsFuture = ExteriorDetailsOperations().getExteriorDetailsByVehicleId(userId, widget.vehicleId);
    _fetchInitialMonthYearCosts(userId, _selectedYear, _selectedMonth);
    if(mounted) {
        setState(() {});
      }
  }
  void _fetchInitialMonthYearCosts(String userId, int year, int month) async {
    final monthCost = await getFuelCostByMonthYear(widget.vehicleId, userId, year, month);
    final yearCost = await getFuelCostByYear(widget.vehicleId, userId, year);

    if (!mounted) return;

    setState(() {
      _selectedMonthFuelCost = monthCost;
      _selectedYearFuelCost = yearCost;
    });
  }

  Future<double> getMonthlyFuelCost (int vehicleId, String userId) async {
  DateTime now = DateTime.now();
  int currentYear = now.year;
  int previousMonth = now.month - 1;
  if (previousMonth == 0) {
    previousMonth = 12;
    currentYear -= 1;
  }

  final records = await FuelRecordOperations().getFuelRecordsByMonth(vehicleId, currentYear, previousMonth);
  double totalCost = records.fold(0.0, (sum, record) => sum + (record.refuelCost ?? 0));
  return totalCost;
  }

  void _onMonthYearChanged(int year, int month, String userId) async {
    setState(() {
      _selectedMonth = month;
      _selectedYear = year;
    });

    final monthCost = await getFuelCostByMonthYear(widget.vehicleId, userId, year, month);
    final yearCost = await getFuelCostByYear(widget.vehicleId, userId, year);

    if (!mounted) return;

    setState(() {
      _selectedMonthFuelCost = monthCost;
      _selectedYearFuelCost = yearCost;
    });
  }

  Future<double> getFuelCostByMonthYear(int vehicleId, String userId, int year, int month) async {
    final records = await FuelRecordOperations().getFuelRecordsByMonth(vehicleId, year, month);

    double totalCost = 0.0;
    for (final record in records) {
      final cost = record.refuelCost;
      totalCost += cost ?? 0;
    }
    return totalCost;
  }

  Future<double> getFuelCostByYear(int vehicleId, String userId, int year) async {
    final records = await FuelRecordOperations().getFuelRecordsByYear(vehicleId, year);
  
    double totalCost = 0.0;
    for (final record in records) {
      final cost = record.refuelCost;  
      totalCost += cost ?? 0;
    }
    return totalCost;
  }
  

  Widget _infoText(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    child: Align(alignment: Alignment.centerLeft,
      child: Text
        ("$label: ${value ?? 'N/A'}", style: const TextStyle(fontSize: 16), textAlign: TextAlign.left),
      ),
    );
  }

  // Widget to create the buttons for archived vehicle information pages.
  Widget buildVehicleButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis)),
          child: FittedBox(child: Text(label)),
        ),
      ),
    );
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
            navigateToArchivedVehicles(context);
          },
        ),
        title: const Text(
          'Vehicle Information',
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
        child: FutureBuilder<VehicleInformationModel>(
          future: _vehicleInfoFuture,
          builder: (BuildContext context, AsyncSnapshot<VehicleInformationModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } if(!snapshot.hasData) {
              return const Center(
                child: Text("No Vehicle Found"),
              );
            }
            return FutureBuilder<EngineDetailsModel>(
              future: _engineDetailsFuture,
              builder: (context, engineSnapshot) {
                if (!engineSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FutureBuilder<BatteryDetailsModel>(
                  future: _batteryDetailsFuture,
                  builder: (context, batterySnapshot) {
                    if (!batterySnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return FutureBuilder<ExteriorDetailsModel>(
                      future: _exteriorDetailsFuture,
                      builder: (context, exteriorSnapshot) {
                        if (!exteriorSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                  
                      return _displayVehicleDetails(
                        snapshot.data!,
                        engineSnapshot.data!,
                        batterySnapshot.data!,
                        exteriorSnapshot.data!,
                        );
                      }
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _displayVehicleDetails (
    VehicleInformationModel vehicleData,
    EngineDetailsModel engineData,
    BatteryDetailsModel batteryData,
    ExteriorDetailsModel exteriorData,
    ) {
    double sizedBoxHeight = 20.0;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  navigateToEditVehiclePage(
                    context,
                    vehicleData.vehicleId!,
                    vehicleData.archived!,
                    onReturn: () {
                      setState(() {
                        _vehicleInfoFuture = VehicleOperations().getVehicleById(
                          widget.vehicleId,
                          Provider.of<AuthState>(context, listen: false).userId!,
                        );
                      });
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Vehicle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              _infoText("Name", vehicleData.vehicleNickName),
              _infoText("Make", vehicleData.make),
              _infoText("Model", vehicleData.model),
              _infoText("Year", vehicleData.year.toString()),
              _infoText("VIN", vehicleData.vin),
              _infoText("Mileage", vehicleData.odometerCurrent.toString()),
              _infoText("Fuel Cost", "\$${vehicleData.lifeTimeFuelCost?.toStringAsFixed(2) ?? '0.00'}"),
              _infoText("Repair Cost", "\$${vehicleData.lifeTimeMaintenanceCost?.toStringAsFixed(2) ?? '0.00'}"),

            ],
          ),
          ExpansionTile(
              key: ValueKey('financial_summary_${_selectedYear}_$_selectedMonth'),
              title: const Text("Financial Summary", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Year Selector Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Year",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<int>(
                              value: _selectedYear,
                              onChanged: (newYear) {
                                if (newYear != null) {
                                  final userId = Provider.of<AuthState>(context, listen: false).userId!;
                                  _onMonthYearChanged(newYear, _selectedMonth, userId);
                                }
                              },
                              items: List.generate(10, (index) {
                                final year = DateTime.now().year - index;
                                return DropdownMenuItem(value: year, child: Text('$year'));
                              }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Month Selector Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Month",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<int>(
                              value: _selectedMonth,
                              onChanged: (newMonth) {
                                if (newMonth != null) {
                                  final userId = Provider.of<AuthState>(context, listen: false).userId!;
                                  _onMonthYearChanged(_selectedYear, newMonth, userId);
                                }
                              },
                              items: List.generate(12, (index) {
                                final monthNumber = index + 1;
                                final monthName = monthNames[monthNumber]!;
                                return DropdownMenuItem(value: monthNumber, child: Text(monthName));
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _infoText(
                  "Fuel Cost for $_selectedMonth/$_selectedYear",
                  _selectedMonthFuelCost != null ? "\$${_selectedMonthFuelCost!.toStringAsFixed(2)}" : "No Data"
                ),
                _infoText(
                  "Fuel Cost for $_selectedYear",
                  _selectedYearFuelCost != null ? "\$${_selectedYearFuelCost!.toStringAsFixed(2)}" : "No Data"
                ),
                _infoText(
                  "Lifetime Fuel Cost",
                  "\$${vehicleData.lifeTimeFuelCost?.toStringAsFixed(2) ?? '0.00'}"
                ),
                _infoText(
                  "Purchase Price",
                  "\$${vehicleData.purchasePrice?.toStringAsFixed(2) ?? '0.00'}"
                ),
                _infoText(
                  "Lifetime Maintenance Cost",
                  "\$${vehicleData.lifeTimeMaintenanceCost?.toStringAsFixed(2) ?? '0.00'}"
                ),
                _infoText(
                  "Lifetime Vehicle Cost",
                  "\$${(
                      (vehicleData.purchasePrice ?? 0) +
                      (vehicleData.lifeTimeFuelCost ?? 0) +
                      (vehicleData.lifeTimeMaintenanceCost ?? 0)
                    ).toStringAsFixed(2)}"
                ),
              ],
            ),
          ExpansionTile(
            title: const Text("Engine Details", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              _infoText("Engine Details", engineData.engineSize),
              _infoText("Cylinders", engineData.cylinders),
              _infoText("Engine Type", engineData.engineType),
              _infoText("Oil Weight", engineData.oilWeight),
              _infoText("Oil Filter", engineData.oilFilter),
            ],
          ),
          ExpansionTile(
            title: const Text("Battery Details", style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              _infoText("Series Type", batteryData.batterySeriesType),
              _infoText("Battery Size", batteryData.batterySize),
              _infoText("Cold Crank Amps", "${batteryData.coldCrankAmps ?? 'N/A'}"),
            ],
          ),
          ExpansionTile(
            title: const Text(
              "Exterior Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              _infoText("Driver Windshield Wiper", exteriorData.driverWindshieldWiper),
              _infoText("Passenger Windshield Wiper", exteriorData.passengerWindshieldWiper),
              _infoText("Rear Windshield Wiper", exteriorData.rearWindshieldWiper),
              _infoText("Headlamp High Beam", exteriorData.headlampHighBeam),
              _infoText("Headlamp Low Beam", exteriorData.headlampLowBeam),
              _infoText("Turn Lamp", exteriorData.turnLamp),
              _infoText("Backup Lamp", exteriorData.backupLamp),
              _infoText("Fog Lamp", exteriorData.fogLamp),
              _infoText("Brake Lamp", exteriorData.brakeLamp),
              _infoText("License Plate Lamp", exteriorData.licensePlateLamp),
            ],
          ),
          SizedBox(height: sizedBoxHeight),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Column(
              children:[
                Row(
                  children: [
                    buildVehicleButton('Fuel History', () {
                      navigateToDisplayFuelRecordPage(context, vehicleData.vehicleId!);
                    }),
                    const SizedBox(width: 16.0), 
                    buildVehicleButton('Work History', () {
                      navigateToAddFuelRecordPage(context, vehicleData.vehicleId!);
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    buildVehicleButton('Unarchive', () async {
                      if (!mounted) return;
                      final userId = Provider.of<AuthState>(context, listen: false).userId!;
                      await VehicleOperations().unarchiveVehicleById(userId, vehicleData.vehicleId!);
                      if (!mounted) return;
                      navigateToSpecificVehiclePage(context, vehicleData.vehicleId!);
                    }),
                    const SizedBox(width: 16.0),
                    buildVehicleButton('Delete Vehicle', () {
                      navigateToEditVehiclePage(
                        context, 
                        vehicleData.vehicleId!,
                        vehicleData.archived!,
                        onReturn: () {
                          setState(() {
                            _vehicleInfoFuture = VehicleOperations().getVehicleById(widget.vehicleId, Provider.of<AuthState>(context, listen: false).userId!);
                          });
                        }
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}