import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';

import 'helpers.dart';

Future<Position?> getPosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showMyDialog('Aviso', 'El permiso de localización está negado.', 'Ok');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    showMyDialog(
        'Aviso',
        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.',
        'Ok');
    return null;
  }

  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult != ConnectivityResult.none) {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
  return null;
}
