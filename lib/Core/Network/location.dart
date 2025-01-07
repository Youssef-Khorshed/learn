import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<void> checkAndrequestLocationService() async {
    final bool _isServiceEnabled = !await location.serviceEnabled();
    if (!_isServiceEnabled) {
      final isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        throw ServiceException(message: "Service not enabled");
      }
    }
  }

  Future<void> checkAndrequestLocationPermission() async {
    final _hasPermission = await location.hasPermission();
    if (_hasPermission == PermissionStatus.deniedForever) {
      throw PermissionException(message: "Permission not denied forever");
    }
    if (_hasPermission == PermissionStatus.denied) {
      final _hasPermissionAfterRequest = await location.requestPermission();

      if (_hasPermissionAfterRequest != PermissionStatus.granted) {
        throw PermissionException(message: "Permission not granted");
      }
    }
  }

  Future<void> updateCameraLocation(
      void Function(LocationData)? onDatachange) async {
    await checkAndrequestLocationService();
    await checkAndrequestLocationPermission();
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(onDatachange);
  }

  Future<LocationData> getuserLocation() async {
    await checkAndrequestLocationService();
    await checkAndrequestLocationPermission();
    final x = await location.getLocation();
    return x;
  }
}
