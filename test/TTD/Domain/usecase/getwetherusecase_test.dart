import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Features/TTD/Data/model/weathermodel.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/usecase/getwetherusecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../helpers/readjson.dart';
import '../../../helpers/testheplers.mocks.dart';

void main() {
  ///Arrange
  late Getwetherusecase getwetherusecase;
  late MockWeatherRepo mockWeatherRepo;
  const String city = 'Cairo';

  setUp(() {
    mockWeatherRepo = MockWeatherRepo();
    getwetherusecase = Getwetherusecase(mockWeatherRepo);
  });

  test('Get weather usecase test', () async {
    //arrange
    final result = WeatherResponse.fromJson(
        jsonDecode(await readJson(name: 'helpers/weatherjsontest')));
    final entity = result.toEntity(weatherResponse: result);
    when(mockWeatherRepo.getWeather(city))
        .thenAnswer((_) async => Right(entity));

    //act
    final data = await getwetherusecase.execute(city);

    //assert
    expect(data, Right(entity));
  });
}
