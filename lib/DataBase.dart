import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newlogin/Homepage.dart';
import 'package:newlogin/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'image.dart';
import 'sql_helper.dart';

class sql extends StatefulWidget {
  const sql({Key? key}) : super(key: key);

  @override
  _sqlState createState() => _sqlState();
}

class _sqlState extends State<sql> {
  // All journals
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

  TextEditingController _userPasswordController = TextEditingController();
  TextEditingController _confrimPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastname_Controller = TextEditingController();
  TextEditingController mobile_Controller = TextEditingController();
  TextEditingController addrT = TextEditingController();

  String selectedURL = "";
  var _image;
  var imagePicker;
  var type;
  var _image0;
  List<dynamic> imagelist = [];

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    _refreshJournals(); // Loading the diary when the app starts
  }

  ScrollController mainLAYcontroler = ScrollController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
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
                controller: mainLAYcontroler,
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
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(color: Colors.red[200]),
                          child: _image != null
                              ? Image.file(
                                  _image,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.fitHeight,
                                )
                              : Container(
                                  decoration:
                                      BoxDecoration(color: Colors.red[200]),
                                  width: 200,
                                  height: 200,
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
                          await updateItem(id);
                        }
                        // print(_updateItem(id));
                        // Clear the text fields
                        // _titleController.text = '';
                        // _descriptionController.text = '';
                        // _image = null;

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    ),
                  ],
                ),
              ),
            ));
  }

// Insert a new journal to the database
  // Future<void> _addItem() async {
  //   await SQLHelper.createItem(
  //       _titleController.text, _descriptionController.text, selectedURL);
  //   _refreshJournals();
  // }

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

// Homepage.userdata[0]['date'].toString(),
  // Delete an item
  void _deleteItem(int id) async {
    Pref.logindata = await SharedPreferences.getInstance();
    String newuser = (Pref.logindata.getString('rej') ?? '');
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.red[200]),
                      child: _journals[index]['image'] != null
                          ? Image.file(
                              File(_journals[index]['image']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.fitHeight,
                            )
                          : Container(
                              decoration: BoxDecoration(color: Colors.red[200]),
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                    Expanded(
                        child: Row(
                      children: [],
                    )),
                    Text(_journals[index]['firstname']),
                    Text(_journals[index]['lastname']),
                    Text(_journals[index]['password']),
                    Text(_journals[index]['address']),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_journals[index]['id']),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
