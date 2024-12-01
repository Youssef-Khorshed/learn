import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_complete_project/Features/TTD/Presentation/logic/bloc/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/testheplers.mocks.dart';

void main() {
  late MockGetwetherusecase getwetherusecase;
  late WeatherBloc weatherBloc;
  setUp(() {
    getwetherusecase = MockGetwetherusecase();
    weatherBloc = WeatherBloc(getwetherusecase: getwetherusecase);
  });

  final testWeatherEntity = WeatherEntity(
      temp: 30,
      description: 'sunny',
      icon: '01d',
      main: 'Clear',
      pressure: 1000,
      humidity: 50,
      cityName: 'Cairo');

  group('Test Weather Bloc', () {
    test('Initial state should be WeatherInitial', () {
      expect(weatherBloc.state, WeatherInitial());
    });

    blocTest("test weather get success bloc",
        build: () {
          when(getwetherusecase.execute('Cairo')).thenAnswer((_) async {
            return Right(testWeatherEntity);
          });
          return weatherBloc;
        },
        act: (bloc) => bloc.add(GetWeather('Cairo')),
        wait: Duration(milliseconds: 500),
        expect: () => [
              WeatherLoading(),
              WeatherSuccess(weatherEntity: testWeatherEntity)
            ]);

    blocTest("test weather get fail bloc",
        build: () {
          when(getwetherusecase.execute('Cairo')).thenAnswer((_) async {
            return Left(ServerFailure(message: 'error'));
          });
          return weatherBloc;
        },
        act: (bloc) => bloc.add(GetWeather('Cairo')),
        wait: Duration(milliseconds: 500),
        expect: () => [WeatherLoading(), WeatherFail(message: 'error')]);
  });
}
