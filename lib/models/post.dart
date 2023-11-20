import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.datePublished,
    required this.description,
    required this.likes,
    required this.postId,
    required this.postUrl,
    required this.profImage,
    required this.uid,
    required this.username,
  });

  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'uid': uid,
      'username': username,
      'postId': postId,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'profImage': profImage,
      'likes': likes,
    };
  }

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      description: snap['description'],
      datePublished: snap['datePublished'],
      postUrl: snap['postUrl'],
      postId: snap['postId'],
      likes: snap['likes'],
      username: snap['username'],
      uid: snap['uid'],
      profImage: snap['profImage'],
    );
  }
}
