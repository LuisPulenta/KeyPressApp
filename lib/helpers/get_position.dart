import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../components/components.dart';

Future<Position?> getPosition(BuildContext context) async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await customErrorDialog(
          context, 'Aviso', 'El permiso de localización está negado.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    await customErrorDialog(context, 'Aviso',
        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.');

    return null;
  }

  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult != ConnectivityResult.none) {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
  return null;
}
