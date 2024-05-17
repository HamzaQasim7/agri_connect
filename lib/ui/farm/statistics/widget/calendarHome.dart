// import 'package:agriconnect/ui/farm/statistics/utils/getEvents.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
//
// class CalendarScreen extends StatefulWidget {
//   @override
//   _CalendarScreenState createState() => _CalendarScreenState();
// }
//
// class _CalendarScreenState extends State<CalendarScreen> {
//   void _handleNewDate(date) {
//     setState(() {
//       _selectedDay = date;
//       _selectedEvents = _events[_selectedDay] ?? [];
//     });
//   }
//
//   List _selectedEvents = [];
//   DateTime _selectedDay = DateTime.now();
//
//   final Map<DateTime, List<NeatCleanCalendarEvent>> _events =
//       getHarvestEvents();
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedEvents = _events[_selectedDay] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Calendar(
//           startOnMonday: true,
//           weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
//           events: _events,
//           onRangeSelected: (range) =>
//               print("Range is ${range.from}, ${range.to}"),
//           onDateSelected: (date) => _handleNewDate(date),
//           isExpandable: true,
//           eventDoneColor: Colors.green,
//           selectedColor: Colors.pink,
//           todayColor: Colors.blueGrey,
//           eventColor: Colors.grey,
//           dayOfWeekStyle: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
//         ),
//         _buildEventList(),
//       ],
//     );
//   }
//
//   Widget _buildEventList() {
//     return Expanded(
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemBuilder: (BuildContext context, int index) => Container(
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(width: 1.5, color: Colors.black12),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
//           child: ListTile(
//             title: Text(_selectedEvents[index]['name'].toString()),
//             onTap: () {},
//           ),
//         ),
//         itemCount: _selectedEvents.length,
//       ),
//     );
//   }
// }
import 'package:agriconnect/ui/extensions/custom_snackbar.dart';
import 'package:agriconnect/ui/farm/statistics/utils/getEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // List _selectedEvents = [];
  List<NeatCleanCalendarEvent> _selectedEvents = [];
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<NeatCleanCalendarEvent>> _events = {};
  // final Map<DateTime, List<NeatCleanCalendarEvent>> _events =
  //     getHarvestEvents();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    Map<DateTime, List<NeatCleanCalendarEvent>> events =
        await getHarvestEvents();
    setState(() {
      _events = events;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: Calendar(
            startOnMonday: true,
            weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            events: _events,
            onRangeSelected: (range) => () {
              context.showCustomSnackBar('Range is ${range.from}, ${range.to}');
              print("Range is ${range.from}, ${range.to}");
            },
            onDateSelected: (date) => _handleNewDate(date),
            isExpandable: true,
            eventDoneColor: Colors.green,
            selectedColor: Colors.pink,
            todayColor: Colors.blueGrey,
            eventColor: Colors.grey,
            dayOfWeekStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
          ),
        ),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _selectedEvents.length,
      itemBuilder: (BuildContext context, int index) {
        final NeatCleanCalendarEvent event = _selectedEvents[index];
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: ListTile(
            title: Text(event.summary),
            onTap: () {},
          ),
        );
      },
    );
  }
}
