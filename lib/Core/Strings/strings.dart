import 'package:google_maps_flutter/google_maps_flutter.dart';

class StringManager {
// Google Maps
  static String apiKey = 'AIzaSyD0wUQ43jOKDFyyh7ILEE7HzImVAOjVKYA';
  static String placeLocationAutoCompleteUrl({
    required String searchQuery,
    String country = 'eg',
    required String sessionToken,
    String? language,
  }) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&types=address&component=country:$country&sessiontoken=$sessionToken&language=$language&key=$apiKey';

  static String placeLocationBaseUr({
    required String placeid,
    required String sessionToken,
  }) =>
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeid&fields=geometry&sessiontoken=$sessionToken&key=$apiKey';

  static String directionsBaseUrl(
          {required LatLng origin, required LatLng destination}) =>
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

  // Weather API

  static String weatherApiKey = '161420ebc4f999a75fc800435d135853';
  static getWeatherbyCityName(String cityname) =>
      'https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=$weatherApiKey';
}
