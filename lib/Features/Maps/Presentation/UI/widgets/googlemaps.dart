import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/Logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/UI/widgets/searchScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMaps extends StatefulWidget {
  const MyMaps({Key? key}) : super(key: key);

  @override
  _MyMapsState createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  var progressIndicator = false;
  late List<LatLng> polylinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;
  Set<Polyline> polyLines = {};

  @override
  initState() {
    super.initState();

    getMyCurrentLocation();
  }

  ///First step
  Future<void> getMyCurrentLocation() async {
    final maps = context.read<MapsCubit>();
    maps.orginPosition = await maps.getUserLocation();
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

  /// Second Step
  Widget buildMap() {
    final maps = context.watch<MapsCubit>();

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: maps.markers,
      polylines: polyLines,
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
    return Scaffold(
      body: BlocConsumer<MapsCubit, MapsState>(
        listener: (context, state) {
          if (state is GetSearchedPlace) {
            final x = context.read<MapsCubit>();
            x.updateDestionationCameraPosition();
            x.buildmarkers();
          } else if (state is DirectionsLoaded) {
            setState(() {
              polyLines = state.polylines;
              for (var polyline in polyLines) {
                print(polyline.points);
              }
            });
          }
        },
        builder: (context, state) {
          final maps = context.read<MapsCubit>();

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
