import 'dart:convert';
import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getAddressFromLatLng(double lat, double lng) async {
  // Get the address using lat & lng value
  final mapApi = dotenv.env['MAP_API_KEY'];
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$mapApi';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final formattedAddress = data['results'][0]['formatted_address'];
        return formattedAddress;
      } else {
        return 'Error: ${data['status']}';
      }
    } else {
      return 'Failed to fetch address';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

extension LatLngBoundsExtension on LatLngBounds {
  LatLngBounds extend(LatLng point) {
    return LatLngBounds(
      southwest: LatLng(
        math.min(southwest.latitude, point.latitude),
        math.min(southwest.longitude, point.longitude),
      ),
      northeast: LatLng(
        math.max(northeast.latitude, point.latitude),
        math.max(northeast.longitude, point.longitude),
      ),
    );
  }
}
