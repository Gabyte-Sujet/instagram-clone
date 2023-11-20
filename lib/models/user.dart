import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.username,
    required this.uid,
  });

  final String username;
  final String email;
  final String bio;
  final String photoUrl;
  final String uid;
  final List following;
  final List followers;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'bio': bio,
      'followers': [],
      'following': [],
      'photoUrl': photoUrl,
    };
  }

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
      bio: snap['bio'],
      email: snap['email'],
      followers: snap['followers'],
      following: snap['following'],
      photoUrl: snap['photoUrl'],
      username: snap['username'],
      uid: snap['uid'],
    );
  }
}
