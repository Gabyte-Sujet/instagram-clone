import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
    required this.goToProfile,
  }) : super(key: key);

  final Function(String uid) goToProfile;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _fieldController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _userName = ' ';
  bool _isShowUser = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(
      () {
        if (_searchFocus.hasFocus) {
          setState(() {
            _isShowUser = true;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocus.dispose();
    _fieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchFocus.unfocus();
        setState(() {
          _isShowUser = false;
          _fieldController.text = '';
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            focusNode: _searchFocus,
            controller: _fieldController,
            decoration: const InputDecoration(labelText: 'Search for a user'),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _userName = ' ';
                });
              } else {
                setState(() {
                  _userName = value;
                });
              }
            },
            onFieldSubmitted: (String _) {
              setState(() {
                _isShowUser = true;
              });
            },
          ),
        ),
        body: _isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: _userName)
                    .where('username', isLessThanOrEqualTo: '$_userName\uf8ff')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // widget.goToProfile(
                              //     snapshot.data!.docs[index]['uid']);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      uid: snapshot.data!.docs[index]['uid'])));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data!.docs[index]['photoUrl']),
                              ),
                              title:
                                  Text(snapshot.data!.docs[index]['username']),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }

                  return MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        snapshot.data!.docs[index]['postUrl'],
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
