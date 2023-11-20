import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late FocusNode _captionFocusNode;
  bool hasFocus = false;

  late final TextEditingController _descriptionController;

  Uint8List? _image;

  bool _isLoading = false;

  Future<void> postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _image!,
        uid,
        username,
        profImage,
      );

      if (res == 'Success' && context.mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Posted')));
        clearImage();
        _descriptionController.clear();
        _captionFocusNode.unfocus();
        hasFocus = false;
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      }
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  void initState() {
    super.initState();

    _captionFocusNode = FocusNode();
    _descriptionController = TextEditingController();

    _captionFocusNode.addListener(() {
      if (_captionFocusNode.hasFocus) {
        setState(() {
          hasFocus = true;
        });
      } else {
        setState(() {
          hasFocus = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _captionFocusNode.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;
    return _image == null
        ? Center(
            child: IconButton(
              onPressed: () async {
                Uint8List? image = await selectImage(context);
                if (image != null) {
                  setState(() {
                    _image = image;
                  });
                }
              },
              icon: const Icon(Icons.upload),
            ),
          )
        : GestureDetector(
            onTap: () {
              print('gesture click');
              _captionFocusNode.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: clearImage,
                ),
                title: const Text('Post to'),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      postImage(
                        user.uid,
                        user.username,
                        user.photoUrl,
                      );
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              body: Column(
                children: [
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: _isLoading ? const LinearProgressIndicator() : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          focusNode: _captionFocusNode,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none,
                          ),
                          maxLines: hasFocus ? 8 : 1,
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(_image!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  // Expanded(
                  //   child: Center(
                  //     child: AbsorbPointer(
                  //       absorbing: false,
                  //       child: IconButton(
                  //         onPressed: () {
                  //           print('upload');
                  //         },
                  //         icon: Icon(Icons.upload),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          );
  }
}
