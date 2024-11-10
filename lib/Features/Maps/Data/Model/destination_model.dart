import 'package:json_annotation/json_annotation.dart';
part 'destination_model.g.dart';

@JsonSerializable()
class DestinationResponse {
  List<Routes>? routes;
  String? status;

  DestinationResponse({this.routes, this.status});

  factory DestinationResponse.fromJson(Map<String, dynamic> json) =>
      _$DestinationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DestinationResponseToJson(this);
}

@JsonSerializable()
class Routes {
  Bounds? bounds;
  List<Legs>? legs;
  DistancePolylinePoints? overviewPolyline;
  String? summary;

  Routes({
    this.bounds,
    this.legs,
    this.overviewPolyline,
    this.summary,
  });

  factory Routes.fromJson(Map<String, dynamic> json) => _$RoutesFromJson(json);

  Map<String, dynamic> toJson() => _$RoutesToJson(this);
}

@JsonSerializable()
class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  factory Bounds.fromJson(Map<String, dynamic> json) => _$BoundsFromJson(json);

  Map<String, dynamic> toJson() => _$BoundsToJson(this);
}

@JsonSerializable()
class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  factory Northeast.fromJson(Map<String, dynamic> json) =>
      _$NortheastFromJson(json);

  Map<String, dynamic> toJson() => _$NortheastToJson(this);
}

@JsonSerializable()
class Legs {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Steps>? steps;

  Legs({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
  });

  factory Legs.fromJson(Map<String, dynamic> json) => _$LegsFromJson(json);

  Map<String, dynamic> toJson() => _$LegsToJson(this);
}

@JsonSerializable()
class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) =>
      _$DistanceFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceToJson(this);
}

@JsonSerializable()
class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  DistancePolylinePoints? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Steps(
      {this.distance,
      this.duration,
      this.endLocation,
      this.htmlInstructions,
      this.polyline,
      this.startLocation,
      this.travelMode,
      this.maneuver});

  factory Steps.fromJson(Map<String, dynamic> json) => _$StepsFromJson(json);

  Map<String, dynamic> toJson() => _$StepsToJson(this);
}

@JsonSerializable()
class DistancePolylinePoints {
  String? points;

  DistancePolylinePoints({this.points});

  factory DistancePolylinePoints.fromJson(Map<String, dynamic> json) =>
      _$DistancePolylinePointsFromJson(json);

  Map<String, dynamic> toJson() => _$DistancePolylinePointsToJson(this);
}
