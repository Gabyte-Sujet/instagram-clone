import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          size > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: size > webScreenSize
          ? null
          : AppBar(
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                colorFilter:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                height: 32,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.messenger_outline),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: size > webScreenSize ? size * 0.3 : 0,
                vertical: size > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                key: ValueKey(snapshot.data!.docs[index]['postId']),
                snap: snapshot.data!.docs[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
