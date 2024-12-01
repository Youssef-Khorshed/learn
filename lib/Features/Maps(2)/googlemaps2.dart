import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Network/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Googlemaps2 extends StatefulWidget {
  const Googlemaps2({super.key});

  @override
  State<Googlemaps2> createState() => _Googlemaps2State();
}

class _Googlemaps2State extends State<Googlemaps2> {
  late CameraPosition initialCameraPosition;

  late LocationService locationService;
  GoogleMapController? googleMapController;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    // Default camera position until location is available
    initialCameraPosition = const CameraPosition(
      zoom: 17,
      target: LatLng(31.187084851056554, 29.928110526889437),
    );

    locationService = LocationService();
    updateMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: false,
      markers: markers,
      zoomControlsEnabled: false,
      onMapCreated: (controller) {
        googleMapController = controller;
      },
      initialCameraPosition: initialCameraPosition,
    );
  }

  // Request location service and permission, then update location
  void updateMyLocation() async {
    // Check if location service is enabled
    await locationService.checkAndrequestLocationService();

    // Request permission
    var hasPermission =
        await locationService.checkAndrequestLocationPermission();

    if (hasPermission) {
      // Listen to location updates
      locationService.updateCameraLocation((locationData) {
        // Update the camera position and marker whenever location changes
        setMyLocationMarker(locationData);
        setMyCameraPosition(locationData);
      });
    } else {
      // Handle permission denial or other errors here
      print('Permission denied or service not enabled.');
    }
  }

  // Update the camera position to the new location
  void setMyCameraPosition(LocationData locationData) {
    if (googleMapController != null) {
      var cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 15,
      );

      setState(() {
        // Update the camera
        googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    } else {
      debugPrint('googleMapController is null');
    }
  }

  // Add or update the marker for the user's current location
  void setMyLocationMarker(LocationData locationData) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('my_location_marker'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
    );

    setState(() {
      // Set markers with the new location, replace existing markers
      markers = {myLocationMarker};
    });
  }
}
