import 'package:agriconnect/data/farm/view_model/weather_app_forecast_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class CityEntryViewModel with ChangeNotifier {
  late String _city;
  CityEntryViewModel();
  // CityEntryViewModel() {
  //   _getCurrentLocation(); // Call on initialization to get initial city
  // }

  String get city => _city;
  // Future<void> _getCurrentLocation() async {
  //   try {
  //     final position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.low);
  //     final placemarks =
  //         await Geocoder.from(position.latitude, position.longitude)
  //             .getAddress(Locale.current);
  //     _city = placemarks.locality ??
  //         ""; // Use locality (city) if available, otherwise empty string
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error getting location: $e");
  //     // Handle location permission errors or other exceptions (optional)
  //   }
  // }

  void refreshWeather(String newCity, BuildContext context) {
    Provider.of<ForecastViewModel>(context, listen: false)
        .getLatestWeather(_city);

    notifyListeners();
  }

  void updateCity(String newCity) {
    _city = newCity;
  }
}

void getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Access the latitude and longitude from the position object
    double latitude = position.latitude;
    double longitude = position.longitude;
    // updateCity('$latitude, $longitude');
    // Now you can use latitude and longitude as needed
    print('Latitude: $latitude, Longitude: $longitude');
  } catch (e) {
    print('Error getting current location: $e');
    ScaffoldMessenger(
        child: SnackBar(content: Text('error during getting location')));
  }
}
