import 'segment.dart';

class Itinerary {
  String? duration;
  List<Segment>? segments;

  Itinerary({this.duration, this.segments});

  factory Itinerary.fromJson(Map<String, dynamic> json) => Itinerary(
        duration: json['duration'] as String?,
        segments: (json['segments'] as List<dynamic>?)
            ?.map((e) => Segment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'segments': segments?.map((e) => e.toJson()).toList(),
      };
}
