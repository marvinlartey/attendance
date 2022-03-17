import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  Color primary = const Color.fromARGB(253, 233, 163, 51);
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      children: [
        Container(
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
              FieldTitle(screenWidth: screenWidth, title: 'Employee Username'),
              //Employee ID textfield
              Container(
                width: screenWidth,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                      child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight / 40,
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter your username')))
                ]),
              )
            ],
          ),
        ),
      ],
    ));
  }
}

class FieldTitle extends StatelessWidget {
  const FieldTitle({Key? key, required this.screenWidth, required this.title})
      : super(key: key);

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
