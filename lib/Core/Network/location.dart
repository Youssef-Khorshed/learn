import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  Future<bool> checkAndrequestLocationService() async {
    debugPrint("service Performed");
    final bool _isServiceEnabled = !await location.serviceEnabled();
    if (!_isServiceEnabled) {
      final _isServiceEnabledAfterRequest = await location.requestService();
      return _isServiceEnabledAfterRequest;
    }
    return true;
  }

  Future<bool> checkAndrequestLocationPermission() async {
    final _hasPermission = await location.hasPermission();
    if (_hasPermission == PermissionStatus.deniedForever) {
      return false;
    }
    if (_hasPermission == PermissionStatus.denied) {
      final _hasPermissionAfterRequest = await location.requestPermission();
      debugPrint("Permission Performed");

      return _hasPermissionAfterRequest == PermissionStatus.granted;
    }
    debugPrint("Permission passed");

    return true;
  }

  void updateCameraLocation(void Function(LocationData)? onDatachange) {
    // location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen(onDatachange);
    debugPrint("updateCameraLocation Performed");
  }
}
