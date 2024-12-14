import 'aircraft.dart';
import 'arrival.dart';
import 'departure.dart';
import 'operating.dart';

class Segment {
  String? id;
  int? numberOfStops;
  bool? blacklistedInEu;
  String? carrierCode;
  String? number;
  String? duration;
  Departure? departure;
  Arrival? arrival;
  Aircraft? aircraft;
  Operating? operating;

  Segment({
    this.id,
    this.numberOfStops,
    this.blacklistedInEu,
    this.carrierCode,
    this.number,
    this.duration,
    this.departure,
    this.arrival,
    this.aircraft,
    this.operating,
  });

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        id: json['id'] as String?,
        numberOfStops: json['numberOfStops'] as int?,
        blacklistedInEu: json['blacklistedInEU'] as bool?,
        carrierCode: json['carrierCode'] as String?,
        number: json['number'] as String?,
        duration: json['duration'] as String?,
        departure: json['departure'] == null
            ? null
            : Departure.fromJson(json['departure'] as Map<String, dynamic>),
        arrival: json['arrival'] == null
            ? null
            : Arrival.fromJson(json['arrival'] as Map<String, dynamic>),
        aircraft: json['aircraft'] == null
            ? null
            : Aircraft.fromJson(json['aircraft'] as Map<String, dynamic>),
        operating: json['operating'] == null
            ? null
            : Operating.fromJson(json['operating'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'numberOfStops': numberOfStops,
        'blacklistedInEU': blacklistedInEu,
        'carrierCode': carrierCode,
        'number': number,
        'duration': duration,
        'departure': departure?.toJson(),
        'arrival': arrival?.toJson(),
        'aircraft': aircraft?.toJson(),
        'operating': operating?.toJson(),
      };
}
