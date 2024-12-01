import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/usecase/getwetherusecase.dart';
import 'package:rxdart/rxdart.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  Getwetherusecase getwetherusecase;
  WeatherBloc({required this.getwetherusecase}) : super(WeatherInitial()) {
    on<GetWeather>(
      _getWeather,
      transformer: _debouncer,
    );
  }

  FutureOr<void> _getWeather(
      GetWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    final data = await getwetherusecase.execute(event.city);
    data.fold((l) => emit(WeatherFail(message: l.message)),
        (r) => emit(WeatherSuccess(weatherEntity: r)));
  }

  Stream<GetWeather> _debouncer(
          Stream<GetWeather> events, EventMapper<GetWeather> mapper) =>
      events.debounceTime(Duration(milliseconds: 500)).asyncExpand(mapper);
}
