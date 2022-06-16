// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newlogin/LoginPage.dart';
import 'package:newlogin/pref.dart';
import 'package:newlogin/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'image.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  static List<Map<String, dynamic>> userdata = [];

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  // This function is used to fetch all data from the database
  // void _refreshJournals() async {
  //   final data = await SQLHelper.getItems();
  //   setState(() {
  //     _journals = data;
  //     _isLoading = false;
  //   });
  // }

  ScrollController mainLAYcontroler = ScrollController();
  String Firstname = '';
  String Lastname = '';
  String Mobile = '';
  String Password = '';
  String Date = '';
  String Address = '';
  var _image0;

  @override
  void initState() {
    // Pref.logindata = await SharedPreferences.getInstance();
    Firstname = (Pref.logindata.getString('username') ?? '');
    Lastname = (Pref.logindata.getString('lastname') ?? '');
    Mobile = (Pref.logindata.getString('mobile') ?? '');
    Password = (Pref.logindata.getString('password') ?? '');
    Date = (Pref.logindata.getString('date') ?? '');
    Address = (Pref.logindata.getString('Address') ?? '');
    _image0 = File((Pref.logindata.getString('image') ?? ''));
    super.initState();
    imagePicker = ImagePicker();
    // _refreshJournals();
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController lastname_Controller = TextEditingController();
  TextEditingController mobile_Controller = TextEditingController();
  TextEditingController addrT = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();

  String selectedURL = "";
  var _image;
  var imagePicker;
  var type;
  List<Map<String, dynamic>> logindatalist = [];

  List<dynamic> imagelist = [];
  void setdata(String mobile) async {
    final data = await SQLHelper.getdate(mobile);
    Pref.logindata = await SharedPreferences.getInstance();
    logindatalist = data;
    setState(() {
      print(logindatalist.toString());
    });
    if (logindatalist.isNotEmpty) {
      setState(() {
        Pref.logindata.remove('username');
        Pref.logindata.remove('lastname');
        Pref.logindata.remove('address');
        Pref.logindata.remove('image');
        Pref.logindata.setString('username', logindatalist[0]['firstname']);
        Pref.logindata.setString('lastname', logindatalist[0]['lastname']);
        Pref.logindata.setString('address', logindatalist[0]['address']);
        Pref.logindata.setString('image', logindatalist[0]['image']);
      });
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  ScrollController mainLAYcontroler1 = ScrollController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item

    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: mainLAYcontroler1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          var source = type == ImageSourceType.camera
                              ? ImageSource.camera
                              : ImageSource.gallery;
                          XFile image = await imagePicker.pickImage(
                              source: source,
                              imageQuality: 50,
                              preferredCameraDevice: CameraDevice.front);
                          setState(() {
                            _image = File(image.path);
                            selectedURL = image.path.toString();
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: _image != null
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fitHeight,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[200],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(hintText: 'Firstname'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: lastname_Controller,
                      decoration: const InputDecoration(hintText: 'Lastname'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: mobile_Controller,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _userPasswordController,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: addrT,
                      decoration: const InputDecoration(hintText: 'Adderss'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Save new journal

                        if (id != null) {
                          await updateItem(0);
                        }
                        setdata(Mobile);

                        // print(_updateItem(id));
                        // Clear the text fields
                        // _titleController.text = '';
                        // _descriptionController.text = '';
                        // _image = null;
                        // print(_updateItem(0));
                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ));
  }

  // Update an existing journal
  Future<void> updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        selectedURL,
        usernameController.text,
        lastname_Controller.text,
        mobile_Controller.text,
        _userPasswordController.text,
        'date',
        addrT.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Center(
        child: Container(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image0 != null
                    ? Image.file(
                        _image0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.red[200]),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
            Text(
              "First Name: " + Firstname,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Last Name: " + Lastname,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "MObile Number: " + Mobile,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Password: " + Password,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Date of Birth: " + Date,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Address: " + Address,
              style: TextStyle(fontSize: 20),
            ),
          ]),
        ),
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                        Firstname,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(Mobile),
                    ),
                  ],
                ),
              )),
          FlatButton(
            child: Text(
              'Log Out',
              style: TextStyle(fontSize: 20.0),
            ),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Pref.logindata.remove('username');
              Pref.logindata.remove('lastname');
              Pref.logindata.remove('mobile');
              Pref.logindata.remove('password');
              Pref.logindata.remove('date');
              Pref.logindata.remove('Address');
              Pref.logindata.remove('image');
              Pref.logindata.setString('rej', '0');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
