import 'dart:convert';
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyASLXNLPDPHo6Jp6NpBDMVmqOaPl-sKzTQ';

class LocationHelper {
  static String generateLocationPreviewImage(
      {required double latitude, required double longitude}) {
    // this is a google static maps api request
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY&signature=YOUR_SIGNATURE';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    //reverse geocoding request
    final endpoint = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY');
    final address = await http.get(endpoint);
    return json.decode(address.body)['results'][0]['formatted_address'];
  }
}
