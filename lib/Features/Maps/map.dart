// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_complete_project/Features/Maps/dircectionAPI.dart';
// import 'package:flutter_complete_project/Features/Maps/getUserLocation.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';

// class MapScreen extends HookWidget {
//   LatLng destination =
//       LatLng(37.8026661408347, -122.40586511272603); // Example destination

//   @override
//   Widget build(BuildContext context) {
//     final mapController = useState<GoogleMapController?>(null);
//     final locationController = useState<Location>(Location());
//     ValueNotifier<Position?> currentPosition = useState<Position?>(null);
//     late ValueNotifier<Set<Marker>> markers = useState<Set<Marker>>({});
//     ValueNotifier<Marker> lastMarker = useState(Marker(
//       markerId: MarkerId('Destination'),
//       infoWindow: InfoWindow(title: 'destination'),
//       icon: BitmapDescriptor.defaultMarker,
//       position: destination,
//     ));
//     // final polylines = useState<Set<Polyline>>({});
//     // final positionStream = useState<StreamSubscription<Position>?>(null);
//     // final apiService = ApiService(
//     //     "AIzaSyD0wUQ43jOKDFyyh7ILEE7HzImVAOjVKYA"); // Add your API key here

//     useEffect(() {
//       // checkPermissions(mapController, currentPosition, locationController);
//       markers.value = {
//         Marker(
//           markerId: MarkerId('currentLocation'),
//           infoWindow: InfoWindow(title: 'Your Location'),
//           icon: BitmapDescriptor.defaultMarker,
//           position: currentPosition.value == null
//               ? LatLng(0, 0)
//               : LatLng(currentPosition.value!.latitude,
//                   currentPosition.value!.longitude),
//         )
//         //
//         ,
//         lastMarker.value,
//       };
//       // Future<void> updateRoute(ApiService apiService, Position position) async {
//       //   final routePoints = await apiService.getRoute(
//       //     LatLng(position.latitude, position.longitude),
//       //     destination,
//       //   );
//       //   polylines.value = {
//       //     Polyline(
//       //       polylineId: PolylineId('route'),
//       //       points: routePoints,
//       //       color: Colors.blue,
//       //       width: 5,
//       //     ),
//       //   };
//       // }

//       // positionStream.value =
//       //     Geolocator.getPositionStream().listen((Position position) {
//       //   if (position != null) {
//       //     currentPosition.value = position;
//       //     markers.value = {
//       //       Marker(
//       //         markerId: MarkerId('currentLocation'),
//       //         position: LatLng(position.latitude, position.longitude),
//       //         infoWindow: InfoWindow(title: 'Your Location'),
//       //       ),
//       //       Marker(
//       //         markerId: MarkerId('destination'),
//       //         position: destination,
//       //         infoWindow: InfoWindow(title: 'Destination'),
//       //       ),
//       //     };

//       //     mapController.value?.animateCamera(CameraUpdate.newLatLng(
//       //       LatLng(position.latitude, position.longitude),
//       //     ));

//       //     // Fetch and update route
//       //     updateRoute(apiService, position);
//       //   }
//       // });

//       return; //=> positionStream.value?.cancel(); // Clean up
//     }, [
//       currentPosition.value,
//       mapController.value,
//       locationController.value,
//       markers.value
//     ]);

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           destination =
//               LatLng(destination.latitude + 0.01, destination.longitude);
//           lastMarker.value = Marker(
//             markerId: MarkerId('destination'),
//             infoWindow: InfoWindow(title: 'destination'),
//             icon: BitmapDescriptor.defaultMarker,
//             position: destination,
//           );
//           mapController.value?.animateCamera(CameraUpdate.newLatLng(
//             LatLng(destination.latitude, destination.longitude),
//           ));
//         },
//       ),
//       appBar: AppBar(title: Text('Live Tracking')),
//       body: currentPosition.value == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController.value = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: destination, // Default to Khorshed
//                 zoom: 14,
//               ),
//               markers: markers.value,
//               //  polylines: polylines.value,
//             ),
//     );
//   }
// }
