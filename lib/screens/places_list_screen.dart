import 'package:flutter/material.dart';

class PlacesListScreen extends StatefulWidget {
  static const routeName = '/places';
  const PlacesListScreen({super.key});

  @override
  PlacesListScreenState createState() => PlacesListScreenState();
}

class PlacesListScreenState extends State<PlacesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations shared with me'),
      ),
    );
  }
}
