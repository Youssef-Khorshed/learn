import 'package:flutter/cupertino.dart';
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
        debugPrint("service denied");

        throw PermissionException(message: "Permission not granted");
      }
    }
    debugPrint("service Performed");
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
    try {
      final x = await location.getLocation();
      debugPrint('action done $x');
      return x;
    } catch (e) {
      return LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
    }
  }
}
