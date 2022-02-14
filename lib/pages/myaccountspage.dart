import 'package:flutter/material.dart';
import 'package:portage/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:universal_html/html.dart';
import 'dart:io' as d;
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';

class MyAccountsPage extends StatefulWidget with NavigationStates {
  @override
  _MyAccountsPageState createState() => _MyAccountsPageState();
}

class _MyAccountsPageState extends State<MyAccountsPage> {
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confPassword = TextEditingController();

  d.File _image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = d.File(pickedImage.path);
    });
    
  }

  Future uploadImage(BuildContext contxt) async {
    pickImage();
    String fileName = _image.path.toString();
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = storageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) => print("done: $value"));
  }

  @override
  void dispose() {
    super.dispose();
    _oldPassword.dispose();
    _newPassword.dispose();
    _confPassword.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 30, top: 20),
            child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue[50]),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 140,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: _image != null
                          ? Image.file(_image, height: 50)
                          : Padding(
                              padding: EdgeInsets.only(top: 35, left: 20),
                              child: Text(
                                Customer.name[0] + Customer.surname[0],
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 120, top: 100),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f))),
                        child: GestureDetector(
                          onTap: () => uploadImage(context),
                          child: Icon(
                            Icons.edit,
                            color: Color(0xff0c1a43),
                          ),
                        ),
                      ),
                    )
                  ],
                ))),
        Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Container(
              height: 0.5,
              width: 380,
              color: Color(0xffd47b3f),
            )),
        SizedBox(
          height: 5,
        ),
        Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              padding: EdgeInsets.only(top: 25),
              width: 380,
              height: 150,
              color: Color(0xff0c1a43),
              child: Column(
                children: [
                  Text(Customer.surname + ' ' + Customer.name,
                      style: TextStyle(
                        color: Color(0xffd47b3f),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(Customer.email,
                      style: TextStyle(
                        color: Color(0xffd47b3f),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.3,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(Customer.contact,
                      style: TextStyle(
                        color: Color(0xffd47b3f),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.3,
                      )),
                ],
              ),
            )),
        Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Container(
              height: 0.5,
              width: 380,
              color: Color(0xffd47b3f),
            )),
        SizedBox(
          height: 25,
        ),
        Text("Change password",
            style: TextStyle(
              color: Color(0xffd47b3f),
              fontSize: 15,
              fontWeight: FontWeight.normal,
              letterSpacing: 1.3,
            )),
        SizedBox(height: 5.0),
        Container(
            padding: EdgeInsets.only(right: 270),
            child: Text("Old Password",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffd47b3f),
                ))),
        Container(
          padding: EdgeInsets.only(left: 25),
          child: TextField(
            decoration: InputDecoration(
              hintText: "********",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            textInputAction: TextInputAction.next,
            obscureText: true,
            controller: _oldPassword,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              height: 0.5,
              width: 380,
              color: Color(0xff0c1a43),
            )),
        SizedBox(height: 5.0),
        Container(
            padding: EdgeInsets.only(right: 265),
            child: Text("New Password",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffd47b3f),
                ))),
        Container(
          padding: EdgeInsets.only(left: 25),
          child: TextField(
            decoration: InputDecoration(
              hintText: "********",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            textInputAction: TextInputAction.next,
            obscureText: true,
            controller: _newPassword,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              height: 0.5,
              width: 380,
              color: Color(0xff0c1a43),
            )),
        SizedBox(height: 5.0),
        Container(
            padding: EdgeInsets.only(right: 245),
            child: Text("Retype Password",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xffd47b3f),
                ))),
        Container(
          padding: EdgeInsets.only(left: 25),
          child: TextField(
            decoration: InputDecoration(
              hintText: "********",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            obscureText: true,
            controller: _confPassword,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: Container(
              height: 0.5,
              width: 380,
              color: Color(0xff0c1a43),
            )),
        SizedBox(
          height: 100,
        ),
        Container(
          width: 160,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xff0c1a43),
            border: Border.all(color: const Color(0xffd47b3f)),
          ),
          child: GestureDetector(
              onTap: () {
                if (_oldPassword.text == Customer.password &&
                    _newPassword.text == _confPassword.text) {
                  CollectionReference collectionReference = Firestore.instance
                      .collection('customer')
                      .where('email', isEqualTo: Customer.email);
                  collectionReference
                      .document()
                      .updateData({"password": _newPassword.text});
                }
              },
              child: Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    color: const Color(0xffd47b3f),
                  ),
                  textAlign: TextAlign.left,
                ),
              )),
        ),
      ]))),
    );
  }
}
