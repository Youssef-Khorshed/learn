import 'dart:convert';

import 'package:flutter_complete_project/Features/TTD/Data/model/weathermodel.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/readjson.dart';

void main() {
  // arrange
  WeatherResponse weatherResponse = WeatherResponse(
      base: 'base',
      clouds: Clouds(all: 1),
      cod: 1,
      coord: Coord(lat: 1, lon: 1),
      dt: 1,
      id: 1,
      main: Main(
          feelsLike: 1,
          grndLevel: 1,
          humidity: 1,
          pressure: 1,
          seaLevel: 1,
          temp: 1,
          tempMax: 1,
          tempMin: 1),
      name: 'name',
      sys: Sys(country: 'country', id: 1, sunrise: 1, sunset: 1, type: 1),
      timezone: 1,
      visibility: 1,
      weather: [
        Weather(description: 'description', icon: 'icon', id: 1, main: 'main')
      ],
      wind: Wind(deg: 1, gust: 1, speed: 1));

  test('Test weather model is a part of weather entity', () {
    //act
    final result = weatherResponse.toEntity(weatherResponse: weatherResponse);
    //assert
    expect(result, isA<WeatherEntity>());
  });

  test('get json from weather model', () {
    //act
    final result = WeatherResponse.fromJson(
        jsonDecode(readjson(name: 'helpers/weatherjsontest.json')));
    //assert
    expect(result, isA<WeatherResponse>());
  });
}
