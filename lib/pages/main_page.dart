import 'dart:convert';

import 'package:dating_app/models/user.dart';
import 'package:dating_app/pages/details_page.dart';
import 'package:dating_app/pages/user_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<User> _user;

  @override
  void initState() {
    super.initState();
    _user = _generateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almost Tinder'),
      ),
      body: Center(
        child: FutureBuilder<User>(
            future: _user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'avatar',
                        child: Image.network(
                          snapshot.data.image,
                          fit: BoxFit.fill,
                          height: 300,
                          width: 300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          snapshot.data.name,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      UserButtons(
                        onReload: () {
                          setState(() {
                            _user = _generateUser();
                          });
                        },
                        onNext: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(user: snapshot.data),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text(
                    'Something is wrong. Check your internet connection. :-(');
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Future<User> _generateUser() async {
    final uri = Uri.https('randomuser.me', '/api/1.3');
    final response = await http.get(uri);
    return compute(_parseUser, response.body);
  }

  static User _parseUser(String response) {
    final Map<String, dynamic> parsed = json.decode(response);
    return User.fromRandomUserResponse(parsed);
  }
}
