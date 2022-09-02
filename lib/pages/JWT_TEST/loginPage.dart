import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'jwt.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(text),
              ));

  Future<String?> attemptLogIn(String username, String password) async {
    var result = await post(
        Uri.parse(
            "http://expenditure-tracker-server.eba-pxkuudy7.eu-west-2.elasticbeanstalk.com/auth/token"),
        body: {
          'name': username,
          'id': password,
        });

    if (result.statusCode == 200) {
      print(result.body);
      return result.body;
    }
    ;
    return null;
  }

  Future<int> attemptSignup(String username, String password) async {
    var result = await post(
        Uri.parse(
            "https://expenditure-tracker-backend.thescienceset.com/users"),
        body: {
          'name': username,
          'id': password,
        });
    return result.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Log In"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                var name = _usernameController.text;
                var password = _passwordController.text;

                var jwt = await attemptLogIn(name, password);
                if (jwt != null) {
                  //TODO: DELETE
                  print('jwt');
                  print(jwt);
                  //

                  storage.write(key: "jwt", value: jwt);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage.fromBase64(jwt),
                      ));
                } else {
                  displayDialog(context, 'An error occurred',
                      'No account was found matching the username and password');
                }
              },
              child: const Text(
                "Log In",
              )),
          ElevatedButton(
              onPressed: () async {
                var name = _usernameController.text;
                var password = _passwordController.text;

                if (name.length < 4) {
                  displayDialog(
                      context, "Invalid username", "The username is too short");
                } else if (password.length < 4) {
                  displayDialog(context, "Invalid Password",
                      "The password should be at least 4 characters long");
                } else {
                  var result = await attemptSignup(name, password);
                  if (result == 201) {
                    displayDialog(
                        context, "Success", "The User was created. Log in now");
                  } else if (result == 409) {
                    displayDialog(
                        context,
                        "That username is already registered",
                        'Please try to sign up using another username or log in if you already have an account.');
                  } else {
                    displayDialog(context, "Error", "An error has occurred");
                  }
                }
              },
              child: const Text("Sign Up")),
        ],
      ),
    );
  }
}

// HOMEPAGE

class HomePage extends StatelessWidget {
  const HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(ascii.decode /* OR utf8.decode */ (
          base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data screen'),
      ),
      body: Center(
        child: FutureBuilder(
            future: read(
                Uri.parse(
                    "https://expenditure-tracker-backend.thescienceset.com/users"),
                headers: {"Authorization": jwt}),
            builder: (context, snapshot) => snapshot.hasData
                ? Column(
                    children: <Widget>[
                      Text("${payload['name']}, heres the data:"),
                      Text(
                        snapshot.data
                            as String, /* style: Theme.of(context).textTheme.display1 */
                      )
                    ],
                  )
                : snapshot.hasError
                    ? const Text("An error occurred")
                    : const CircularProgressIndicator()),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Authentication demo',
        theme: ThemeData(primarySwatch: Colors.amber),
        home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            if (snapshot.data != "") {
              String str = snapshot.data as String;
              var jwt = str.split(".");

              if (jwt.length != 3) {
                return LoginPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return HomePage(str, payload);
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          },
        ));
  }
}
