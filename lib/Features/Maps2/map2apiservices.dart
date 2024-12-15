import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_complete_project/Core/Error/exception.dart';
import 'package:flutter_complete_project/Core/Network/dio.dart';
import 'package:flutter_complete_project/Core/Network/internetconnection.dart';
import 'package:flutter_complete_project/Features/Maps/Data/Model/autoCompleteModel.dart';
import 'package:dartz/dartz.dart';

class MyMapServices {
  static String baseUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyCI1Xh53omwfYyDPXsovvHwjMgyvamPtow&input=";
  static Future<Either<ServerException, List<Predictions>>> fetchSuggestions(
      String input) async {
    try {
      DioFactory dioFactory = DioFactory(
        internetConnectivity: MobileConnectivity(connectivity: Connectivity()),
      );

      final res = await dioFactory.getRequest("$baseUrl$input");
      List<dynamic> data = res['predictions'];

      // Map data to Predictions objects and return it as a list
      final result = data.map((item) => Predictions.fromJson(item)).toList();
      return Right(result);
    } catch (e) {
      // Optionally, you can throw an exception or return an empty list
      return Left(ServerException(
          message: e.toString())); // or return an empty list if you prefer
    }
  }
}
