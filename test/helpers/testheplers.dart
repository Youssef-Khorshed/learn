import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Network/internetconnection.dart';
import 'package:flutter_complete_project/Features/TTD/Data/datasource/remote/remoteDatasource.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Repo/repo.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  WeatherRepo,
  InternetConnectivity,
  WeatherRemotedatasource
], customMocks: [
  MockSpec<Dio>(as: #MockDioClinet),
  MockSpec<Connectivity>(as: #MockConnectivity)
])
void main() {}
