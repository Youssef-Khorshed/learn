// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DestinationResponse _$DestinationResponseFromJson(Map<String, dynamic> json) =>
    DestinationResponse(
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => Routes.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$DestinationResponseToJson(
        DestinationResponse instance) =>
    <String, dynamic>{
      'routes': instance.routes,
      'status': instance.status,
    };

Routes _$RoutesFromJson(Map<String, dynamic> json) => Routes(
      bounds: json['bounds'] == null
          ? null
          : Bounds.fromJson(json['bounds'] as Map<String, dynamic>),
      legs: (json['legs'] as List<dynamic>?)
          ?.map((e) => Legs.fromJson(e as Map<String, dynamic>))
          .toList(),
      overviewPolyline: json['overviewPolyline'] == null
          ? null
          : DistancePolylinePoints.fromJson(
              json['overviewPolyline'] as Map<String, dynamic>),
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$RoutesToJson(Routes instance) => <String, dynamic>{
      'bounds': instance.bounds,
      'legs': instance.legs,
      'overviewPolyline': instance.overviewPolyline,
      'summary': instance.summary,
    };

Bounds _$BoundsFromJson(Map<String, dynamic> json) => Bounds(
      northeast: json['northeast'] == null
          ? null
          : Northeast.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest: json['southwest'] == null
          ? null
          : Northeast.fromJson(json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BoundsToJson(Bounds instance) => <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

Northeast _$NortheastFromJson(Map<String, dynamic> json) => Northeast(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NortheastToJson(Northeast instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Legs _$LegsFromJson(Map<String, dynamic> json) => Legs(
      distance: json['distance'] == null
          ? null
          : Distance.fromJson(json['distance'] as Map<String, dynamic>),
      duration: json['duration'] == null
          ? null
          : Distance.fromJson(json['duration'] as Map<String, dynamic>),
      endAddress: json['endAddress'] as String?,
      endLocation: json['endLocation'] == null
          ? null
          : Northeast.fromJson(json['endLocation'] as Map<String, dynamic>),
      startAddress: json['startAddress'] as String?,
      startLocation: json['startLocation'] == null
          ? null
          : Northeast.fromJson(json['startLocation'] as Map<String, dynamic>),
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => Steps.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LegsToJson(Legs instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'endAddress': instance.endAddress,
      'endLocation': instance.endLocation,
      'startAddress': instance.startAddress,
      'startLocation': instance.startLocation,
      'steps': instance.steps,
    };

Distance _$DistanceFromJson(Map<String, dynamic> json) => Distance(
      text: json['text'] as String?,
      value: (json['value'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DistanceToJson(Distance instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

Steps _$StepsFromJson(Map<String, dynamic> json) => Steps(
      distance: json['distance'] == null
          ? null
          : Distance.fromJson(json['distance'] as Map<String, dynamic>),
      duration: json['duration'] == null
          ? null
          : Distance.fromJson(json['duration'] as Map<String, dynamic>),
      endLocation: json['endLocation'] == null
          ? null
          : Northeast.fromJson(json['endLocation'] as Map<String, dynamic>),
      htmlInstructions: json['htmlInstructions'] as String?,
      polyline: json['polyline'] == null
          ? null
          : DistancePolylinePoints.fromJson(
              json['polyline'] as Map<String, dynamic>),
      startLocation: json['startLocation'] == null
          ? null
          : Northeast.fromJson(json['startLocation'] as Map<String, dynamic>),
      travelMode: json['travelMode'] as String?,
      maneuver: json['maneuver'] as String?,
    );

Map<String, dynamic> _$StepsToJson(Steps instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'endLocation': instance.endLocation,
      'htmlInstructions': instance.htmlInstructions,
      'polyline': instance.polyline,
      'startLocation': instance.startLocation,
      'travelMode': instance.travelMode,
      'maneuver': instance.maneuver,
    };

DistancePolylinePoints _$DistancePolylinePointsFromJson(
        Map<String, dynamic> json) =>
    DistancePolylinePoints(
      points: json['points'] as String?,
    );

Map<String, dynamic> _$DistancePolylinePointsToJson(
        DistancePolylinePoints instance) =>
    <String, dynamic>{
      'points': instance.points,
    };
