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

class PlaceDirectionLoaded extends MapsState {
  final List<Routes>? placeDirections;

  PlaceDirectionLoaded(this.placeDirections);
}

class GetSearchedPlace extends MapsState {
  final Location geometry;

  GetSearchedPlace(this.geometry);
}

class DirectionsLoaded extends MapsState {
  Set<Polyline> polylines;
  DirectionsLoaded(this.polylines);
}
