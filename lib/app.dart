// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:newlogin/DataBAse.dart';
import 'package:newlogin/DataBase.dart';
import 'package:newlogin/Homepage.dart';
import 'package:newlogin/Loginpage.dart';
import 'package:newlogin/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'regi.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: Container(
          child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                    child: Text(
                      'Data Base',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => sql(),
                          ));
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'User LogIn',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () async {
                      Pref.logindata = await SharedPreferences.getInstance();
                      String newuser = (Pref.logindata.getString('rej') ?? '');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => newuser == ""
                                ? Singup()
                                : newuser == "0"
                                    ? LoginPage()
                                    : Homepage(),
                          ));
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
