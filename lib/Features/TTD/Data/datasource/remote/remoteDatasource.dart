import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/handlemessage.dart';
import 'package:flutter_complete_project/Core/Network/internetconnection.dart';
import 'package:flutter_complete_project/Core/Strings/strings.dart';
import 'package:flutter_complete_project/Features/TTD/Data/model/weathermodel.dart';

abstract class WeatherRemotedatasource {
  Future<WeatherResponse> getWeather(String city);
}

class WeatherRemoteDatasourceImp implements WeatherRemotedatasource {
  Dio dio;
  InternetConnectivity internetConnectivity;
  WeatherRemoteDatasourceImp(
      {required this.dio, required this.internetConnectivity});
  @override
  Future<WeatherResponse> getWeather(String city) async {
    if (await internetConnectivity.isConnected) {
      final response = await dio.get(StringManager.getWeatherbyCityName(city));
      if (response.statusCode != null) {
        if (response.statusCode == 200) {
          return WeatherResponse.fromJson(response.data);
        } else {
          throw ServerException(
            message: getErrorMessage(response.data['cod']),
          );
        }
      }
    } else {
      throw NoInternetException(message: 'No internet Connection');
    }
    throw UnExpectedException(message: 'Un Expected error occurs');
  }
}
