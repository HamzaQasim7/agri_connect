import 'package:agriconnect/data/farm/api/openweathermap_weather_api.dart';
import 'package:agriconnect/data/farm/models/Forecast.dart';
import 'package:agriconnect/data/farm/models/Weather.dart';
import 'package:agriconnect/data/farm/services/forecast_service.dart';
import 'package:agriconnect/data/farm/utils/WeatherIconMapper.dart';
import 'package:agriconnect/data/farm/utils/weather_strings.dart';
import 'package:agriconnect/data/farm/utils/weather_temp.dart';
import 'package:flutter/cupertino.dart';

class ForecastViewModel with ChangeNotifier {
  bool isRequestPending = false;
  bool isWeatherLoaded = false;
  bool isRequestError = false;

  WeatherCondition _condition = WeatherCondition.unknown;

  String _description = '';
  String _iconCode = '';
  IconData _iconData = WeatherIcons.clear_day;
  double _minTemp = 0.0;
  double _maxTemp = 0.0;
  double _temp = 0.0;
  double _feelsLike = 0.0;
  int _locationId = 0;
  DateTime _lastUpdated = DateTime.now();
  String _city = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  List<Weather> _daily = [];
  bool _isDayTime = false;

  WeatherCondition get condition => _condition;
  IconData get iconData => getIconData(_iconCode);
  String get description => _description;
  String get iconCode => _iconCode;
  double get minTemp => _minTemp;
  double get maxTemp => _maxTemp;
  double get temp => _temp;
  double get feelsLike => _feelsLike;
  int get locationId => _locationId;
  DateTime get lastUpdated => _lastUpdated;
  String get city => _city;
  double get longitude => _longitude;
  double get latitide => _latitude;
  bool get isDaytime => _isDayTime;
  List<Weather> get daily => _daily;

  late ForecastService forecastService;

  ForecastViewModel() {
    forecastService = ForecastService(OpenWeatherMapWeatherApi());
  }

  Future<Forecast?> getLatestWeather(String city) async {
    setRequestPendingState(true);
    this.isRequestError = false;

    Forecast? latest;
    try {
      await Future.delayed(Duration(seconds: 1), () => {});

      latest = await forecastService
          .getWeather(city)
          // ignore: invalid_return_type_for_catch_error
          .catchError((onError) => this.isRequestError = true);
    } catch (e) {
      this.isRequestError = true;
    }

    this.isWeatherLoaded = true;
    updateModel(latest, city);
    setRequestPendingState(false);
    notifyListeners();
    return latest;
  }

  void setRequestPendingState(bool isPending) {
    this.isRequestPending = isPending;
    notifyListeners();
  }

  void updateModel(Forecast? forecast, String city) {
    if (isRequestError || forecast == null) {
      _daily = [];
      return;
    }

    _condition = forecast.current?.condition ?? WeatherCondition.unknown;
    _city = forecast.city ?? '';
    _iconCode = forecast.current?.iconCode ?? '';

    _description = Strings.toTitleCase(forecast.current?.description ?? '');
    _lastUpdated = forecast.lastUpdated ?? DateTime.now();
    _temp = TemperatureConvert.kelvinToCelsius(forecast.current?.temp ?? 0.0);
    _feelsLike = TemperatureConvert.kelvinToCelsius(
        forecast.current?.feelLikeTemp ?? 0.0);
    _longitude = forecast.longitude ?? 0.0;
    _latitude = forecast.latitude ?? 0.0;
    _daily = forecast.daily ?? [];
    _isDayTime = forecast.isDayTime ?? false;
  }

  IconData getIconData(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.clear_day;
      case '01n':
        return WeatherIcons.clear_night;
      case '02d':
      case '02n':
        return WeatherIcons.few_clouds_day;
      case '03d':
      case '04d':
      case '03n':
      case '04n':
        return WeatherIcons.clouds_day;
      // Add other cases...
      default:
        return WeatherIcons.clear_day;
    }
  }
}
