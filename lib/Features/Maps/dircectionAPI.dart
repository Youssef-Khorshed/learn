import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey;

  ApiService(this.apiKey);

  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final List<LatLng> points = [];
        final routes = data['routes'][0]['legs'][0]['steps'];
        for (var step in routes) {
          final latLng = step['end_location'];
          points.add(LatLng(latLng['lat'], latLng['lng']));
        }
        return points;
      }
    }
    return [];
  }
}
