import 'package:flutter/material.dart';
import 'package:flutter_complete_project/Core/Error/Eitherdata.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Error/networkException/networkErrorhandler.dart';
import 'package:flutter_complete_project/Features/Maps/Data/DataSource/mapremote.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/destination_model.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/PlaceDetails.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRepoimplementation {
  MapRemoteDataSource mapRemoteDataSource;
  MapsRepoimplementation({required this.mapRemoteDataSource});

  Future<FetchResult<AutoCompleteResponse, AppException>> fetchSuggestions(
      {required String searchQuery, required String sessionToken}) async {
    try {
      final res = await mapRemoteDataSource.fetchSuggestions(
          searchQuery: searchQuery, sessionToken: sessionToken);
      return res.fold((l) => FetchResult.error(l),
          (r) => FetchResult.success(r as AutoCompleteResponse));
    } catch (error) {
      return FetchResult.error(DioErrorHandler.handle(error));
    }
  }

  Future<FetchResult<DestinationResponse, AppException>> getDirections(
      LatLng origin, LatLng destination) async {
    try {
      final res = await mapRemoteDataSource.getDirections(origin, destination);
      return res.fold(
          (onError) => FetchResult.error(DioErrorHandler.handle(onError)),
          (onSuccess) => FetchResult.success(onSuccess as DestinationResponse));
    } catch (error) {
      return FetchResult.error(DioErrorHandler.handle(error));
    }
  }

  Future<FetchResult<PlacedetailsResponse, AppException>> getPlaceLocation(
      {required String placeId, required String sessionToken}) async {
    final res = await mapRemoteDataSource.getPlaceLocation(
        placeId: placeId, sessionToken: sessionToken);
    try {
      return res.fold((onError) => FetchResult.error(onError), (onSuccess) {
        debugPrint('onSuccess.toString(): ${onSuccess.toString()}');

        return FetchResult.success(onSuccess);
      });
    } catch (error) {
      return FetchResult.error(DioErrorHandler.handle(error));
    }
  }
}
