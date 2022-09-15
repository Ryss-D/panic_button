import 'package:flutter/material.dart';
import 'package:panic_button/providers/great_places.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatefulWidget {
  static const routeName = '/places';
  const PlacesListScreen({super.key});

  @override
  PlacesListScreenState createState() => PlacesListScreenState();
}

class PlacesListScreenState extends State<PlacesListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations shared with me'),
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Consumer<GreatPlaces>(
                    child: const Center(
                      child: Text('There is no reports yet'),
                    ),
                    builder: (ctx, places, child) => places.items.isEmpty
                        ? child!
                        : ListView.builder(
                            itemCount: places.items.length,
                            itemBuilder: (ctx, i) => ListTile(
                              title: Text(places.items[i].location.address),
                              subtitle: Text(
                                'Latitude: ${places.items[i].location.latitude}, Longitude: ${places.items[i].location.longitude}',
                              ),
                            ),
                          ),
                  ),
      ),
    );
  }
}
