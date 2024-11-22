import 'package:dartz/dartz.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/failure.dart';
import 'package:flutter_complete_project/Features/Maps/Data/DataSource/mapremote.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/destination_model.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/PlaceDetails.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRepoimplementation {
  MapRemoteDataSource mapRemoteDataSource;
  MapsRepoimplementation({required this.mapRemoteDataSource});

  Future<Either<Failure, AutoCompleteResponse>> fetchSuggestions(
      {required String searchQuery, required String sessionToken}) async {
    try {
      final res = await mapRemoteDataSource.fetchSuggestions(
          searchQuery: searchQuery, sessionToken: sessionToken);

      return Right(res);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.toString()));
    } catch (error) {
      return Left(UnExpectedFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, DestinationResponse>> getDirections(
      LatLng origin, LatLng destination) async {
    try {
      final res = await mapRemoteDataSource.getDirections(origin, destination);
      return Right(res);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.toString()));
    } catch (error) {
      return Left(UnExpectedFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, PlacedetailsResponse>> getPlaceLocation(
      {required String placeId, required String sessionToken}) async {
    final res = await mapRemoteDataSource.getPlaceLocation(
        placeId: placeId, sessionToken: sessionToken);
    try {
      return Right(res);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.toString()));

    } catch (error) {
      return Left(UnExpectedFailure(message: error.toString()));
    }
  }
}
