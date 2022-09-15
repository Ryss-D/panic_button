import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panic_button/helpers/db_helper.dart';
import 'package:panic_button/models/place.dart';
import 'package:panic_button/providers/great_places.dart';
import 'package:provider/provider.dart';

class RemoteHelper {
  static Future loadRemote() async {
    final url = Uri.parse(
        'https://panic-button-4f3c1-default-rtdb.firebaseio.com/places.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData != null) {
        extractedData.forEach(
          (placeId, placeData) async {
            print('id $placeId data$placeData');
            await DBHelper.insert(
              'user_places',
              {
                'id': placeId,
                'loc_lat': placeData['latitude'],
                'loc_lng': placeData['longitude'],
                'address': placeData['address'],
              },
            );
          },
        );
      }
    } catch (error) {}
  }

  static Future addRemote(PlaceLocation place) async {
    final url = Uri.parse(
        'https://panic-button-4f3c1-default-rtdb.firebaseio.com/places.json');
    try {
      await http.post(
        url,
        body: json.encode(
          {
            'latitude': place.latitude,
            'longitude': place.latitude,
            'address': place.address,
          },
        ),
      );
    } catch (error) {}
  }
}
