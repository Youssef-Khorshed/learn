import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/Eitherdata.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/networkException/networkErrorhandler.dart';
import 'package:flutter_complete_project/Core/Strings/strings.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/DestinationModel.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/PlaceDetails.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapRemoteDataSource {
  Future<FetchResult<dynamic, AppException>> fetchSuggestions(
      {required String searchQuery, required String sessionToken});
  Future<FetchResult<dynamic, AppException>> getPlaceLocation(
      {required String placeId, required String sessionToken});
  Future<FetchResult<dynamic, AppException>> getDirections(
      LatLng origin, LatLng destination);
}

class MapRemoteDataSourceImplementation implements MapRemoteDataSource {
  Dio dio;
  MapRemoteDataSourceImplementation({required this.dio});
  @override
  Future<FetchResult<dynamic, AppException>> fetchSuggestions(
      {required String searchQuery, required String sessionToken}) async {
    try {
      final res = await dio.get(StringManager.placeLocationAutoCompleteUrl(
          searchQuery: searchQuery, sessionToken: sessionToken));
      return FetchResult.success(AutoCompleteResponse.fromJson(res.data));
    } catch (error) {
      return FetchResult.error(DioErrorHandler.handle(error));
    }
  }

  @override
  Future<FetchResult<dynamic, AppException>> getDirections(
      LatLng origin, LatLng destination) async {
    try {
      final res = await dio.get(StringManager.directionsBaseUrl(
          origin: origin, destination: destination));
      return FetchResult.success(DestinationResponse.fromJson(res.data));
    } catch (error) {
      return FetchResult.error(DioErrorHandler.handle(error));
    }
  }

  @override
  Future<FetchResult<dynamic, AppException>> getPlaceLocation(
      {required String placeId, required String sessionToken}) async {
    try {
      final res = await dio.get(StringManager.placeLocationBaseUr(
          placeid: placeId, sessionToken: sessionToken));
      return FetchResult.success(PlacedetailsResponse.fromJson(res.data));
    } catch (error) {
      return FetchResult.error(DioErrorHandler.handle(error));
    }
  }
}
