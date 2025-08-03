/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Dummy display vehicle information page for guest accounts previewing the app
 - All data here is faked and uneditable buttons are removed and not shown for editing vehicle information
 or adding a fuel record
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
import 'package:flutter/material.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';

class GuestDisplayVehicleInfoPage extends StatefulWidget {
  const GuestDisplayVehicleInfoPage({super.key});

  @override
  GuestDisplayVehicleInfoPageState createState() => GuestDisplayVehicleInfoPageState();
}

class GuestDisplayVehicleInfoPageState extends State<GuestDisplayVehicleInfoPage> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  // Dummy static data for display
  final dummyVehicleData = {
    'vehicleNickName': 'My Demo Car',
    'make': 'Toyota',
    'model': 'Camry',
    'year': '2020',
    'vin': '123456789ABCDEFG',
    'licensePlate': 'XYZ 1234',
    'odometerCurrent': '15,000',
    'lifeTimeFuelCost': 3500.75,
    'purchasePrice': 22000.00,
    'lifeTimeMaintenanceCost': 1500.50,
  };

  final dummyEngineData = {
    'engineSize': '2.5L',
    'cylinders': '4',
    'engineType': 'Inline',
    'oilWeight': '5W-30',
    'oilFilter': 'OEM Filter',
  };

  final dummyBatteryData = {
    'batterySeriesType': 'AGM',
    'batterySize': 'Group 24',
    'coldCrankAmps': 650,
  };

  final dummyExteriorData = {
    'driverWindshieldWiper': 'Standard',
    'passengerWindshieldWiper': 'Standard',
    'rearWindshieldWiper': 'Intermittent',
    'headlampHighBeam': 'LED',
    'headlampLowBeam': 'Halogen',
    'turnLamp': 'LED',
    'backupLamp': 'LED',
    'fogLamp': 'None',
    'brakeLamp': 'LED',
    'licensePlateLamp': 'LED',
  };

  final Map<int, String> monthNames = {
    1: 'January', 2: 'February', 3: 'March', 4: 'April',
    5: 'May', 6: 'June', 7: 'July', 8: 'August',
    9: 'September', 10: 'October', 11: 'November', 12: 'December',
  };

  void _onMonthYearChanged(int year, int month) {
    setState(() {
      _selectedYear = year;
      _selectedMonth = month;
    });
  }

  Widget _infoText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text("$label: ${value ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefsCurrencySymbol = '\$';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.vehicleInformationTitle ?? 'Vehicle Info (Guest)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Details
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                AppLocalizations.of(context)?.vehicleDetails ?? 'Vehicle Details',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                _infoText(AppLocalizations.of(context)?.nicknameLabel ?? 'Nickname', dummyVehicleData['vehicleNickName'] as String?),
                _infoText(AppLocalizations.of(context)?.makeLabel ?? 'Make', dummyVehicleData['make'] as String?),
                _infoText(AppLocalizations.of(context)?.modelLabel ?? 'Model', dummyVehicleData['model'] as String?),
                _infoText(AppLocalizations.of(context)?.yearLabel ?? 'Year', dummyVehicleData['year'] as String?),
                _infoText(AppLocalizations.of(context)?.vinLabel ?? 'VIN', dummyVehicleData['vin'] as String?),
                _infoText(AppLocalizations.of(context)?.licensePlateLabel ?? 'License Plate', dummyVehicleData['licensePlate'] as String?),
                _infoText(AppLocalizations.of(context)?.mileageLabel ?? 'Mileage', dummyVehicleData['odometerCurrent'] as String?),
              ],
            ),

            // Financial Summary
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                AppLocalizations.of(context)?.financialSummary ?? 'Financial Summary',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Year Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.selectYear ?? 'Select Year',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<int>(
                              value: _selectedYear,
                              onChanged: (newYear) {
                                if (newYear != null) {
                                  _onMonthYearChanged(newYear, _selectedMonth);
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

                      // Month Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.selectMonth ?? 'Select Month',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<int>(
                              value: _selectedMonth,
                              onChanged: (newMonth) {
                                if (newMonth != null) {
                                  _onMonthYearChanged(_selectedYear, newMonth);
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

                // Dummy financial data
                _infoText(
                  AppLocalizations.of(context)?.monthlyFuelCost(_selectedMonth, _selectedYear) ?? 'Monthly Fuel Cost',
                  "$prefsCurrencySymbol${(100 + _selectedMonth * 10).toStringAsFixed(2)}",
                ),
                _infoText(
                  AppLocalizations.of(context)?.yearlyFuelCost(_selectedYear) ?? 'Yearly Fuel Cost',
                  "$prefsCurrencySymbol${(1200 + _selectedYear % 100 * 5).toStringAsFixed(2)}",
                ),
                _infoText(
                  AppLocalizations.of(context)?.lifetimeFuelCost ?? 'Lifetime Fuel Cost',
                  "$prefsCurrencySymbol${dummyVehicleData['lifeTimeFuelCost']}",
                ),
                _infoText(
                  AppLocalizations.of(context)?.purchasePriceLabel ?? 'Purchase Price',
                  "$prefsCurrencySymbol${dummyVehicleData['purchasePrice']}",
                ),
                _infoText(
                  AppLocalizations.of(context)?.lifetimeMaintenanceCost ?? 'Lifetime Maintenance Cost',
                  "$prefsCurrencySymbol${dummyVehicleData['lifeTimeMaintenanceCost']}",
                ),
                _infoText(
                  AppLocalizations.of(context)?.lifetimeVehicleCost ?? 'Lifetime Vehicle Cost',
                  "\$27,001.25")
              ],
            ),

            // Engine Details
            ExpansionTile(
              title: Text(
                AppLocalizations.of(context)?.engineDetails ?? 'Engine Details',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                _infoText(AppLocalizations.of(context)?.engineDetails ?? 'Engine Size', dummyEngineData['engineSize']),
                _infoText(AppLocalizations.of(context)?.cylinderLabel ?? 'Cylinders', dummyEngineData['cylinders']),
                _infoText(AppLocalizations.of(context)?.engineTypeLabel ?? 'Engine Type', dummyEngineData['engineType']),
                _infoText(AppLocalizations.of(context)?.oilWeightLabel ?? 'Oil Weight', dummyEngineData['oilWeight']),
                _infoText(AppLocalizations.of(context)?.oilFilterLabel ?? 'Oil Filter', dummyEngineData['oilFilter']),
              ],
            ),

            // Battery Details
            ExpansionTile(
              title: Text(
                AppLocalizations.of(context)?.batteryDetails ?? 'Battery Details',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                _infoText(AppLocalizations.of(context)?.seriesTypeLabel ?? 'Series Type', dummyBatteryData['batterySeriesType'] as String?),
                _infoText(AppLocalizations.of(context)?.bciGroupSizeLabel ?? 'BCI Group Size', dummyBatteryData['batterySize'] as String?),
                _infoText(AppLocalizations.of(context)?.coldCrankAmpsLabel ?? 'Cold Crank Amps', "${dummyBatteryData['coldCrankAmps']}"),
              ],
            ),

            // Exterior Details
            ExpansionTile(
              title: Text(
                AppLocalizations.of(context)?.exteriorDetails ?? 'Exterior Details',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                _infoText(AppLocalizations.of(context)?.driverWiperLabel ?? 'Driver Windshield Wiper', dummyExteriorData['driverWindshieldWiper']),
                _infoText(AppLocalizations.of(context)?.passengerWiperLabel ?? 'Passenger Windshield Wiper', dummyExteriorData['passengerWindshieldWiper']),
                _infoText(AppLocalizations.of(context)?.rearWiperLabel ?? 'Rear Windshield Wiper', dummyExteriorData['rearWindshieldWiper']),
                _infoText(AppLocalizations.of(context)?.highBeamLabel ?? 'Headlamp High Beam', dummyExteriorData['headlampHighBeam']),
                _infoText(AppLocalizations.of(context)?.lowBeamLabel ?? 'Headlamp Low Beam', dummyExteriorData['headlampLowBeam']),
                _infoText(AppLocalizations.of(context)?.turnLampLabel ?? 'Turn Lamp', dummyExteriorData['turnLamp']),
                _infoText(AppLocalizations.of(context)?.backupLampLabel ?? 'Backup Lamp', dummyExteriorData['backupLamp']),
                _infoText(AppLocalizations.of(context)?.fogLampLabel ?? 'Fog Lamp', dummyExteriorData['fogLamp']),
                _infoText(AppLocalizations.of(context)?.brakeLampLabel ?? 'Brake Lamp', dummyExteriorData['brakeLamp']),
                _infoText(AppLocalizations.of(context)?.licenseLampLabel ?? 'License Plate Lamp', dummyExteriorData['licensePlateLamp']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}