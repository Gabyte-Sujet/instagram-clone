import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:instagram_clone/models/user.dart' as user;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase realtimeDatabase = FirebaseDatabase.instance;

  Future<user.User> getUserDetails() async {
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    return user.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    Uint8List? file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePics', file, false);

        user.User userData = user.User(
          bio: bio,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          username: username,
          uid: cred.user!.uid,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userData.toJson());

        // DatabaseReference ref = realtimeDatabase.ref("users/123");
        // await ref.set({
        //   "name": "John",
        //   "age": 18,
        //   "address": {"line1": "100 Mountain View"}
        // });

        res = 'Success';
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(cred);
        res = 'Success';
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
