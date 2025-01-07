import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Network/location.dart';
import 'package:flutter_complete_project/Features/Maps2/map2apiservices.dart';
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
  Set<Polyline> polylines = {};

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 0);
    super.initState();
  }

  void x() async {
    final x = await MyMapServices.fetchSuggestions('alexnadria-lib');
    x.fold((l) => print(l.message), (r) => print(r));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: true,
          markers: markers,
          onMapCreated: (controller) {
            googleMapController = controller;
            updateUserLoation();
          },
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
            top: 30,
            left: 30,
            child: TextButton(
              onPressed: () {
                setState(() {
                  updateUserLoation();
                });
              },
              child: Text('search'),
            ))
      ],
    );
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
      // Get the user's current location
      locationService = LocationService();
      final locationData = await locationService.getuserLocation();
      print('loaction $locationData');
      // Update the map camera position to show the user's location
      final cameraPosition = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 20);
      print(locationData);
      addmarkers(
          position: LatLng(locationData.latitude!, locationData.longitude!));
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // If the location service is not enabled or the permission is not granted
      // print an error message
    } on ServiceException catch (e) {
      // Handle service exception
      print('Location service error: ${e.toString()}');
    } on PermissionException catch (e) {
      // Handle permission exception
      print('Permission error: ${e.toString()}');
    }
  }
}
