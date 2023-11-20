import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
    String? uid,
  })  : uid = uid ?? FirebaseAuth.instance.currentUser!.uid,
        super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? posts;
  bool isFolowing = false;
  bool isLoading = false;

  int followers = 0;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    user = User.fromSnap(snap);

    followers = user!.followers.length;

    QuerySnapshot<Map<String, dynamic>> postSnap = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('uid', isEqualTo: user!.uid)
        .get();
    posts = postSnap.docs;

    isFolowing =
        user!.followers.contains(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      isLoading = false;
    });
  }

  Column _buildStateColumn(int num, String label) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              // title: Text(currentUser == null ? '' : currentUser!.username),
              title: Text(user?.username ?? ''),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: user != null
                                ? NetworkImage(user!.photoUrl)
                                : null,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStateColumn(
                                        posts?.length ?? 0, 'posts'),
                                    _buildStateColumn(followers, 'followers'),
                                    _buildStateColumn(
                                        user?.following.length ?? 0,
                                        'following'),
                                  ],
                                ),
                                widget.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          await AuthMethods().signOut();
                                        },
                                        text: 'Sign out',
                                        textColor: primaryColor,
                                      )
                                    : isFolowing
                                        ? FollowButton(
                                            backgroundColor: Colors.white,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                followId: widget.uid,
                                              );
                                              setState(() {
                                                isFolowing = false;
                                                followers--;
                                              });
                                            },
                                            text: 'Unfollow',
                                            textColor: Colors.black,
                                          )
                                        : FollowButton(
                                            backgroundColor: Colors.blue,
                                            borderColor: Colors.blue,
                                            function: () async {
                                              await FirestoreMethods()
                                                  .followUser(
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                followId: widget.uid,
                                              );
                                              setState(() {
                                                isFolowing = true;
                                                followers++;
                                              });
                                            },
                                            text: 'Follow',
                                            textColor: Colors.white,
                                          )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 15),
                        child: Text(
                          user?.username ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          user?.bio ?? '',
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      height: 200,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var snap = snapshot.data!.docs[index];
                          return Container(
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                snap['postUrl'],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
