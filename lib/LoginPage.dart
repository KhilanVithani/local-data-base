import 'package:flutter/material.dart';
import 'package:newlogin/Homepage.dart';
import 'package:newlogin/pref.dart';
import 'package:newlogin/regi.dart';
import 'package:newlogin/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:core';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool buttonB = false;
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  final email_controller = TextEditingController();
  String viewdata = "";
  String _errorMessage = '';
  List<Map<String, dynamic>> logindatalist = [];

  late bool newuser;

  void getdata(String mobile, String pass) async {
    final data = await SQLHelper.selectLogin(mobile, pass);
    Pref.logindata = await SharedPreferences.getInstance();
    logindatalist = data;
    setState(() {
      print(logindatalist.toString());
    });

    if (logindatalist.isNotEmpty) {
      setState(() {
        Homepage.userdata = logindatalist;
        Pref.logindata.setString('username', logindatalist[0]['firstname']);
        Pref.logindata.setString('lastname', logindatalist[0]['lastname']);
        Pref.logindata.setString('password', logindatalist[0]['password']);
        Pref.logindata.setString('Address', logindatalist[0]['address']);
        Pref.logindata.setString('image', logindatalist[0]['image']);
        Pref.logindata.setString('date', logindatalist[0]['date']);
        Pref.logindata.setString('mobile', logindatalist[0]['mobile']);
        Pref.logindata.setString('rej', '1');
      });
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      print('Halo nikalo');
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void check_if_already_login() async {
    // Pref.logindata = await SharedPreferences.getInstance();
    // newuser = (Pref.logindata.getBool('login') ?? true);
    // print(newuser);
    // if (newuser == false) {
    //   Navigator.pushReplacement(
    //       context, new MaterialPageRoute(builder: (context) => HomePage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
      // screenHeight = MediaQuery.of(context).size.height;
      // screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              image: const DecorationImage(
                  image: AssetImage('assets/images/bg.jpeg'),
                  fit: BoxFit.cover,
                  opacity: 0.10),
              // shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: username_controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'User Name',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: password_controller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
                Text(viewdata),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: InkWell(
                    onTap: () {
                      String username = username_controller.text;
                      String password = password_controller.text;
                      String email = email_controller.text;
                      if (username != '' && password != '') {
                        getdata(username, password);
                      }
                    },
                    child: Material(
                      elevation: buttonB ? 2 : 10,
                      borderRadius: BorderRadius.circular(5),
                      color: buttonB
                          ? const Color.fromRGBO(0, 188, 212, 1)
                          : const Color.fromARGB(255, 0, 72, 82),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Log In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have Account?"),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Singup()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.cyan, fontSize: 18),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
