import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/cloud_models/fuel_detail_records.dart';
import 'package:maintenance_manager/data/cloud/read/fuel_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/write/fuel_cloud_write.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:maintenance_manager/settings/display_constants.dart';
import 'package:provider/provider.dart';

class DisplayFuelLists extends StatefulWidget {
  final String vehicleCloudId;

  const DisplayFuelLists({
    super.key,
    required this.vehicleCloudId,
  });

  @override
  State<DisplayFuelLists> createState() => DisplayFuelListsState();
}

class DisplayFuelListsState extends State<DisplayFuelLists> {
  final FuelCloudReadOperations _readOps = FuelCloudReadOperations();

  final ScrollController _scrollController = ScrollController();

  final List<FuelRecordCloudModel> _records = [];
  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  bool _isLoading = false;
  bool _hasMore = true;

  final List<String> _sortKeys = ['newest', 'oldest', 'lowToHigh', 'highToLow'];
  String _selectedSortType = 'newest';

  @override
  void initState() {
    super.initState();
    _loadNextPage();

    _scrollController.addListener(() {
      if (!_hasMore || _isLoading) return;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadNextPage();
      }
    });
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final userId = Provider.of<AuthState>(context, listen: false).userId;

    final page = await _readOps.getFuelRecordsPage(
      userId: userId,
      vehicleCloudId: widget.vehicleCloudId,
      limit: 25,
      startAfter: _lastDoc,
    );

    if (!mounted) return;

    setState(() {
      _records.addAll(page.records);
      _lastDoc = page.lastDoc;
      _hasMore = page.records.length == 25;
      _isLoading = false;
    });
  }

  List<FuelRecordCloudModel> _sortedView() {
    final list = List<FuelRecordCloudModel>.from(_records);

    switch (_selectedSortType) {
      case 'newest':
        return list;

      case 'oldest':
        return list.reversed.toList();

      case 'lowToHigh':
        list.sort((a, b) => a.refuelCost.compareTo(b.refuelCost));
        return list;

      case 'highToLow':
        list.sort((a, b) => b.refuelCost.compareTo(a.refuelCost));
        return list;

      default:
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    final Map<String, String> sortLabels = {
      'newest': localizations.sortNewest,
      'oldest': localizations.sortOldest,
      'lowToHigh': localizations.sortLowToHigh,
      'highToLow': localizations.sortHighToLow,
    };

    final view = _sortedView();

    return CustomScaffold(
      title: localizations.fuelRecordsTitle,
      showActions: true,
      showBackButton: true,
      onBack: () {
        navigateToSpecificVehiclePage(context, widget.vehicleCloudId);
      },
      body: SafeArea(
        child: Column(
          children: [
            // Sort row
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
                        if (newValue == null) return;
                        setState(() => _selectedSortType = newValue);
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

            // List
            Expanded(
              child: view.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : view.isEmpty
                      ? Center(child: Text(localizations.noRecordsFoundMessage))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: view.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == view.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            final record = view[index];
                            return _fuelCard(
                              record: record,
                              prefs: prefs,
                              onDelete: () => _deleteFuelRecord(record),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteFuelRecord(FuelRecordCloudModel record) async {
    await decrementLifeTimeFuelCosts(
      record.vehicleCloudId,
      record.userId,
      record.refuelCost,
    );
  
    await FuelCloudWriteOperations().deleteFuelRecord(record);
  
    if (!mounted) return;
  
    setState(() {
      _records.removeWhere((r) => r.cloudId == record.cloudId);
    });
  }

  Widget _fuelCard({
    required FuelRecordCloudModel record,
    required UserPreferences prefs,
    required VoidCallback onDelete,
  }) {
    // Unit text
    final volumeUnit = (prefs.distanceUnit == "Miles") ? "gallons" : "liters";
    final displayUnit = distanceUnits[prefs.distanceUnit] ?? prefs.distanceUnit;

    final key = record.cloudId ?? '${record.date}_${record.refuelCost}';

    return Dismissible(
      key: Key(key),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
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
                    child: Text(
                      AppLocalizations.of(context)!.deleteButton,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (direction) => onDelete(),
      child: GestureDetector(
        onTap: () {
          final fuelRecordCloudId = record.cloudId;
          if (fuelRecordCloudId == null || fuelRecordCloudId.isEmpty) return;
          navigateToEditFuelRecordPage(context, widget.vehicleCloudId, fuelRecordCloudId);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.local_gas_station, size: 64, color: Colors.black),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDateForUser(record.date, prefs.dateFormat),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${prefs.currencySymbol}${record.refuelCost.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "${record.fuelAmount} $volumeUnit @ ${prefs.currencySymbol}${record.fuelPrice.toStringAsFixed(2)}/$displayUnit",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}