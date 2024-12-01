part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherSuccess extends WeatherState {
  final WeatherEntity weatherEntity;

  const WeatherSuccess({required this.weatherEntity});
}

final class WeatherFail extends WeatherState {
  final String message;

  const WeatherFail({required this.message});
}
