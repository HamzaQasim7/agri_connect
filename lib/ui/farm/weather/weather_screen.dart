import 'package:agriconnect/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
                _tempRates(),
                SizedBox(height: 20),
                _buildRow()
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
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            height: MediaQuery.sizeOf(context).height * 0.15,
            child: _dateTimeInfo()),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.45,
              height: MediaQuery.sizeOf(context).height * 0.23,
              child: Column(
                children: [
                  // Consumer<ForecastViewModel>(
                  //     builder: (context, weatherViewModel, child) {
                  //   return Column(children: [
                  //     WeatherSummary(
                  //       condition: weatherViewModel.condition,
                  //       temp: weatherViewModel.temp,
                  //       feelsLike: weatherViewModel.feelsLike,
                  //       isdayTime: weatherViewModel.isDaytime,
                  //       iconData: weatherViewModel.iconData,
                  //       model: ForecastViewModel(),
                  //       // weatherModel: model,
                  //     ),
                  //   ]);
                  // }),
                  _currentTemp(),
                  _weatherIcon(),
                ],
              )),
        ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather?.date ?? DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            image: _weather?.weatherIcon != null
                ? DecorationImage(
                    image: NetworkImage(
                        "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png"),
                    fit: BoxFit.cover,
                  )
                : null, // Don't show image if weatherIcon is null
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C" ?? '0',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _tempRates() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.90,
      decoration: BoxDecoration(
        color: AppTheme.nearlyGreen.withOpacity(.5),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max:",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Min:",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          )
        ],
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildWind(), _buildHumidity()],
    );
  }

  Widget _buildWind() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.40,
      decoration: BoxDecoration(
        color: AppTheme.nearlyGreen.withOpacity(.5),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Wind',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            "${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidity() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.40,
      decoration: BoxDecoration(
        color: AppTheme.nearlyGreen.withOpacity(.5),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Humidity',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Text(
            "${_weather?.humidity?.toStringAsFixed(0)}%",
            style: const TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _buildForecast() {
    // Group the forecast data by day
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
}
