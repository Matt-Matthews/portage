//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:portage/screens/Register.dart';
// ignore: unused_import
import 'package:portage/sidebar/sidebar_layout.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
//import 'package:firebase_auth/firebase_auth.dart';

//import './AndroidMobile4.dart';
import 'package:portage/models/customer.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:portage/pages/forgot.dart';

class Login extends StatefulWidget {
  Login({
    Key key,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String errorMsg = '';
  String email;
  String password;
  Customer user = Customer();
  void loginData() async {
    Map customer;
    bool isValid = false;
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      await Firestore.instance
          .collection('customer')
          .where('email', isEqualTo: _email.text)
          .getDocuments()
          .then((snapshot) {
        setState(() {
          customer = snapshot.documents[0].data;
          Customer.name = customer['firstname'].toString().trim();
          Customer.surname = customer['lastname'].toString().trim();
          Customer.contact = customer['contact'].toString().trim();
          Customer.password = customer['password'].toString().trim();
          Customer.email = customer['email'].toString().trim();
        });
        email = customer['email'].toString().trim();
        password = customer['password'].toString().trim();
        print(customer['email'].toString());
        print(password);
      }).catchError((error) => setState(() {
                errorMsg = 'invalid email or password';
              }));
      if (email == _email.text.trim() && password == _password.text.trim()) {
        isValid = true;

        //print(_password.text);
      } else if (email != _email.text && password != _password.text) {
        isValid = false;
      }
    }
    if (isValid == true) {
      errorMsg = 'Loading please wait....';
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SideBarLayout()));
    } else {
      setState(() {
        errorMsg = 'invalid email or password';
      });
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validate() {
    if (formKey.currentState.validate()) {
      loginData();
    } else {
      print('not validated');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Widget build(BuildContext context) {
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
            offset: Offset(150.0, 78.0),
            child:
                // Adobe XD layer: 'portage' (shape)
                Container(
              width: 115.0,
              height: 128.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('lib/assets/images/portage.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(135.0, 220.0),
            child: Text(
              'Welcome back',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xffc85609),
              ),
              textAlign: TextAlign.left,
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
          Transform.translate(
              //Text field 1
              offset: Offset(26.0, 290.0),
              child: Form(
                  key: formKey,
                  //autovalidateMode: AutovalidateMode.always,
                  child: Column(children: [
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
                              style: TextStyle(color: const Color(0xffd47b3f)),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Email",
                                //errorText: emailValidator(_email.text),
                              ),
                              textInputAction: TextInputAction.next,
                              controller: _email,
                              validator: MultiValidator([
                                EmailValidator(errorText: 'Not a valid email'),
                                RequiredValidator(errorText: 'requred')
                              ]),

                              //onSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
                    SizedBox(height: 50),
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
                              style: TextStyle(color: const Color(0xffd47b3f)),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Password",
                                //errorText: passwordValidator(_password.text)
                              ),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              controller: _password,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'requred'),
                                MinLengthValidator(4,
                                    errorText: 'should be atleast 4 characters')
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
                  ]))),
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
            offset: Offset(115.0, 450.0),
            child: Container(
                child: Text(
              errorMsg,
              style: TextStyle(color: const Color(0xffd47b3f)),
            )),
          ),
          Transform.translate(
            offset: Offset(125.0, 503.0),
            child: Container(
              width: 160,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xff0c1a43),
                border: Border.all(color: const Color(0xffd47b3f)),
              ),
              child: GestureDetector(
                  onTap: validate,
                  child: Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 18,
                        color: const Color(0xffd47b3f),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )),
            ),
          ),
          Transform.translate(
              offset: Offset(145.0, 570.0),
              child: GestureDetector(
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14,
                    color: const Color(0xffd47b3f),
                  ),
                  textAlign: TextAlign.left,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
              )),
          Transform.translate(
              offset: Offset(153.0, 610.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14,
                    color: const Color(0xffd47b3f),
                  ),
                  textAlign: TextAlign.left,
                ),
              )),
          Transform.translate(
            offset: Offset(330.0, 35.0),
            child: Text(
              'Sign in',
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
