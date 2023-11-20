import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
// import 'package:instagram_clone/utils/global_variables.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  final int x = 2;

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _itemIndex = 0;
  late PageController _pageController;

  String? uidForProfile;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController(initialPage: 4);
    _pageController = PageController();

    _pageController.addListener(() {
      int currentPage = _pageController.page?.round() ?? 0;
      setState(() {
        _itemIndex = currentPage;
      });
    });
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

  BottomNavigationBarItem bottomNavBarItem({required IconData icon}) {
    return BottomNavigationBarItem(
      label: '',
      icon: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // scrollDirection: Axis.vertical,
        // physics: NeverScrollableScrollPhysics(),

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
      bottomNavigationBar: SafeArea(
        child: CupertinoTabBar(
          height: kToolbarHeight,
          backgroundColor: mobileBackgroundColor,
          activeColor: primaryColor,
          inactiveColor: secondaryColor,
          currentIndex: _itemIndex,
          onTap: navigationTapped,
          items: [
            bottomNavBarItem(icon: Icons.home),
            bottomNavBarItem(icon: Icons.search),
            bottomNavBarItem(icon: Icons.add_circle),
            bottomNavBarItem(icon: Icons.favorite),
            bottomNavBarItem(icon: Icons.person),
          ],
        ),
      ),
    );
  }
}
