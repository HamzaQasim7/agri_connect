import 'package:firebase_core/firebase_core.dart';

Future<void> clearFirebaseCache() async {
  await Firebase.app().delete();
}
