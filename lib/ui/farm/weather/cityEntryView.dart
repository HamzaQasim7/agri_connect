import 'package:farmassist/data/farm/view_model/cityEntryViewModel.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class CityEntryView extends StatefulWidget {
  @override
  _CityEntryState createState() => _CityEntryState();
}

class _CityEntryState extends State<CityEntryView> {
  late TextEditingController cityEditController;
  String _currentCity = '';

  @override
  void initState() {
    super.initState();

    cityEditController = new TextEditingController();
    _getCurrentLocationCity();
    // sync the current value in text field to
    // the view model

    cityEditController.addListener(() {
      Provider.of<CityEntryViewModel>(this.context, listen: false)
          .updateCity(cityEditController.text);
      Provider.of<CityEntryViewModel>(this.context, listen: false)
          .refreshWeather(cityEditController.text, context);
    });
  }

  void _getCurrentLocationCity() async {
    try {
      // Request location permissions
      await Geolocator.requestPermission();

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
      // log('The current location city:\n$placemark');
      setState(() {
        _currentCity = placemark.locality ?? '';
        cityEditController.text = _currentCity;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CityEntryViewModel>(
        builder: (context, model, child) => Container(
            margin: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 25),
            // padding: EdgeInsets.only(left: 5, top: 5, right: 20, bottom: 00),
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    model.updateCity(cityEditController.text);
                    model.refreshWeather(cityEditController.text, context);
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: cityEditController,
                        decoration:
                            InputDecoration.collapsed(hintText: "Enter City"),
                        onSubmitted: (String city) =>
                            {model.refreshWeather(city, context)})),
              ],
            )));
  }
}
