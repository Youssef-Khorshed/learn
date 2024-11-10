class DestinationResponse {
  List<GeocodedWaypoints>? geocodedWaypoints;
  List<Routes>? routes;
  String? status;

  DestinationResponse({this.geocodedWaypoints, this.routes, this.status});

  DestinationResponse.fromJson(dynamic json) {
    if (json['geocoded_waypoints'] != null) {
      geocodedWaypoints = <GeocodedWaypoints>[];
      json['geocoded_waypoints'].forEach((v) {
        geocodedWaypoints!.add(GeocodedWaypoints.fromJson(v));
      });
    }
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(Routes.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geocodedWaypoints != null) {
      data['geocoded_waypoints'] =
          this.geocodedWaypoints!.map((v) => v.toJson()).toList();
    }
    if (this.routes != null) {
      data['routes'] = routes!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class GeocodedWaypoints {
  String? geocoderStatus;
  String? placeId;
  List<String>? types;

  GeocodedWaypoints({this.geocoderStatus, this.placeId, this.types});

  GeocodedWaypoints.fromJson(dynamic json) {
    geocoderStatus = json['geocoder_status'];
    placeId = json['place_id'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geocoder_status'] = geocoderStatus;
    data['place_id'] = placeId;
    data['types'] = types;
    return data;
  }
}

class Routes {
  Bounds? bounds;
  String? copyrights;
  List<Legs>? legs;
  Polyline? overviewPolyline;
  String? summary;
  List<Null>? warnings;
  List<Null>? waypointOrder;

  Routes(
      {this.bounds,
      this.copyrights,
      this.legs,
      this.overviewPolyline,
      this.summary,
      this.warnings,
      this.waypointOrder});

  Routes.fromJson(Map<String, dynamic> json) {
    bounds =
        json['bounds'] != null ? new Bounds.fromJson(json['bounds']) : null;
    copyrights = json['copyrights'];
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add(new Legs.fromJson(v));
      });
    }
    overviewPolyline = json['overview_polyline'] != null
        ? new Polyline.fromJson(json['overview_polyline'])
        : null;
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bounds != null) {
      data['bounds'] = bounds!.toJson();
    }
    data['copyrights'] = copyrights;
    if (legs != null) {
      data['legs'] = legs!.map((v) => v.toJson()).toList();
    }
    if (overviewPolyline != null) {
      data['overview_polyline'] = overviewPolyline!.toJson();
    }
    data['summary'] = summary;

    return data;
  }
}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  Bounds.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? Northeast.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? Northeast.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (northeast != null) {
      data['northeast'] = northeast!.toJson();
    }
    if (southwest != null) {
      data['southwest'] = southwest!.toJson();
    }
    return data;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
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
  List<void>? trafficSpeedEntry;
  List<void>? viaWaypoint;

  Legs(
      {this.distance,
      this.duration,
      this.endAddress,
      this.endLocation,
      this.startAddress,
      this.startLocation,
      this.steps,
      this.trafficSpeedEntry,
      this.viaWaypoint});

  Legs.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ? new Northeast.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    startLocation = json['start_location'] != null
        ? new Northeast.fromJson(json['start_location'])
        : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    data['end_address'] = this.endAddress;
    if (this.endLocation != null) {
      data['end_location'] = this.endLocation!.toJson();
    }
    data['start_address'] = this.startAddress;
    if (this.startLocation != null) {
      data['start_location'] = this.startLocation!.toJson();
    }
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polyline? polyline;
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

  Steps.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
    endLocation = json['end_location'] != null
        ? new Northeast.fromJson(json['end_location'])
        : null;
    htmlInstructions = json['html_instructions'];
    polyline = json['polyline'] != null
        ? new Polyline.fromJson(json['polyline'])
        : null;
    startLocation = json['start_location'] != null
        ? new Northeast.fromJson(json['start_location'])
        : null;
    travelMode = json['travel_mode'];
    maneuver = json['maneuver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    if (this.endLocation != null) {
      data['end_location'] = this.endLocation!.toJson();
    }
    data['html_instructions'] = this.htmlInstructions;
    if (this.polyline != null) {
      data['polyline'] = this.polyline!.toJson();
    }
    if (this.startLocation != null) {
      data['start_location'] = this.startLocation!.toJson();
    }
    data['travel_mode'] = this.travelMode;
    data['maneuver'] = this.maneuver;
    return data;
  }
}

class Polyline {
  String? points;

  Polyline({this.points});

  Polyline.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    return data;
  }
}
