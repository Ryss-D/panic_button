import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../models/place.dart';
import '../providers/great_places.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static String routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  bool _isActive = false;
  PlaceLocation? _pickedLocation;

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    setState(() {
      _isActive = true;
    });
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _pickedLocation!,
    );
  }

  void _savePlace() {
    setState(() {
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share my location'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //we add this expanded-> column as a nested object
          // to ensure that the buttonkeep on top but this elements dont
          //extend to all the screen
          //Expanded(
          // child: Padding(
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: LocationInput(_selectPlace),
            ),
          ),
          //),
          ElevatedButton.icon(
            icon: Icon(Icons.cancel),
            label: Text('Stop sharing'),
            onPressed: _isActive ? _savePlace : null,
            //remove elevatino to set the button full on the button
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //backgroundColor: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
