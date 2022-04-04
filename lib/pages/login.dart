import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenWidth = 0;
  double screenHeight = 0;

  Color primary = const Color.fromARGB(253, 233, 163, 51);
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            isKeyboardVisible
                ? SizedBox(
                    height: screenHeight / 20,
                  )
                : Container(
                    height: screenHeight / 3,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(70),
                        )),
                    child: Center(
                        child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth / 5,
                    )),
                  ),
            //Login text
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 15,
                bottom: screenHeight / 20,
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: screenWidth / 18,
                  fontFamily: "NexaBold",
                ),
              ),
            ),

            //
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth / 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Employee username text
                  FieldTitle(
                    screenWidth: screenWidth,
                    title: 'Employee Username',
                  ),
                  //Employee ID textfield
                  CustomField(
                    screenWidth: screenWidth,
                    primary: primary,
                    screenHeight: screenHeight,
                    hint: 'Enter your username',
                    controller: idController,
                    obscure: false,
                  ),
                  //Employee password text

                  FieldTitle(
                    screenWidth: screenWidth,
                    title: 'Password',
                  ),
                  //Employee password textfield
                  CustomField(
                    screenWidth: screenWidth,
                    primary: primary,
                    screenHeight: screenHeight,
                    hint: 'Enter your password',
                    controller: passController,
                    obscure: true,
                  ),

                  //LOGIN BUTTON
                  GestureDetector(
                    onTap: () async {
                      String id = idController.text.trim();
                      String password = passController.text.trim();

                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection('Adimn')
                          .where('id', isEqualTo: id)
                          .get();

                      print(snap.docs[0]);
                    },
                    child: Container(
                      height: 60,
                      width: screenWidth,
                      margin: EdgeInsets.only(
                        top: screenHeight / 40,
                      ),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          )),
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontFamily: 'NexaBold',
                            fontSize: screenWidth / 26,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class CustomField extends StatelessWidget {
  const CustomField({
    Key? key,
    required this.screenWidth,
    required this.primary,
    required this.screenHeight,
    required this.hint,
    required this.controller,
    required this.obscure,
  }) : super(key: key);

  final double screenWidth;
  final Color primary;
  final double screenHeight;
  final TextEditingController controller;
  final bool obscure;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 50),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ]),

      //Textfield Row
      child: Row(children: [
        Container(
          width: screenWidth / 6,
          child: Icon(
            Icons.person,
            color: primary,
            size: screenWidth / 15,
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(right: screenWidth / 13),
          child: TextFormField(
              controller: controller,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight / 40,
                ),
                border: InputBorder.none,
                hintText: hint,
              ),
              maxLines: 1,
              obscureText: obscure),
        ))
      ]),
    );
  }
}

class FieldTitle extends StatelessWidget {
  const FieldTitle({
    Key? key,
    required this.screenWidth,
    required this.title,
  }) : super(key: key);

  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }
}
