import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    required this.id,
    required this.title,
    this.location = const PlaceLocation(latitude: 0, longitude: 0),
    required this.image,
  });
}