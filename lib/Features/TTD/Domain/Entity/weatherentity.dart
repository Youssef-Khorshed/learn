// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String main;
  final String description;
  final String icon;
  final double temp;
  final int pressure;
  final int humidity;
  WeatherEntity({
    required this.cityName,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.pressure,
    required this.humidity,
  });

  @override
  List<Object?> get props => [
        cityName,
        description,
        icon,
        temp,
        pressure,
        humidity,
        main,
      ];
}
