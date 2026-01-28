import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:github_inspection/providers/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}

class ALLInspectionProvider extends ChangeNotifier {
  Map<String, dynamic> _allinspections = {};
  String _mobileNumber = '';

  Map<String, dynamic> get allinspections => _allinspections;
  String get mobileNumber => _mobileNumber;

  void setInspections(Map<String, dynamic> allinspections) {
    _allinspections = allinspections;
    notifyListeners();
  }

  void setMobileNumber(String mobileNumber) {
    _mobileNumber = mobileNumber;
    notifyListeners();
  }
}

class InspectionProvider extends ChangeNotifier {
  Map<String, dynamic> _inspection = {};

  Map<String, dynamic>get inspection => _inspection;

  void setInspection(Map<String, dynamic> inspection) {
    _inspection = inspection;
    notifyListeners();
  }
}

class IpProvider extends ChangeNotifier {
  String _ipAddress = '';

  String get ipAddress => _ipAddress;

  void setIpAddress(String ipAddress) {
    _ipAddress = ipAddress;
    notifyListeners();
  }
}

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  ConnectivityProvider() {
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus = result;
    notifyListeners();
  }

  bool get hasInternetConnection {
    return !_connectionStatus.contains(ConnectivityResult.none);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

class LatProvider extends ChangeNotifier {
  double _lat = 0;

  double get lat => _lat;

  void setLatitude(double lat) {
    _lat = lat;
    notifyListeners();
  }
}

class LongProvider extends ChangeNotifier {
  double _long = 0;

  double get long => _long;

  void setLongitude(double long) {
    _long = long;
    notifyListeners();
  }
}

class LocationProvider extends ChangeNotifier {
  LocationProvider({required this.latProvider, required this.longProvider}) {
    _startListeningToLocation();
  }

  final LatProvider latProvider;
  final LongProvider longProvider;

  StreamSubscription<Position>? _positionStreamSubscription;
  String _value = '';

  String get value => _value;

  void setLocationValue(String val) {
    _value = val;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
  void _startListeningToLocation() {
    double targetLatitude = latProvider.lat;
    double targetLongitude = longProvider.long;

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            try {
              double distance = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                targetLatitude,
                targetLongitude,
              );

              if (distance <= 200) {
                setLocationValue("Yes");
              } else {
                setLocationValue("No");
              }
            } on PlatformException catch (e) {
              developer.log('Couldn\'t check location', error: e);
              return;
            }
          },
        );
  }
}

