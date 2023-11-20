import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../resources/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await AuthMethods().signInUser(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print(res);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.code)));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: size.width > webScreenSize
              ? EdgeInsets.symmetric(horizontal: size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
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
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
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
                    InkWell(
                      splashColor: Colors.red,
                      radius: 20,
                      onTap: _isLoading ? null : signInUser,
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
                        child: SizedBox(
                          height: 20,
                          child: _isLoading
                              ? const FittedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Log in'),
                        ),
                      ),
                    ),
                  ],
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
                    child: const Text('Don\'t have an account?'),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Sign up',
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


//--------------- SingleChildScrollView


// child: Scrollbar(
//             thumbVisibility: true,
//             child: SingleChildScrollView(
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top -
//                     kToolbarHeight,
//                 // - 34, << risi height-ia?
//                 child: Column(
//                   children: [
//                     Flexible(
//                       flex: 1,
//                       child: Container(),
//                     ),
//                     SvgPicture.asset(
//                       'assets/images/ic_instagram.svg',
//                       height: 64,
//                       colorFilter:
//                           const ColorFilter.mode(primaryColor, BlendMode.srcIn),
//                     ),
//                     const SizedBox(height: 64),
//                     TextFieldInput(
//                       hintText: 'Enter your email',
//                       textEditingController: _emailController,
//                       textInputType: TextInputType.emailAddress,
//                     ),
//                     const SizedBox(height: 25),
//                     TextFieldInput(
//                       hintText: 'Enter your password',
//                       textEditingController: _passwordController,
//                       textInputType: TextInputType.text,
//                       isPass: true,
//                     ),
//                     const SizedBox(height: 25),
//                     Flexible(
//                       flex: 1,
//                       child: Container(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )