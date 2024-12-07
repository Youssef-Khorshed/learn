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
  late LocationService locationService;
  late GoogleMapController googleMapController;
  late CameraPosition initialCameraPosition;
  Set<Marker> markers = {};
  @override
  void initState() {
    initialization();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      markers: markers,
      onMapCreated: (controller) {
        setState(() {
          googleMapController = controller;
          updateUserLoation();
        });
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  void initialization() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 0);
    locationService = LocationService();
  }

  void addmarkers({required LatLng position}) {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: position,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  void updateUserLoation() async {
    try {
      final locationData = await locationService.getuserLocation();
      addmarkers(
          position: LatLng(locationData.latitude!, locationData.longitude!));
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 17),
      ));
    } on ServiceException catch (e) {
      // Handle service exception
      print('Location service error: ${e.toString()}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Location service error: ${e.message}')),
      // );
    } on PermissionException catch (e) {
      // Handle permission exception
      print('Permission error: ${e.toString()}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Permission error: ${e.message}')),
      // );
    }
  }
}
