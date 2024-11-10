import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/Logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/UI/widgets/searchScreen.dart';
import 'package:flutter_complete_project/Features/Maps/getUserLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMaps extends StatefulWidget {
  const MyMaps({Key? key}) : super(key: key);

  @override
  _MyMapsState createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  // void buildCameraNewPosition() {
  //   goToSearchedForPlace = CameraPosition(
  //     bearing: 0.0,
  //     tilt: 0.0,
  //     target: LatLng(
  //       selectedPlace.result.geometry.location.lat,
  //       selectedPlace.result.geometry.location.lng,
  //     ),
  //     zoom: 13,
  //   );
  // }

  // these variables for getDirections
  // PlaceDirections? placeDirections;
  var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  @override
  initState() {
    super.initState();

    getMyCurrentLocation();
  }

  Future<void> getMyCurrentLocation() async {
    final maps = context.read<MapsCubit>();
    maps.orginPosition = await getUserLocation();
    // ignore: use_build_context_synchronously
    if (maps.orginPosition != null) {
      maps.originCameraPosition = CameraPosition(
        bearing: 0.0,
        target:
            LatLng(maps.orginPosition!.latitude, maps.orginPosition!.longitude),
        tilt: 0.0,
        zoom: 17,
      );
      setState(() {
        maps.orginPosition;
      });
    }
  }

  Widget buildMap() {
    final maps = context.read<MapsCubit>();

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: maps.markers,
      initialCameraPosition: maps.originCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        maps.mapController.complete(controller);
      },
    );
  }

  Future<void> _goToMyCurrentLocation() async {
    final maps = context.read<MapsCubit>();
    final GoogleMapController controller = await maps.mapController.future;
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(maps.originCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    final maps = context.read<MapsCubit>();
    return Scaffold(
      body: BlocConsumer<MapsCubit, MapsState>(
        listener: (context, state) {
          if (state is GetSearchedPlace) {
            final x = context.read<MapsCubit>();
            x.updateDestionationCameraPosition();
            x.buildmarkers();
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              maps.orginPosition != null
                  ? buildMap()
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
              SearchScreen(),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _goToMyCurrentLocation,
          child: const Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }
}
