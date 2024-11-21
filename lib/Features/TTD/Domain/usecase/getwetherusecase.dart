import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Repo/repo.dart';

class Getwetherusecase {
  final WeatherRepo repo;
  Getwetherusecase(this.repo);

  Future<Either<Failure, WeatherEntity>> execute(String city) =>
      repo.getWeather(city);
}
