import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  //we add this to be able to pass data from child to parent widget
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationInput> {
  String _previewImageUlr = '';

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUlr = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    //byfault when we call this method on a android simulator
    //we get the google offices location
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUlr == ''
              ? Text(
                  'No location choosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUlr,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current location'),
              onPressed: _getCurrentUserLocation,
            ),
          ],
        ),
      ],
    );
  }
}
