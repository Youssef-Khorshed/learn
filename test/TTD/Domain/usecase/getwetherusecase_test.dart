import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/usecase/getwetherusecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/testheplers.mocks.dart';

void main() {
  late Getwetherusecase getwetherusecase;
  late MockWeatherRepo mockWeatherRepo;
  setUp(() {
    mockWeatherRepo = MockWeatherRepo();
    getwetherusecase = Getwetherusecase(mockWeatherRepo);
  });

  // input
  const String city = 'Cairo';
  // output
  WeatherEntity weatherEntity = WeatherEntity(
      cityName: 'Cairo',
      main: 'Clouds',
      description: 'Few Clouds',
      icon: '',
      temp: 298,
      pressure: 298,
      humidity: 298);
  test('Get weather usecase test', () async {
    //arrange
    when(mockWeatherRepo.getWeather(city))
        .thenAnswer((_) async => Right(weatherEntity));
    //act
    final result = await getwetherusecase.execute(city);
    //assert
    expect(result, Right(weatherEntity));
  });
}
