import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maintenance_manager/auth/auth_state.dart';
import 'package:maintenance_manager/cloud_models/maintenance_detail_records.dart';
import 'package:maintenance_manager/constants/maintenance_types.dart';
import 'package:maintenance_manager/constants/maintenance_type_labels.dart';
import 'package:maintenance_manager/data/cloud/read/maintenance_cloud_read.dart';
import 'package:maintenance_manager/data/cloud/write/maintenance_cloud_write.dart';
import 'package:maintenance_manager/helper_functions/format_date.dart';
import 'package:maintenance_manager/helper_functions/global_actions_menu.dart';
import 'package:maintenance_manager/helper_functions/page_navigator.dart';
import 'package:maintenance_manager/helper_functions/utility.dart';
import 'package:maintenance_manager/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DisplayMaintenanceLists extends StatefulWidget {
  final String vehicleCloudId;

  const DisplayMaintenanceLists({
    super.key,
    required this.vehicleCloudId,
  });

  @override
  State<DisplayMaintenanceLists> createState() =>
      DisplayMaintenanceListsState();
}

class DisplayMaintenanceListsState extends State<DisplayMaintenanceLists> {
  final MaintenanceCloudReadOperations _readOps =
      MaintenanceCloudReadOperations();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<MaintenanceRecordCloudModel> _records = [];

  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;

  bool _isLoading = false;
  bool _hasMore = true;

  String _selectedSortType = 'newest';
  String _selectedMaintenanceType = 'all';
  String _searchText = '';

  final List<String> _sortKeys = [
    'newest',
    'oldest',
    'type',
    'lowToHigh',
    'highToLow',
  ];

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

  Future<void> _reloadRecords() async {
    setState(() {
      _records.clear();
      _lastDoc = null;
      _hasMore = true;
      _isLoading = false;
    });

    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final userId = Provider.of<AuthState>(context, listen: false).userId;

    final orderConfig = _orderConfigForSort(_selectedSortType);

    final page = await _readOps.getMaintenanceRecordsPage(
      userId: userId,
      vehicleCloudId: widget.vehicleCloudId,
      limit: 25,
      startAfter: _lastDoc,
      orderByField: orderConfig.field,
      descending: orderConfig.descending,
      maintenanceType:
          _selectedMaintenanceType == 'all' ? null : _selectedMaintenanceType,
    );

    if (!mounted) return;

    setState(() {
      _records.addAll(page.records);
      _lastDoc = page.lastDoc;
      _hasMore = page.records.length == 25;
      _isLoading = false;
    });
  }

  _MaintenanceOrderConfig _orderConfigForSort(String sortType) {
    switch (sortType) {
      case 'oldest':
        return _MaintenanceOrderConfig('createdAt', false);
      case 'lowToHigh':
        return _MaintenanceOrderConfig('totalCost', false);
      case 'highToLow':
        return _MaintenanceOrderConfig('totalCost', true);
      case 'type':
        return _MaintenanceOrderConfig('maintenanceType', false);
      case 'newest':
      default:
        return _MaintenanceOrderConfig('createdAt', true);
    }
  }

  List<MaintenanceRecordCloudModel> _filteredView() {
    var list = List<MaintenanceRecordCloudModel>.from(_records);

    final q = _searchText.trim().toLowerCase();

    if (q.isNotEmpty) {
      list = _readOps.searchMaintenanceRecords(
        records: list,
        query: q,
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final prefs = Provider.of<UserPreferences>(context, listen: false);

    final sortLabels = {
      'newest': localizations.sortNewest,
      'oldest': localizations.sortOldest,
      'type': 'Maintenance Type',
      'lowToHigh': localizations.sortLowToHigh,
      'highToLow': localizations.sortHighToLow,
    };

    final view = _filteredView();

    return CustomScaffold(
      title: 'Maintenance Records',
      showActions: true,
      showBackButton: true,
      onBack: () {
        navigateToSpecificVehiclePage(context, widget.vehicleCloudId);
      },
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search maintenance records',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => _searchText = value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedMaintenanceType,
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem(
                          value: 'all',
                          child: Text('All Types'),
                        ),
                        ...MaintenanceTypes.all.map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(MaintenanceTypeLabels.labelFor(type)),
                          ),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value == null) return;
                        _selectedMaintenanceType = value;
                        await _reloadRecords();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedSortType,
                      isExpanded: true,
                      items: _sortKeys.map((key) {
                        return DropdownMenuItem(
                          value: key,
                          child: Text(sortLabels[key]!),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        if (value == null) return;
                        _selectedSortType = value;
                        await _reloadRecords();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: view.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : view.isEmpty
                      ? const Center(
                          child: Text('No maintenance records found'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: view.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == view.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            final record = view[index];

                            return _maintenanceCard(
                              record: record,
                              prefs: prefs,
                              onDelete: () => _deleteMaintenanceRecord(record),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteMaintenanceRecord(
    MaintenanceRecordCloudModel record,
  ) async {
    await decrementLifeTimeMaintenanceCosts(
      record.vehicleCloudId,
      record.userId,
      record.totalCost,
    );

    await MaintenanceCloudWriteOperations().deleteMaintenanceRecord(record);

    if (!mounted) return;

    setState(() {
      _records.removeWhere((r) => r.id == record.id);
    });
  }

  Widget _maintenanceCard({
    required MaintenanceRecordCloudModel record,
    required UserPreferences prefs,
    required VoidCallback onDelete,
  }) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text(
                  'Are you sure you want to delete this maintenance record?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: () {
          navigateToEditMaintenanceRecordPage(
            context,
            widget.vehicleCloudId,
            record.id,
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.build,
                    size: 56,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        MaintenanceTypeLabels.labelFor(record.maintenanceType),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        formatDateForUser(record.date, prefs.dateFormat),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${prefs.currencySymbol}${record.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      if ((record.shopName ?? '').isNotEmpty)
                        Text(
                          record.shopName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      if (record.attachmentUrls.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(Icons.attach_file, size: 18),
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
    _searchController.dispose();
    super.dispose();
  }
}

class _MaintenanceOrderConfig {
  final String field;
  final bool descending;

  _MaintenanceOrderConfig(this.field, this.descending);
}
