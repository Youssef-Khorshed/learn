import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Strings/strings.dart';
import 'package:flutter_complete_project/Features/TTD/Data/datasource/remote/remoteDatasource.dart';
import 'package:flutter_complete_project/Features/TTD/Data/model/weathermodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../helpers/readjson.dart';
import '../../../../helpers/testheplers.mocks.dart';

void main() {
  late MockDioClinet mockDioClinet;
  late MockInternetConnectivity internetConnectivity;
  late WeatherRemotedatasource remotedatasuorce;
  late MockWeatherRemotedatasource mockWeatherRemotedatasource;

  late String cityName;
  bool interentResult = true;
  setUp(() {
    cityName = 'Alexandria';
    mockDioClinet = MockDioClinet();
    internetConnectivity = MockInternetConnectivity();
    mockWeatherRemotedatasource = MockWeatherRemotedatasource();
    remotedatasuorce = WeatherRemoteDatasourceImp(
        dio: mockDioClinet, internetConnectivity: internetConnectivity);
  });

  group('Get weather', () {
    test('should return true when connected to the internet', () async {
      // Arrange: Mock the behavior of isConnected
      when(internetConnectivity.isConnected).thenAnswer((_) async => true);

      // Act: Call the method under test
      final isConnected = await internetConnectivity.isConnected;
      // Assert: Verify the result
      expect(isConnected, true);
    });

    test('should return false when not connected to the internet', () async {
      // Arrange: Mock the behavior of isConnected
      when(internetConnectivity.isConnected).thenAnswer((_) async => false);
      // Act: Call the method under test
      final isConnected = await internetConnectivity.isConnected;
      // // Assert: Verify the result
      expect(isConnected, false);
    });

    test('Get 200 response ', () async {
      when(internetConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockDioClinet.get(StringManager.getWeatherbyCityName(cityName)))
          .thenAnswer((_) async => Response(
                data:
                    jsonDecode(await readJson(name: 'helpers/weatherjsontest')),
                requestOptions: RequestOptions(
                    path: StringManager.getWeatherbyCityName(cityName)),
                statusCode: 200,
              ));

      final result = await remotedatasuorce.getWeather(cityName);
      expect(result, isA<WeatherResponse>());
    });

    test('Get 401 response ', () async {
      when(internetConnectivity.isConnected).thenAnswer((_) async => true);
      when(mockDioClinet.get(StringManager.getWeatherbyCityName(cityName)))
          .thenAnswer((_) async => Response(
                data:
                    jsonDecode(await readJson(name: 'helpers/weatherjsontest')),
                requestOptions: RequestOptions(
                    path: StringManager.getWeatherbyCityName(cityName)),
                statusCode: 401,
              ));
      final result = () async => await remotedatasuorce.getWeather(cityName);
      expect(result(), throwsA(isA<ServerException>()));
    });

    test('no internet connection ', () async {
      when(internetConnectivity.isConnected).thenAnswer((_) async => false);
      when(mockDioClinet.get(StringManager.getWeatherbyCityName(cityName)))
          .thenAnswer((_) async => Response(
                data:
                    jsonDecode(await readJson(name: 'helpers/weatherjsontest')),
                requestOptions: RequestOptions(
                    path: StringManager.getWeatherbyCityName(cityName)),
                statusCode: 401,
              ));
      final result = () async => await remotedatasuorce.getWeather(cityName);
      expect(result(), throwsA(isA<NoInternetException>()));
    });
  });
}
