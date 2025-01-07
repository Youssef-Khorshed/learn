import 'package:dio/dio.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/handlemessage.dart';
import 'package:flutter_complete_project/Core/Strings/strings.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/destination_model.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/PlaceDetails.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapRemoteDataSource {
  Future<AutoCompleteResponse> fetchSuggestions(
      {required String searchQuery, required String sessionToken});
  Future<PlacedetailsResponse> getPlaceLocation(
      {required String placeId, required String sessionToken});
  Future<DestinationResponse> getDirections(LatLng origin, LatLng destination);
}

class MapRemoteDataSourceImplementation implements MapRemoteDataSource {
  Dio dio;
  MapRemoteDataSourceImplementation({required this.dio});
  @override
  Future<AutoCompleteResponse> fetchSuggestions(
      {required String searchQuery, required String sessionToken}) async {
    final res = await dio.get(StringManager.placeLocationAutoCompleteUrl(
        searchQuery: searchQuery, sessionToken: sessionToken));
    if (res.statusCode == 200 && res.statusCode != null) {
      return AutoCompleteResponse.fromJson(res.data);
    }
    throw ServerException(message: getErrorMessage(res.data['code']));
  }

  @override
  Future<PlacedetailsResponse> getPlaceLocation(
      {required String placeId, required String sessionToken}) async {
    final res = await dio.get(StringManager.placeLocationBaseUr(
        placeid: placeId, sessionToken: sessionToken));

    if (res.statusCode == 200 && res.statusCode != null) {
      return PlacedetailsResponse.fromJson(res.data);
    }
    throw ServerException(message: getErrorMessage(res.data['code']));
  }

  @override
  Future<DestinationResponse> getDirections(
      LatLng origin, LatLng destination) async {
    final res = await dio.get(StringManager.directionsBaseUrl(
        origin: origin, destination: destination));
    if (res.statusCode == 200 && res.statusCode != null) {
      return DestinationResponse.fromJson(res.data);
    } else {
      throw ServerException(message: getErrorMessage(res.data['code']));
    }
  }
}
