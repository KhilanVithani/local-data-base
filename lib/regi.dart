// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newlogin/pref.dart';
import 'package:newlogin/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Homepage.dart';
import 'LoginPage.dart';
import 'image.dart';

class registration extends StatefulWidget {
  const registration({Key? key}) : super(key: key);

  @override
  State<registration> createState() => _registrationState();
}

enum SingingCharacter { Male, Female }

class _registrationState extends State<registration> {
  bool buttonB = false;

  String selectedURL = '';
  var _image;
  var imagePicker;
  var type;
  int addINT = 0;
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;
  TextEditingController addrT = TextEditingController();
  ScrollController mainLAYcontroler = ScrollController();
  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _confrimPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastname_Controller = TextEditingController();
  TextEditingController mobile_Controller = TextEditingController();

  String date = "";
  String dayS = "", months = "", years = "";
  DateTime selectedDate = DateTime.now();
  List errorcheck = ['0', '0', '0', '0', '0', '0', '0'];
  SingingCharacter? _character = SingingCharacter.Male;
  void initState() {
    _passwordVisible = false;
    _passwordVisible1 = false;
    imagePicker = new ImagePicker();
    check_if_already_login();
  }

  String newuser = '';

  void check_if_already_login() async {
    Pref.logindata = await SharedPreferences.getInstance();
    newuser = (Pref.logindata.getString('rej') ?? '');
    print(newuser);
    if (newuser == '1') {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Homepage()));
    } else if (newuser == '0') {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Container(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: mainLAYcontroler,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
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
                      // Pref.logindata.setString('image', image.path.toString());
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
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: errorcheck[0] == "1"
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        labelText: 'First Name',
                        hintText: 'Enter Fisrt Name',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: lastname_Controller,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: errorcheck[1] == "1"
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        labelText: 'Last Name',
                        hintText: 'Enter Last Name',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: mobile_Controller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: errorcheck[2] == "1"
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        labelText: 'Mobile',
                        hintText: 'Enter Mobile Number',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _userPasswordController,
                      obscureText:
                          !_passwordVisible, //This will obscure text dynamically
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: errorcheck[3] == "1"
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _confrimPasswordController,
                      obscureText:
                          !_passwordVisible1, //This will obscure text dynamically
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: errorcheck[4] == "1"
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your confirm password',
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible1
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible1 = !_passwordVisible1;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _openDatePicker(context);
                  },
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Container(
                        color: errorcheck[5] == "1" ? Colors.red : Colors.blue,
                        child: Center(
                          child: Text(
                            date,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Male"),
                      Radio<SingingCharacter>(
                        value: SingingCharacter.Male,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      Text("Female"),
                      Radio<SingingCharacter>(
                        value: SingingCharacter.Female,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      inputFormatters: [LengthLimitingTextInputFormatter(40)],
                      controller: addrT,
                      onChanged: (val) {
                        setState(() {
                          String v1 = addrT.text;
                          addINT = v1.length;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: errorcheck[6] == "1"
                                  ? Colors.red
                                  : Colors.black),
                        ),
                        hintText: 'Enter Address',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            addINT.toString(),
                            style: TextStyle(
                                color:
                                    addINT == 40 ? Colors.red : Colors.black),
                          ),
                          Text(
                            "/40",
                            style: TextStyle(
                                color:
                                    addINT == 40 ? Colors.red : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () async {
                    errorcheck = ['0', '0', '0', '0', '0', '0', '0'];
                    String username = usernameController.text;
                    String lastname = lastname_Controller.text;
                    String password = _userPasswordController.text;
                    String Conpass = _confrimPasswordController.text;
                    String Address = addrT.text;
                    String mobile = mobile_Controller.text;
                    if (username != '' &&
                        lastname != '' &&
                        password != '' &&
                        Conpass != '' &&
                        Address != '' &&
                        selectedURL != '' &&
                        date != '' &&
                        password == Conpass &&
                        mobile != '') {
                      print('Successfull');
                      Pref.logindata.setString('rej', '0');

                      await _addItem();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      String error = "";
                      if (username == '') {
                        setState(() {
                          errorcheck[0] = '1';
                        });

                        error = error + "Username";
                      }
                      if (lastname == '') {
                        setState(() {
                          errorcheck[1] = '1';
                        });
                        error = error + " lastname";
                      }
                      if (mobile == '') {
                        setState(() {
                          errorcheck[2] = '1';
                        });
                        error = error + " Mobile";
                      }
                      if (password == '') {
                        setState(() {
                          errorcheck[3] = '1';
                        });
                        error = error + " password";
                      }
                      if (Conpass == '') {
                        setState(() {
                          errorcheck[4] = '1';
                        });
                        error = error + " ConfirmPassword";
                      }
                      if (date == '') {
                        setState(() {
                          errorcheck[5] = '1';
                        });
                        error = error + " Date";
                      }
                      if (Address == '') {
                        setState(() {
                          errorcheck[6] = '1';
                        });
                        error = error + " Address";
                      }
                      if (selectedURL == '') {
                        error = error + " Image";
                      }
                      if (password != Conpass) {
                        error = error + " Password must be same as above";
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error),
                      ));
                    }
                  },
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      title: 'Set your Birthday',
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.blue,
      ),
      onChange: (index) {
        print(index);
        setState(() {
          date = index.toString();
          var parts = date.split(' ');
          date = parts[0].trim();
        });
      },
      onSubmit: (index) {
        print(index);
        setState(() {
          date = index.toString();

          var parts = date.split(' ');
          date = parts[0].trim();
        });
      },
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
    ).show(context);
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        selectedURL,
        usernameController.text,
        lastname_Controller.text,
        mobile_Controller.text,
        _userPasswordController.text,
        date,
        addrT.text);
    _refreshJournals();
  }
}
