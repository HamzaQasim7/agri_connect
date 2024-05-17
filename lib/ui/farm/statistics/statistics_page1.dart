import 'package:agriconnect/ui/farm/statistics/widget/calendarHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../weather/statistics_weatherHome.dart';

class StatisticsPageOne extends StatefulWidget {
  @override
  _StatisticsPageOneState createState() => _StatisticsPageOneState();
}

class _StatisticsPageOneState extends State<StatisticsPageOne> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: WeatherHomeStatistics(),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: CalendarScreen(),
          ),
        ],
      ),
    );
  }
}
