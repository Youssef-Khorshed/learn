import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/TTD/Data/datasource/remote/remoteDatasource.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Entity/weatherentity.dart';
import 'package:flutter_complete_project/Features/TTD/Domain/Repo/repo.dart';

class WeatherRepoimp implements WeatherRepo {
  WeatherRemotedatasource remotedatasource;
  WeatherRepoimp({required this.remotedatasource});
  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String city) async {
    try {
      final res = await remotedatasource.getWeather(city);
      return Right(res.tooEntity());
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on NoInternetException catch (error) {
      return Left(InternetConnectionFailure(message: error.message));
    }
  }
}
