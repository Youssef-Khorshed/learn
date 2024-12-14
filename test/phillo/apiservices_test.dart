import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Network/dio.dart';
import 'package:flutter_complete_project/Core/models/getfilghts/getfilghts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/readjson.dart';
import '../helpers/testheplers.mocks.dart';

void main() {
  late MockDioClinet dioClinet;
  late MockInternetConnectivity connectivity;
  late DioFactory factoryer;
  getlink() =>
      'https://takeed.runasp.net/api/v1/air/search_and_shopping/get-flight-offers?OriginLocationCode=CAI&DestinationLocationCode=RUH&DepartureDate=12-14-2024&ReturnDate=12-31-2024&Adults=1&Children=1&Infants=1&CurrencyCode=SAR&MaxPrice=10000&Max=1';

  setUp(() {
    connectivity = MockInternetConnectivity();
    dioClinet = MockDioClinet();
    factoryer = DioFactory(internetConnectivity: connectivity);
  });

  group('API Services Test', () {
    test('Success', () async {
      when(connectivity.isConnected)
          .thenAnswer((_) async => await Future.value(true));
      when(dioClinet.get(getlink())).thenAnswer((_) async => await Response(
          data: Getfilghts.fromJson(
              await jsonDecode(await readJson(name: 'helpers/createflight'))),
          requestOptions: RequestOptions(path: getlink()),
          statusCode: 200));
      final result = await factoryer.getRequest(
        getlink(),
      );
      List<dynamic> a = result['tayarResult']['data'];
      final actual = await Getfilghts.fromJson(a.first);
      expect(actual, isA<Getfilghts>());
    });

    test('Failure', () async {
      when(connectivity.isConnected).thenAnswer((_) async => false);
      when(dioClinet.get(getlink())).thenAnswer((_) async => await Response(
          data: await jsonDecode(await readJson(name: 'helpers/createflight')),
          requestOptions: RequestOptions(path: getlink()),
          statusCode: 401));
      final actual = () async => await factoryer.getRequest(
            getlink(),
          );

      expect(actual(), throwsA(isA<NoInternetException>()));
    });
  });
}
