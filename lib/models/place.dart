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
  final PlaceLocation location;

  Place({
    required this.id,
    this.location = const PlaceLocation(latitude: 0, longitude: 0),
  });
}
