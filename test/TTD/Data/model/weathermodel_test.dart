import 'dart:convert';

import 'package:flutter_complete_project/Features/TTD/Data/model/weathermodel.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/readjson.dart';

void main() async {
  /// Arrange
  final result = WeatherResponse.fromJson(
      jsonDecode(await readJson(name: 'helpers/weatherjsontest')));
  final getjson = jsonDecode(await readJson(name: 'helpers/weatherjsontest'));

  test('get json and convert model to entity', () async {
    //act
    final entity = result.toEntity(weatherResponse: result);
    //assert
    expect(entity, isA<WeatherEntity>());
  });

  test('convert from entity to json', () async {
    // Act
    final testjson = result.toJson();

    //assert
    expect(testjson, getjson);
  });
}
