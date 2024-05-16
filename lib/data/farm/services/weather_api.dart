import 'package:agriconnect/data/farm/models/Forecast.dart';
import 'package:agriconnect/data/farm/models/Location.dart';

abstract class WeatherApi {
  Future<Forecast> getWeather(Location location);
  Future<Location> getLocation(String city);
}
