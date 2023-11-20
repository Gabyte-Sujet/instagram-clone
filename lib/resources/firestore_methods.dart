import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'Some error';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = Uuid().v1();

      Post post = Post(
        datePublished: DateTime.now(),
        description: description,
        likes: [],
        postId: postId,
        postUrl: photoUrl,
        profImage: profImage,
        uid: uid,
        username: username,
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'postId': postId,
            'text': text,
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'datePublished': DateTime.now(),
          },
        );
      } else {
        print('text is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          document.reference.delete();
        });
      });

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .parent!
          .delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser({
    required String uid,
    required String followId,
  }) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    List following = (snap.data() as dynamic)['following'];

    if (following.contains(followId)) {
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayRemove([uid]),
      });

      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId]),
      });
    } else {
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayUnion([uid]),
      });

      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId]),
      });
    }
  }
}
