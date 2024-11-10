part of 'maps_cubit.dart';

abstract class MapsState {}

class MapsInitial extends MapsState {}

class UpdateDestinationCameraPosition extends MapsState {}

class UpdateMarkers extends MapsState {}

class PlacesLoading extends MapsState {}

class PlacesLoaded extends MapsState {
  final List<Predictions> places;

  PlacesLoaded(this.places);
}

class PlacesFailLoaded extends MapsState {
  String message;
  PlacesFailLoaded({required this.message});
}

class GetSearchedPlace extends MapsState {
  final Location geometry;

  GetSearchedPlace(this.geometry);
}

class DirectionsLoaded extends MapsState {
//  final PlaceDirections placeDirections;

  //DirectionsLoaded(this.placeDirections);
}
