import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  // void _selectImage() async {
  //   ImageSource? source = ImageSource.gallery;
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text(
  //         'Choose ImageSource',
  //         textAlign: TextAlign.center,
  //       ),
  //       actionsAlignment: MainAxisAlignment.spaceEvenly,
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.of(context).pop(ImageSource.camera);
  //           },
  //           child: const Text('Camera'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.of(context).pop(ImageSource.gallery);
  //           },
  //           child: const Text('Gallery'),
  //         ),
  //       ],
  //     ),
  //   ).then((value) => source = value);
  //   Uint8List? image = await pickImage(source);
  //   setState(() {
  //     _image = image;
  //   });
  // }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image,
      );

      if (res == 'Success' && context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      } else {
        print(res);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                height: 64,
                colorFilter:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
              const SizedBox(height: 64),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
                          radius: 64,
                        )
                      : const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/3177/3177440.png',
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      // onPressed: _selectImage,
                      onPressed: () async {
                        Uint8List? image = await selectImage(context);
                        if (image != null) {
                          setState(() {
                            _image = image;
                          });
                        }
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              TextFieldInput(
                hintText: 'Enter your username',
                textEditingController: _usernameController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 25),
              TextFieldInput(
                hintText: 'Enter your email',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              TextFieldInput(
                hintText: 'Enter your password',
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 25),
              TextFieldInput(
                hintText: 'Enter your bio',
                textEditingController: _bioController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 25),
              InkWell(
                splashColor: Colors.red,
                radius: 20,
                onTap: _isLoading ? null : signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const FittedBox(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const Text('Sign up'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Do you have an account?'),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
