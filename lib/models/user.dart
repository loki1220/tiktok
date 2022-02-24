import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String fullname;
  final String uid;
  final String photoUrl;
  final String email;
  final String phone;
  final List followers;
  final List following;

  const User({
    required this.fullname,
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.phone,
    required this.followers,
    required this.following,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      fullname: snapshot["fullname"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      phone: snapshot["phone"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "phone": phone,
        "followers": followers,
        "following": following,
      };
}
