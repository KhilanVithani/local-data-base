import 'package:flutter/material.dart';
import 'package:newlogin/app.dart';
import 'package:newlogin/pref.dart';
import 'package:newlogin/regi.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Pref.logindata = await SharedPreferences.getInstance();
  runApp(const MaterialApp(
    title: "great app",
    home: App(),
    //theme: ThemeData(primarySwatch: Colors.cyan),
    // routes: {
    //   "/Login": (context) => const LoginPage(),
    //   "/Home": (context) => HomePage()
    // },
    themeMode: ThemeMode.dark,
  ));
}
