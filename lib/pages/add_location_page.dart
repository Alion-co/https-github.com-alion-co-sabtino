// lib/pages/add_location_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/location_model.dart';
import '../services/database_service.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_field.dart';
import '../widgets/map_card.dart';
import '../widgets/page_background.dart';

import 'about_page.dart';
import 'saved_info_page.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final MapController mapController = MapController();

  LatLng selectedPosition = const LatLng(
    35.6892,
    51.3890,
  );

  bool locating = false;
  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    if (saving) return;

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("لطفاً نام را وارد کنید"),
        ),
      );
      return;
    }

    setState(() => saving = true);

    try {
      await DatabaseService.insertLocation(
        LocationData(
          name: nameController.text.trim(),
          type: typeController.text.trim(),
          address: addressController.text.trim(),
          phone: phoneController.text.trim(),
          latitude: selectedPosition.latitude,
          longitude: selectedPosition.longitude,
        ),
      );

      nameController.clear();
      typeController.clear();
      addressController.clear();
      phoneController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اطلاعات ثبت شد"),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("خطا در ثبت اطلاعات"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => saving = false);
      }
    }
  }

  Future<bool> _showLocationPermissionInfo() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("دسترسی موقعیت مکانی"),
          content: const Text(
            "ثبتینو فقط برای ثبت موقعیت دقیق این رکورد به دسترسی مکان نیاز دارد. "
                "دسترسی فقط زمانی درخواست می‌شود که روی «موقعیت فعلی من» بزنید.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("فعلاً نه"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("ادامه"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _showLocationServiceDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("GPS خاموش است"),
          content: const Text(
            "برای دریافت موقعیت فعلی، سرویس موقعیت مکانی گوشی را روشن کنید.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("انصراف"),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              child: const Text("باز کردن تنظیمات"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPermissionSettingsDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("دسترسی موقعیت بسته است"),
          content: const Text(
            "دسترسی موقعیت برای ثبتینو از تنظیمات گوشی بسته شده است. "
                "برای استفاده از موقعیت فعلی، آن را از بخش Permissions فعال کنید.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("انصراف"),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openAppSettings();
              },
              child: const Text("باز کردن تنظیمات"),
            ),
          ],
        );
      },
    );
  }

  Future<void> getCurrentLocation() async {
    if (locating) return;

    setState(() => locating = true);

    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await _showLocationServiceDialog();
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        final continueRequest =
        await _showLocationPermissionInfo();

        if (!continueRequest) return;

        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        await _showPermissionSettingsDialog();
        return;
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "بدون دسترسی موقعیت، امکان دریافت موقعیت فعلی وجود ندارد",
            ),
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final point = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        selectedPosition = point;
      });

      mapController.move(
        point,
        17,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("دریافت موقعیت انجام نشد"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => locating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ثبتینو"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: PageBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GlassField(
                title: "نام",
                icon: Icons.person_outline,
                controller: nameController,
              ),
              GlassField(
                title: "نوع",
                icon: Icons.category_outlined,
                controller: typeController,
              ),
              GlassField(
                title: "آدرس",
                icon: Icons.home_outlined,
                controller: addressController,
              ),
              GlassField(
                title: "شماره تماس",
                icon: Icons.phone_outlined,
                controller: phoneController,
                phone: true,
              ),
              MapCard(
                controller: mapController,
                position: selectedPosition,
                onTap: (point) {
                  setState(() {
                    selectedPosition = point;
                  });
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                title: locating
                    ? "در حال دریافت موقعیت..."
                    : "موقعیت فعلی من",
                icon: Icons.my_location,
                onPressed: getCurrentLocation,
              ),
              const SizedBox(height: 10),
              AppButton(
                title: saving
                    ? "در حال ثبت..."
                    : "ثبت اطلاعات",
                icon: Icons.add_location_alt_outlined,
                primary: true,
                onPressed: saveData,
              ),
              const SizedBox(height: 10),
              AppButton(
                title: "اطلاعات ثبت شده",
                icon: Icons.list_alt,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SavedInfoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
