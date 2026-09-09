import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/location_model.dart';
import '../services/database_service.dart';
import '../services/excel_service.dart';
import '../widgets/bulk_action_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/location_card.dart';
import '../widgets/page_background.dart';
import '../widgets/search_box.dart';
import 'edit_location_page.dart';

class SavedInfoPage extends StatefulWidget {
  const SavedInfoPage({super.key});

  @override
  State<SavedInfoPage> createState() => _SavedInfoPageState();
}

class _SavedInfoPageState extends State<SavedInfoPage> {
  final TextEditingController searchController = TextEditingController();
  final Set<int> selectedIds = {};

  List<LocationData> locations = [];
  bool selectAll = false;
  bool loading = true;

  List<LocationData> get filteredLocations {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) return locations;

    return locations.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.type.toLowerCase().contains(query) ||
          item.address.toLowerCase().contains(query) ||
          item.phone.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final data = await DatabaseService.getLocations();

    if (!mounted) return;

    setState(() {
      locations = data;
      selectedIds.clear();
      selectAll = false;
      loading = false;
    });
  }

  void selectAllItems(bool value) {
    setState(() {
      selectAll = value;
      selectedIds.clear();

      if (value) {
        for (final item in locations) {
          if (item.id != null) {
            selectedIds.add(item.id!);
          }
        }
      }
    });
  }

  void toggleItem(LocationData item, bool? value) {
    if (item.id == null) return;

    setState(() {
      if (value == true) {
        selectedIds.add(item.id!);
      } else {
        selectedIds.remove(item.id);
        selectAll = false;
      }
    });
  }

  Future<bool> confirmDelete(String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("حذف اطلاعات"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("انصراف"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;

    final confirmed = await confirmDelete(
      "${selectedIds.length} مورد حذف شود؟",
    );

    if (!confirmed) return;

    await DatabaseService.deleteLocations(selectedIds.toList());
    await loadData();
  }

  Future<void> deleteAll() async {
    if (locations.isEmpty) return;

    final confirmed = await confirmDelete(
      "تمام اطلاعات حذف شود؟",
    );

    if (!confirmed) return;

    await DatabaseService.deleteAllLocations();
    await loadData();
  }

  Future<void> deleteOne(LocationData item) async {
    if (item.id == null) return;

    final confirmed = await confirmDelete(
      "اطلاعات ${item.name} حذف شود؟",
    );

    if (!confirmed) return;

    await DatabaseService.deleteLocation(item.id!);
    await loadData();
  }

  Future<void> editItem(LocationData item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditLocationPage(location: item),
      ),
    );

    await loadData();
  }

  Future<void> exportExcel() async {
    final data = await DatabaseService.getLocations();

    if (data.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اطلاعاتی برای خروجی وجود ندارد"),
        ),
      );
      return;
    }

    await ExcelService.exportLocations(data);
  }

  void openMap(LocationData item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapViewPage(location: item),
      ),
    );
  }

  Widget buildList() {
    if (locations.isEmpty) {
      return const EmptyState(
        message: "هنوز اطلاعاتی ثبت نشده",
      );
    }

    if (filteredLocations.isEmpty) {
      return const EmptyState(
        message: "نتیجه‌ای برای جستجو پیدا نشد",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        final item = filteredLocations[index];
        final checked =
            item.id != null && selectedIds.contains(item.id);

        return LocationCard(
          item: item,
          checked: checked,
          onSelected: (value) => toggleItem(item, value),
          onEdit: () => editItem(item),
          onDelete: () => deleteOne(item),
          onMap: () => openMap(item),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "اطلاعات ثبت شده",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "all") {
                deleteAll();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: "all",
                child: Text("حذف همه"),
              ),
            ],
          ),
        ],
      ),
      body: PageBackground(
        child: SafeArea(
          child: loading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Column(
            children: [
              SearchBox(
                controller: searchController,
                onChanged: (_) => setState(() {}),
              ),
              BulkActionBar(
                selectAll: selectAll,
                onSelectAll: () => selectAllItems(!selectAll),
                onDelete: deleteSelected,
                onExport: exportExcel,
              ),
              Expanded(
                child: buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapViewPage extends StatefulWidget {
  final LocationData location;

  const MapViewPage({
    super.key,
    required this.location,
  });

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final MapController controller = MapController();

  LatLng? current;
  bool locating = false;

  Future<void> getCurrent() async {
    if (locating) return;

    setState(() => locating = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      if (!mounted) return;

      final point = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() => current = point);
      controller.move(point, 17);
    } finally {
      if (mounted) {
        setState(() => locating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedPosition = LatLng(
      widget.location.latitude,
      widget.location.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: locating ? null : getCurrent,
        icon: locating
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.my_location),
        label: Text(
          locating ? "در حال دریافت..." : "موقعیت من",
        ),
      ),
      body: FlutterMap(
        mapController: controller,
        options: MapOptions(
          initialCenter: savedPosition,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "ir.sabtino.app",
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: savedPosition,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              if (current != null)
                Marker(
                  point: current!,
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 48,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
