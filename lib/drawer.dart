// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newlogin/Homepage.dart';
import 'package:newlogin/pref.dart';

// import 'package:flutter/src/widgets/navigator.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var _image0 = File((Pref.logindata.getString('image') ?? ''));
  // late String username;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          // const UserAccountsDrawerHeader(
          //   accountName: Text("Khilan Vitthani"),
          //   accountEmail: Text("khilanvithani0080@gmail.com"),
          //   currentAccountPicture: CircleAvatar(
          //     backgroundImage: NetworkImage(
          //         "https://pps.whatsapp.net/v/t61.24694-24/263210993_667131344377435_2392515720000556256_n.jpg?ccb=11-4&oh=adfe400cdc3bc15c61c1d413037e36cb&oe=6292CD81"),
          //   ),
          // ),
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(color: Colors.red[200]),
                        child: _image0 != null
                            ? Image.file(
                                _image0,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(
                                decoration:
                                    BoxDecoration(color: Colors.red[200]),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        Homepage.userdata[0]['firstname'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(Homepage.userdata[0]['mobile']),
                    ),
                    FlatButton(
                      child: Text(
                        'Log Out',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
