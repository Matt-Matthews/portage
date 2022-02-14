//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:portage/screens/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {
  Register({
    Key key,
  }) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _contact = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _confpassword = TextEditingController();

  String errorMsg = "";
  String name;
  String surname;
  String contact;
  String password;
  String email;
  String confpassword;
  List customers = [];
  List user = [];

  addData() async {
    name = _firstname.text;
    surname = _lastname.text;
    contact = _contact.text;
    password = _password.text;
    email = _email.text;
    confpassword = _confpassword.text;
    Map customer;
    bool userExist = false;
    await Firestore.instance
        .collection('customer')
        .where('email', isEqualTo: email.trim())
        .getDocuments()
        .then((snapshot) {
      setState(() {
        customer = snapshot.documents[0].data;
      });
      if (customer.isNotEmpty) {
        userExist = true;
      }
    }).catchError((error) => setState(() {
              //errorMsg = error.toString();
              userExist = false;
            }));

    if (password != confpassword || userExist == true) {
      setState(() {
        errorMsg = 'password don`t match or User Exist!';
      });
    } else {
      Map<String, dynamic> regData = {
        "firstname": "$name",
        "lastname": "$surname",
        "contact": "$contact",
        "password": "$password",
        "email": "$email"
      };

      CollectionReference collectionReference =
          Firestore.instance.collection('customer');
      collectionReference.add(regData).then((_) => _showDialog());
    }
  }

  Future<void> _showDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Successful'),
            content: SingleChildScrollView(
              child: Text('Your account is created successfully.'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              )
            ],
          );
        });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validate() {
    if (formKey.currentState.validate()) {
      addData();
    } else {
      print('not validated');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firstname.dispose();
    _lastname.dispose();
    _contact.dispose();
    _email.dispose();
    _password.dispose();
    _confpassword.dispose();
  }

  Widget build(BuildContext context) {
    var _size = 20.0;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Container(
            //width: 360.0,
            //height: 640.0,
            //background
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
          Transform.translate(
            //left big circle
            offset: Offset(-90.0, 700.0),
            child: Container(
              width: 181.0,
              height: 165.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xff0c1a43),
              ),
            ),
          ),
          SafeArea(
            //offset: Offset(26.0, 290.0),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 100,
                left: 25,
              ),
              child: Column(
                children: [
                  Container(
                    width: 115.0,
                    height: 128.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            const AssetImage('lib/assets/images/portage.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20,
                        color: const Color(0xffc85609),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    //autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        Container(
                          width: 360.0,
                          height: 40.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.person,
                                color: const Color(0xffd47b3f),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                height: 40,
                                margin: EdgeInsets.only(top: 19),
                                child: TextFormField(
                                  style:
                                      TextStyle(color: const Color(0xffd47b3f)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Firstname",
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: _firstname,
                                  validator:
                                      RequiredValidator(errorText: 'requred'),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                        ),
                        SizedBox(height: _size),
                        Container(
                          width: 360.0,
                          height: 40.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.person,
                                color: const Color(0xffd47b3f),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                height: 40,
                                margin: EdgeInsets.only(top: 19),
                                child: TextFormField(
                                  style:
                                      TextStyle(color: const Color(0xffd47b3f)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Lastname",
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: _lastname,
                                  validator:
                                      RequiredValidator(errorText: 'requred'),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                        ),
                        SizedBox(height: _size),
                        Container(
                          width: 360.0,
                          height: 40.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.phone,
                                color: const Color(0xffd47b3f),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                height: 40,
                                margin: EdgeInsets.only(top: 19),
                                child: TextFormField(
                                  style:
                                      TextStyle(color: const Color(0xffd47b3f)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Contact",
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: _contact,
                                   keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'requred'),
                                    MinLengthValidator(10,
                                        errorText: 'invalid contact number'),
                                    MaxLengthValidator(10,
                                        errorText: 'invalid contact number'),
                                  ]),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                        ),
                        SizedBox(height: _size),
                        Container(
                          width: 360.0,
                          height: 40.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.mail,
                                color: const Color(0xffd47b3f),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 250,
                                height: 40,
                                margin: EdgeInsets.only(top: 19),
                                child: TextFormField(
                                  style:
                                      TextStyle(color: const Color(0xffd47b3f)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Email",
                                  ),
                                  textInputAction: TextInputAction.next,
                                  controller: _email,
                                  validator: MultiValidator([
                                    EmailValidator(
                                        errorText: 'Not a valid email'),
                                    RequiredValidator(errorText: 'requred')
                                  ]),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                        ),
                        SizedBox(height: _size),
                        Container(
                          width: 360.0,
                          height: 40.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.lock,
                                color: const Color(0xffd47b3f),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                height: 40,
                                margin: EdgeInsets.only(top: 19),
                                child: TextFormField(
                                  style:
                                      TextStyle(color: const Color(0xffd47b3f)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Create Password",
                                  ),
                                  obscureText: true,
                                  textInputAction: TextInputAction.next,
                                  controller: _password,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'requred'),
                                    MinLengthValidator(4,
                                        errorText:
                                            'should be atleast 4 characters')
                                  ]),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                        ),
                        SizedBox(height: _size),
                        Container(
                          width: 360.0,
                          height: 40.0,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.lock,
                                color: const Color(0xffd47b3f),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                height: 40,
                                margin: EdgeInsets.only(top: 19),
                                child: TextFormField(
                                  style:
                                      TextStyle(color: const Color(0xffd47b3f)),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Confirm Password",
                                  ),
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  controller: _confpassword,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'requred'),
                                    MinLengthValidator(4,
                                        errorText:
                                            'should be atleast 4 characters')
                                  ]),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    errorMsg,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 14,
                      color: const Color(0xffd47b3f),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: validate, //addData,
                    child: Container(
                        width: 160,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xff0c1a43),
                          border: Border.all(color: const Color(0xffd47b3f)),
                        ),
                        child: Center(
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: const Color(0xffd47b3f),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
                        color: const Color(0xffd47b3f),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ),
          Transform.translate(
            //left small circle
            offset: Offset(58.0, 690.0),
            child: Container(
              width: 55.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xff0c1a43),
              ),
            ),
          ),
          Transform.translate(
            //right top circle
            offset: Offset(300.0, -87.0),
            child: Container(
              width: 189.0,
              height: 190.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xff0c1a43),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(330.0, 35.0),
            child: Text(
              'Sign up',
              style: TextStyle(
                fontFamily: 'Rockwell',
                fontSize: 20,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(38.5, 298.5),
          ),
        ],
      ),
    );
  }
}
