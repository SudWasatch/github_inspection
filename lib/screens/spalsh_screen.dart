import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:github_inspection/components/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      // ✅ Check if location service is enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showSettingsDialog(
          // ignore: use_build_context_synchronously
          context,
          "Location",
          "location",
        );
        return;
      }

      // ✅ Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSettingsDialog(
            // ignore: use_build_context_synchronously
            context,
            "Location",
            "location",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // ✅ Permanently denied → Show dialog with Open Settings
        showSettingsDialog(
          // ignore: use_build_context_synchronously
          context,
          "Location",
          "location",
        );
        return;
      }
      requestCameraPermission();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> requestCameraPermission() async {
    var cameraStatus = await Permission.camera.request();

    try {
      if (cameraStatus.isGranted) {
        // Camera permission granted. Proceed with camera operations.
      }

      if (cameraStatus.isDenied) {
        showSettingsDialog(
          // ignore: use_build_context_synchronously
          context,
          "Camera",
          "camera",
          // "Permission Denied",
          // "Camera permission was denied. Please allow it to continue.",
        );
        return;
        // Camera permission denied. Handle accordingly (e.g., show a message).
      }

      if (cameraStatus.isPermanentlyDenied) {
        // Camera permission permanently denied.
        // Direct the user to app settings to enable it manually.
        // ✅ Permanently denied → Show dialog with Open Settings
        showSettingsDialog(
          // ignore: use_build_context_synchronously
          context,
          "Camera",
          "camera",
        );
        return;
      }
      // ✅ Permission granted → continue after splash
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushNamed(context, "/ls");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight,
              width: deviceWidth,
              child: Image.asset('assets/pin.png', fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
