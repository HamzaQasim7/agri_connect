import 'package:agriconnect/data/IoT/models/telemetry_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TelemetryDataRepository {
  TelemetryDataRepository() {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    firebaseDatabase.setPersistenceEnabled(true);
    _telemetryDb = firebaseDatabase
        .reference()
        .child('telemetry_data')
        .child(FirebaseAuth.instance.currentUser!.uid);
  }

  late DatabaseReference _telemetryDb;

  Stream<TelemetryData> readData(String data) {
    return _telemetryDb
        .child(data)
        .orderByKey()
        .onChildAdded
        .map((event) => TelemetryData.fromRealtimeDatabase(event.snapshot));
  }

  Future<List<TelemetryData>> readPrevReadings(String data, int num) async {
    List<TelemetryData> dataList = [];
    DataSnapshot snapshot =
        (await _telemetryDb.child(data).orderByKey().limitToLast(num).once())
            .snapshot;

    if (snapshot != null && snapshot.value != null) {
      Map<String, dynamic> map =
          Map<String, dynamic>.from(snapshot.value as Map);

      // Map<dynamic, dynamic> map = snapshot!.value;
      map.entries.toList()
        ..sort((d1, d2) => int.parse(d1.key).compareTo(int.parse(d2.key)))
        ..forEach((d) => dataList.add(TelemetryData.from(d.key, d.value)));
    }
    return dataList;
  }
}
