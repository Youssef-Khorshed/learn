import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';

abstract class WeatherRepo {
  Future<Either<Failure, WeatherEntity>> getWeather(String city);
}
