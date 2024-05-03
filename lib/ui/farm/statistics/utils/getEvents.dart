import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;

Map<DateTime, List<NeatCleanCalendarEvent>> getHarvestEvents() {
  User? user = auth.currentUser;
  final uid = user!.uid;
  Map<DateTime, List<NeatCleanCalendarEvent>> _events = {};

  db
      .collection('planting')
      .doc(uid)
      .collection('month')
      .get()
      .then((value) => value.docs.forEach((element) {
            if (element.get('month') == -99) {
              print('');
            } else {
              var plantName = element.get('name');
              DateTime harvestDate = DateTime(
                element.get('harvestYear'),
                element.get('harvestMonth'),
                element.get('harvestDay'),
              );

              if (_events.containsKey(harvestDate)) {
                var list = {
                  'name': 'Harvest $plantName',
                  'isDone': element.get('harvested'),
                };

                _events[harvestDate]!.add(
                  NeatCleanCalendarEvent(
                    startTime: harvestDate,
                    endTime: harvestDate.add(Duration(days: 1)),
                    list['name']!,
                    isDone: list['isDone'],
                  ),
                );
              } else {
                var list = [
                  {
                    'name': 'Harvest $plantName',
                    'isDone': element.get('harvested'),
                  }
                ];

                _events[harvestDate] = list
                    .map((e) => NeatCleanCalendarEvent(
                          startTime: harvestDate,
                          endTime: harvestDate.add(Duration(days: 1)),
                          e['name']!,
                          isDone: e['isDone'],
                        ))
                    .toList();
              }
            }
          }));

  return _events;
}
//
// Map<DateTime, List<NeatCleanCalendarEvent>> getHarvestEvents() {
//   User? user = auth.currentUser;
//   final uid = user!.uid;
//   Map<DateTime, List<NeatCleanCalendarEvent>> _events = new Map();
//
//   db
//       .collection('planting')
//       .doc(uid)
//       .collection('month')
//       .get()
//       .then((value) => value.docs.forEach((element) {
//             if (element.get('month') == -99) {
//               print('');
//             } else {
//               var plantName = element.get('name');
//               if (_events.containsKey(DateTime(element.get('harvestYear'),
//                   element.get('harvestMonth'), element.get('harvestDay')))) {
//                 var list = {
//                   'name': 'Harvest $plantName',
//                   'isDone': element.get('harvested'),
//                 };
//
//                 _events[DateTime(
//                         element.get('harvestYear'),
//                         element.get('harvestMonth'),
//                         element.get('harvestDay'))]!
//                     .add(list);
//               } else {
//                 _events[DateTime(element.get('harvestYear'),
//                     element.get('harvestMonth'), element.get('harvestDay'))] = [
//                   {
//                     'name': 'Harvest $plantName',
//                     'isDone': element.get('harvested'),
//                   }
//                 ];
//               }
//             }
//           }));
//   return _events;
// }
