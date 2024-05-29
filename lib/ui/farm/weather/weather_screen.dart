import 'package:agriconnect/app_theme.dart';
import 'package:agriconnect/ui/farm/weather/weatherSummaryView.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

import '../../../data/farm/view_model/weather_app_forecast_viewmodel.dart';
import 'cityEntryView.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.pageTitle});
  final String pageTitle;
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController cityEditController = TextEditingController();
  String _currentCity = '';

  static const weatherApiKey = "1aab61ae052b8d52effa158878393744";
  WeatherFactory weatherFactory = WeatherFactory(weatherApiKey);
  Weather? _weather;
  List<Weather>? _weeklyForecast;
  @override
  void initState() {
    super.initState();
    _getCurrentLocationCity();
  }

  void _getCurrentLocationCity() async {
    try {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the list of placemark from the current position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Get the city name from the placemark
      Placemark placemark = placemarks[0];

      setState(() {
        _currentCity = placemark.locality ?? '';
        cityEditController.text = _currentCity;
      });

      // Call weather API with the current city name
      weatherFactory.currentWeatherByCityName(_currentCity).then((w) async {
        _weather = w;

        try {
          _weeklyForecast =
              await weatherFactory.fiveDayForecastByCityName(_currentCity);
          setState(() {});
        } catch (error) {
          print('Error fetching five-day forecast by city name: $error');
        }

        setState(() {});
      }).catchError((error) {
        print('Error fetching weather by city name: $error');
      });

      print('The current location city:\n$_currentCity');
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatSunTime(DateTime? sunTime) {
    if (sunTime == null) {
      return 'N/A';
    }
    return DateFormat('h:mm a').format(sunTime);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    DateTime? sunrise = _weather?.sunrise;
    DateTime? sunset = _weather?.sunset;
    String formattedSunrise = formatSunTime(sunrise);
    String formattedSunset = formatSunTime(sunset);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/weather_bg.jpg'),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04, horizontal: size.width * 0.02),
            child: Column(
              children: [

                _appBar(),
                _buildBody(),
                SizedBox(height: 30),
                _buildForecast(),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _reusableCard(
                      'Min temp',
                      "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                      'assets/icons/low-temprature.png',
                    ),
                    _reusableCard(
                      'Max temp',
                      "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                      'assets/icons/high-temprature.png',
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _reusableCard(
                      'Sun rise',
                      formattedSunrise,
                      'assets/icons/sunrise.png',
                    ),
                    _reusableCard(
                      'Sun set',
                      formattedSunset,
                      'assets/icons/sunset.png',
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _reusableCard(
                      'Wind speed',
                      "${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                      'assets/icons/wind.png',
                    ),
                    _reusableCard(
                      'Humidity',
                      "${_weather?.humidity?.toStringAsFixed(0)}%",
                      'assets/icons/humidity.png',
                    ),
                  ],
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: CityEntryView(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
            height: MediaQuery.sizeOf(context).height * 0.22,
            child: _dateTimeInfo()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.6,
                height: MediaQuery.sizeOf(context).height * 0.23,
                child: Consumer<ForecastViewModel>(
                    builder: (context, weatherViewModel, child) {
                  return WeatherSummary(
                    condition: weatherViewModel.condition,
                    temp: weatherViewModel.temp,
                    feelsLike: weatherViewModel.feelsLike,
                    isdayTime: weatherViewModel.isDaytime,
                    iconData: weatherViewModel.iconData,
                    model: ForecastViewModel(),
                    // weatherModel: model,
                  );
                })),
          ),
        ),
      ],
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather?.date ?? DateTime.now();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${DateFormat("EEEE").format(now)},",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForecast() {
    Map<DateTime, List<Weather>> groupedForecast = {};

    _weeklyForecast?.forEach((forecast) {
      DateTime date = forecast.date!;
      DateTime day = DateTime(date.year, date.month, date.day);
      if (!groupedForecast.containsKey(day)) {
        groupedForecast[day] = [];
      }
      groupedForecast[day]!.add(forecast);
    });

    return _weeklyForecast != null
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: groupedForecast.entries.map((entry) {
                List<Weather> dailyForecasts = entry.value;
                Weather firstForecast = dailyForecasts.first;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                DateFormat('EEE').format(firstForecast.date!),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              // SizedBox(width: 12),
                              // Text(
                              //   DateFormat('dd.MM.yyyy')
                              //       .format(firstForecast.date!),
                              // ),
                            ],
                          ),
                          Icon(
                            _getWeatherIcon(firstForecast.weatherDescription),
                            size: 40,
                          ),
                          Text(
                            '${firstForecast.temperature!.celsius!.toStringAsFixed(1)}°C',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  IconData _getWeatherIcon(String? weatherDescription) {
    if (weatherDescription != null) {
      final description = weatherDescription.toLowerCase();
      if (description.contains('rain')) {
        return Icons.cloud_outlined;
      } else if (description.contains('sunny')) {
        return Icons.wb_sunny;
      } else if (description.contains('cloud')) {
        return Icons.cloud_queue;
      } else if (description.contains('clear')) {
        return Icons.wb_sunny;
      } else if (description.contains('thunderstorm')) {
        return Icons.flash_on;
      } else if (description.contains('snow')) {
        return Icons.ac_unit;
      } else if (description.contains('fog')) {
        return Icons.cloud_queue;
      } // Add more conditions for other weather descriptions
    }
    return Icons.cloud; // Default icon
  }

  Widget _reusableCard(String title, String temp, String img) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.5),
            offset: Offset(3, 3),
            spreadRadius: 5,
            blurRadius: 5,
          )
        ],
      ),
      child: Center(
        child: ListTile(
          leading: Image.asset(
            img,
            width: 25,
            height: 40,
          ),
          title: Text(title),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("${temp}"),
          ),
          titleTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          subtitleTextStyle: const TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
