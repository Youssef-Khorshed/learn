import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Network/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Googlemaps2 extends StatefulWidget {
  const Googlemaps2({super.key});

  @override
  State<Googlemaps2> createState() => _Googlemaps2State();
}

class _Googlemaps2State extends State<Googlemaps2> {
  late LocationService _locationService;
  late GoogleMapController googleMapController;
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    initailization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        googleMapController = controller;
        updateUserLoation();
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  initailization() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 0);
    _locationService = LocationService();
  }

  void updateUserLoation() async {
    try {
      final locationData = await _locationService.getuserLocation();
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 17),
      ));
    } on ServiceException catch (e) {
      print('aaffafffafa');
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.message)));
    } on PermissionException catch (e) {
      print('kgl;kg;lsfkl;k;lk');
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
