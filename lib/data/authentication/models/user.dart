import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.photo,
  })  : assert(email != null),
        assert(id != null);

  final String email;
  final String id;
  final String name;
  final String photo;

  static const empty = AppUser(email: '', id: '', name: '', photo: '');

  @override
  List<Object> get props => [email, id, name, photo];

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = Map<String, dynamic>.from(doc.data() as Map);

    // Map<String, dynamic> data = doc.data();
    return AppUser(
      id: data['id'],
      email: data['email'],
      name: data['displayName'],
      photo: data['photoURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': name,
      'photoURL': photo,
    };
  }
}
