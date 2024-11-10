class PlacedetailsResponse {
  Result? result;
  String? status;

  PlacedetailsResponse({this.result, this.status});

  PlacedetailsResponse.fromJson(dynamic json) {
    if (json['result'] != null) {
      result = Result.fromJson(json['result']);
    }

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Result {
  Geometry? geometry;

  Result({this.geometry});

  Result.fromJson(dynamic json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (viewport != null) {
      data['viewport'] = viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
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

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(dynamic json) {
    northeast =
        json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
    southwest =
        json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
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
