import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsProvider with ChangeNotifier {
  //--------------------------------------------------------
  StreamSubscription? gpsServiceSubscription;
  bool _isGpsEnabled = false;
  bool _isLocationPermissionGranted = false;
  bool _isPhonePermissionGranted = false;
  bool _isCameraPermissionGranted = false;
  bool _isPushNotificationsGranted = false;
  bool _isReady = false;

  //--------------------------------------------------------
  bool get isAllGranted =>
      isGpsEnabled &&
      isLocationPermissionGranted &&
      isCameraPermissionGranted &&
      _isPushNotificationsGranted &&
      isPhonePermissionGranted;

  bool get isReady => _isReady;

  bool get isGpsEnabled {
    return _isGpsEnabled;
  }

  set isGpsEnabled(bool isGpsEnabled) {
    _isGpsEnabled = isGpsEnabled;
    notifyListeners();
  }

  bool get isPhonePermissionGranted {
    return _isPhonePermissionGranted;
  }

  set isPhonePermissionGranted(bool isPhonePermissionGranted) {
    _isPhonePermissionGranted = isPhonePermissionGranted;
    notifyListeners();
  }

  bool get isCameraPermissionGranted {
    return _isCameraPermissionGranted;
  }

  set isCameraPermissionGranted(bool isCameraPermissionGranted) {
    _isCameraPermissionGranted = isCameraPermissionGranted;
    notifyListeners();
  }

  bool get isLocationPermissionGranted {
    return _isLocationPermissionGranted;
  }

  set isLocationPermissionGranted(bool isLocationPermissionGranted) {
    _isLocationPermissionGranted = isLocationPermissionGranted;
    notifyListeners();
  }

  bool get isPushNotificationsGranted {
    return _isPushNotificationsGranted;
  }

  set isPushNotificationsGranted(bool isPushNotificationsGranted) {
    _isPushNotificationsGranted = _isPushNotificationsGranted;
    notifyListeners();
  }

  //--------------------------------------------------------
  PermissionsProvider() {
    _init();
  }

  //--------------------------------------------------------
  Future<void> close() async {
    gpsServiceSubscription?.cancel();
  }

  //-----------------------------------------------------------------------
  Future<void> _init() async {
    // _isGpsEnabled = await _checkGpsStatus();
    // _isGpsPermissionGranted = await _isPermissionGranted();

    final gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isLocationPermission(),
      _isCameraPermission(),
      _isPhonePermission(),
      _isPushNotificationsPermission(),
    ]);

    _isGpsEnabled = gpsInitStatus[0];
    _isLocationPermissionGranted = gpsInitStatus[1];
    _isCameraPermissionGranted = gpsInitStatus[2];
    _isPhonePermissionGranted = gpsInitStatus[3];
    _isReady = true;

    notifyListeners();
  }

  //-----------------------------------------------------------------------
  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();

    gpsServiceSubscription = Geolocator.getServiceStatusStream().listen((
      event,
    ) {
      final isEnabled = (event.index == 1) ? true : false;
      _isGpsEnabled = isEnabled;
      notifyListeners();
    });

    return isEnable;
  }

  //-----------------------------------------------------------------------
  Future<void> askPermissionsAccess() async {
    final statusLocation = await Permission.location.request();
    final statusPhone = await Permission.phone.request();
    final statusCamera = await Permission.camera.request();
    final statusNotifications = await Permission.notification.request();

    if (statusLocation != PermissionStatus.granted ||
        statusPhone != PermissionStatus.granted ||
        statusCamera != PermissionStatus.granted ||
        statusNotifications != PermissionStatus.granted) {
      openAppSettings();
      notifyListeners();
    } else {
      _isLocationPermissionGranted = true;
      _isPhonePermissionGranted = true;
      _isCameraPermissionGranted = true;
      _isPushNotificationsGranted = true;
      notifyListeners();
    }
  }
}

//------------------------------------------------------------------------
Future<bool> _isLocationPermission() async {
  final isGranted = await Permission.location.isGranted;
  return isGranted;
}

//------------------------------------------------------------------------
Future<bool> _isCameraPermission() async {
  final isGranted = await Permission.camera.isGranted;
  return isGranted;
}

//------------------------------------------------------------------------
Future<bool> _isPhonePermission() async {
  final isGranted = await Permission.phone.isGranted;
  return isGranted;
}

//------------------------------------------------------------------------
Future<bool> _isPushNotificationsPermission() async {
  final isGranted = await Permission.notification.isGranted;
  return isGranted;
}
