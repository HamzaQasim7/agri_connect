import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static Future<String> getCurrentLocationCity() async {
    try {
      // Request location permissions
      await Geolocator.requestPermission();

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the list of placemarks from the current position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Get the city name from the placemark
      Placemark placemark = placemarks[0];
      return placemark.locality ?? '';
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }
}
