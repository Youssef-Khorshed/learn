import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Features/TTD/Data/model/weathermodel.dart';
import 'package:flutter_complete_project/Features/TTD/Data/repoImp/repoImp.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Repo/repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/readjson.dart';
import '../../../helpers/testheplers.mocks.dart';

void main() {
  late MockWeatherRemotedatasource mockWeatherRemotedatasource;
  late WeatherRepo weatherRepoImp;

  setUp(() {
    mockWeatherRemotedatasource = MockWeatherRemotedatasource();
    weatherRepoImp =
        WeatherRepoimp(remotedatasource: mockWeatherRemotedatasource);
  });
  group('repo implementation', () {
    test('Get data Success', () async {
      final model = WeatherResponse.fromJson(
        jsonDecode(await readJson(name: 'helpers/weatherjsontest')),
      );
      final entity = model.toEntity(weatherResponse: model);
      when(mockWeatherRemotedatasource.getWeather('Alexandria')).thenAnswer(
        (_) async => model,
      );

      ///assert
      final result = weatherRepoImp.getWeather('Alexandria');
      expect(
          result,
          equals(
            Right(entity),
          ));
    });
  });
}
