import 'package:geolocator/geolocator.dart';

Future<Position?> getUserLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Request permission
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever; handle accordingly
    await getUserLocation();
  } else if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    return await Geolocator.getCurrentPosition();
    // Permission granted
    // getuserLocation(mapController, currentPosition, locationcontroller);
  }
  return null;
}
