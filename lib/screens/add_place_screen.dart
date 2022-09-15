import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/remote_helper.dart';
import '../models/place.dart';
import '../providers/auth.dart';
import '../providers/great_places.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static String routeName = '/add-place';

  const AddPlaceScreen({super.key});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  bool _isActive = false;
  PlaceLocation? _pickedLocation;

  void _selectPlace(double lat, double lng) {
    setState(() {
      _isActive = true;
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
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
  void initState() {
    RemoteHelper.loadRemote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share my location'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/places');
              },
              icon: const Icon(Icons.list))
        ],
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
            padding: const EdgeInsets.all(10),
            child: Center(
              child: LocationInput(_selectPlace),
            ),
          ),
          //),
          ElevatedButton.icon(
            icon: const Icon(Icons.cancel),
            label: const Text('Stop sharing'),
            onPressed: _isActive ? _savePlace : null,
            //remove elevatino to set the button full on the button
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //backgroundColor: Theme.of(context).accentColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: Provider.of<Auth>(context, listen: false).logout,
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
