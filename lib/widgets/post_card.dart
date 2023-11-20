import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  int commentLength = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      setState(() {
        commentLength = snap.docs.length;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user =
        Provider.of<UserProvider>(context, listen: false).getUser;
    final size = MediaQuery.of(context).size;

    return user == null
        ? const CardLoading(
            height: 526,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            margin: EdgeInsets.only(bottom: 10),
          )
        : Container(
            // color: mobileBackgroundColor,
            decoration: BoxDecoration(
              border: Border.all(
                  color: size.width > webScreenSize
                      ? secondaryColor
                      : mobileBackgroundColor),
              color: mobileBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(widget.snap['profImage']),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map((e) => InkWell(
                                            onTap: () {
                                              FirestoreMethods().deletePost(
                                                  widget.snap['postId']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 16,
                                              ),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );

                    if ((widget.snap['likes'] as List).contains(user.uid)) {
                      setState(() {
                        isLikeAnimating = true;
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Image.network(
                          widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: isLikeAnimating ? 1 : 0,
                        duration: const Duration(milliseconds: 400),
                        child: LikeAnimation(
                          isAnimating: isLikeAnimating,
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          duration: const Duration(milliseconds: 400),
                          child: const Icon(
                            Icons.favorite,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating:
                          (widget.snap['likes'] as List).contains(user.uid),
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                            widget.snap['postId'],
                            user.uid,
                            widget.snap['likes'],
                          );
                        },
                        icon: (widget.snap['likes'] as List).contains(user.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                  builder: (context) => CommentsScreen(
                                        snap: widget.snap,
                                      )),
                            )
                            .then((value) => getComments());
                      },
                      icon: const Icon(Icons.comment_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_border),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.snap['likes'].length} likes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['description']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'View all ${commentLength} comments',
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          DateFormat.yMMMd().format(
                              (widget.snap['datePublished'] as Timestamp)
                                  .toDate()),
                          style: const TextStyle(
                            fontSize: 16,
                            color: secondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
