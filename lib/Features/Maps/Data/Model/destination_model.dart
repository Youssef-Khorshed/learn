class DestinationResponse {
  List<Routes>? routes;
  String? status;

  DestinationResponse({this.routes, this.status});

  // Manually written fromJson method
  factory DestinationResponse.fromJson(Map<String, dynamic> json) {
    return DestinationResponse(
      routes: (json['routes'] as List?)
          ?.map((item) => Routes.fromJson(item))
          .toList(),
      status: json['status'] as String?,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'routes': routes?.map((item) => item.toJson()).toList(),
      'status': status,
    };
  }
}

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

  // Manually written fromJson method
  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      bounds: json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null,
      legs:
          (json['legs'] as List?)?.map((item) => Legs.fromJson(item)).toList(),
      overviewPolyline: json['overview_polyline'] != null
          ? DistancePolylinePoints.fromJson(json['overview_polyline'])
          : null,
      summary: json['summary'] as String?,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'bounds': bounds?.toJson(),
      'legs': legs?.map((item) => item.toJson()).toList(),
      'overview_polyline': overviewPolyline?.toJson(),
      'summary': summary,
    };
  }
}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  // Manually written fromJson method
  factory Bounds.fromJson(Map<String, dynamic> json) {
    return Bounds(
      northeast: json['northeast'] != null
          ? Northeast.fromJson(json['northeast'])
          : null,
      southwest: json['southwest'] != null
          ? Northeast.fromJson(json['southwest'])
          : null,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'northeast': northeast?.toJson(),
      'southwest': southwest?.toJson(),
    };
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  // Manually written fromJson method
  factory Northeast.fromJson(Map<String, dynamic> json) {
    return Northeast(
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

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

  // Manually written fromJson method
  factory Legs.fromJson(Map<String, dynamic> json) {
    return Legs(
      distance:
          json['distance'] != null ? Distance.fromJson(json['distance']) : null,
      duration:
          json['duration'] != null ? Distance.fromJson(json['duration']) : null,
      endAddress: json['end_address'] as String?,
      endLocation: json['end_location'] != null
          ? Northeast.fromJson(json['end_location'])
          : null,
      startAddress: json['start_address'] as String?,
      startLocation: json['start_location'] != null
          ? Northeast.fromJson(json['start_location'])
          : null,
      steps: (json['steps'] as List?)
          ?.map((item) => Steps.fromJson(item))
          .toList(),
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'distance': distance?.toJson(),
      'duration': duration?.toJson(),
      'end_address': endAddress,
      'end_location': endLocation?.toJson(),
      'start_address': startAddress,
      'start_location': startLocation?.toJson(),
      'steps': steps?.map((item) => item.toJson()).toList(),
    };
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  // Manually written fromJson method
  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'] as String?,
      value: json['value'] as int?,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}

class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  DistancePolylinePoints? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Steps({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.polyline,
    this.startLocation,
    this.travelMode,
    this.maneuver,
  });

  // Manually written fromJson method
  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      distance:
          json['distance'] != null ? Distance.fromJson(json['distance']) : null,
      duration:
          json['duration'] != null ? Distance.fromJson(json['duration']) : null,
      endLocation: json['end_location'] != null
          ? Northeast.fromJson(json['end_location'])
          : null,
      htmlInstructions: json['html_instructions'] as String?,
      polyline: json['polyline'] != null
          ? DistancePolylinePoints.fromJson(json['polyline'])
          : null,
      startLocation: json['start_location'] != null
          ? Northeast.fromJson(json['start_location'])
          : null,
      travelMode: json['travel_mode'] as String?,
      maneuver: json['maneuver'] as String?,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'distance': distance?.toJson(),
      'duration': duration?.toJson(),
      'end_location': endLocation?.toJson(),
      'html_instructions': htmlInstructions,
      'polyline': polyline?.toJson(),
      'start_location': startLocation?.toJson(),
      'travel_mode': travelMode,
      'maneuver': maneuver,
    };
  }
}

class DistancePolylinePoints {
  String? points;

  DistancePolylinePoints({this.points});

  // Manually written fromJson method
  factory DistancePolylinePoints.fromJson(Map<String, dynamic> json) {
    return DistancePolylinePoints(
      points: json['points'] as String?,
    );
  }

  // Manually written toJson method
  Map<String, dynamic> toJson() {
    return {
      'points': points,
    };
  }
}
