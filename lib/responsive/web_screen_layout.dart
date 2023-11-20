import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _itemIndex = 0;
  late PageController _pageController;

  String? uidForProfile;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController(initialPage: 4);
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    setState(() {
      _itemIndex = page;
    });
    _pageController.jumpToPage(page);
    // _pageController.animateToPage(page,
    //     duration: Duration(seconds: 1), curve: Curves.bounceOut);
  }

  void goToProfile(String uid) {
    _pageController.jumpToPage(4);
    setState(() {
      _itemIndex = 4;
      uidForProfile = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigationTapped(0);
            },
            icon: Icon(
              Icons.home,
              color: _itemIndex == 0 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(1);
            },
            icon: Icon(
              Icons.search,
              color: _itemIndex == 1 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(2);
            },
            icon: Icon(
              Icons.add_circle,
              color: _itemIndex == 2 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(3);
            },
            icon: Icon(
              Icons.favorite,
              color: _itemIndex == 3 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigationTapped(4);
            },
            icon: Icon(
              Icons.person,
              color: _itemIndex == 4 ? primaryColor : secondaryColor,
            ),
          ),
        ],
      ),
      body: PageView(
        // scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        // children: homeScreenItems,
        children: [
          const FeedScreen(),
          SearchScreen(goToProfile: goToProfile),
          const AddPostScreen(),
          const Text('fav'),
          ProfileScreen(
            uid: uidForProfile,
          ),
        ],
      ),
    );
  }
}
