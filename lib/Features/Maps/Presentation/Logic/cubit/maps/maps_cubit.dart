import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Strings/strings.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/PlaceDetails.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/destination_model.dart';
import 'package:flutter_complete_project/Features/Maps/Data/RepoImplementation/mapRepoImplementation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepoimplementation mapsRepository;
  // for map intialization
  final Completer<GoogleMapController> mapController = Completer();

  // for origin & destination
  late Marker orignMarker;
  late Marker destinationMarker;
  late CameraPosition originCameraPosition;
  late CameraPosition destinationCameraPosition;
  Position? orginPosition;

  late Location destinationostion;
  late String destinationInfo;

  // these variables for getPlaceLocation
  Set<Marker> markers = {};
  late Predictions placeSuggestion;
  List<Predictions> predictions = [];

  MapsCubit(this.mapsRepository) : super(MapsInitial());

  Future<Position?> getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever; handle accordingly
      await getUserLocation();
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }

  Future<void> emitPlaceSuggestions(
      {required String searchQuery, required String sessionToken}) async {
    emit(PlacesLoading());

    Timer(const Duration(seconds: 2), () async {
      emit(PlacesLoading());
      predictions.clear();
      final response = await mapsRepository.fetchSuggestions(
          searchQuery: searchQuery, sessionToken: sessionToken);
      response
          .fold((onError) => emit(PlacesFailLoaded(message: onError.message)),
              (onSuccess) {
        predictions = onSuccess.predictions!;
        emit(PlacesLoaded(predictions));
      });
    });
  }

  Future<void> emitPlaceLocation(String placeId, String sessionToken) async {
    emit(PlacesLoading());
    final response = await mapsRepository.getPlaceLocation(
        placeId: placeId, sessionToken: sessionToken);
    response.fold((onError) {}, (onSuccess) {
      destinationostion = onSuccess.result!.geometry!.location!;
      emit(GetSearchedPlace(onSuccess.result!.geometry!.location!));
    });
  }

  Future<void> emitPlaceDirections(LatLng origin, LatLng destination) async {
    final res = await mapsRepository.getDirections(origin, destination);
    Set<Polyline> polyLines = {};
    res.fold((onError) {}, (onSuccess) async {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: StringManager.apiKey,
        request: PolylineRequest(
          origin:
              PointLatLng(orginPosition!.latitude, orginPosition!.longitude),
          destination:
              PointLatLng(destinationostion.lat!, destinationostion.lng!),
          mode: TravelMode.driving,
        ),
      );
      polyLines.add(Polyline(
        polylineId: const PolylineId('route'),
        points:
            result.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      ));
      debugPrint(LatLng(orginPosition!.latitude, orginPosition!.longitude)
              .toString() +
          ' Stirng ' +
          LatLng(destinationostion.lat!, destinationostion.lng!).toString());
      emit(DirectionsLoaded(polyLines));
    });
  }

  void updateDestionationCameraPosition() async {
    destinationCameraPosition = CameraPosition(
      bearing: 0.0,
      target: LatLng(destinationostion.lat!, destinationostion.lng!),
      tilt: 0.0,
      zoom: 17,
    );
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(destinationCameraPosition));

    emit(UpdateDestinationCameraPosition());
  }

  void buildmarkers() {
    markers.add(Marker(
        markerId: const MarkerId('origin'),
        position: LatLng(orginPosition!.latitude, orginPosition!.longitude),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));

    markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(destinationostion.lat!, destinationostion.lng!),
        infoWindow: InfoWindow(title: destinationInfo),
        onTap: () async {
          await emitPlaceDirections(
            LatLng(orginPosition!.latitude, orginPosition!.longitude),
            LatLng(destinationostion.lat!, destinationostion.lng!),
          );
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    emit(UpdateMarkers());
  }
}
