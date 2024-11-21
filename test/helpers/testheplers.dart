import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Repo/repo.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([WeatherRepo], customMocks: [MockSpec<Dio>(as: #MockDioClinet)])
void main() {}
