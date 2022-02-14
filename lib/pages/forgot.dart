import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portage/screens/Login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _confpassword = TextEditingController();

  String errorMsg = '';
  bool userExist;
  String userid;

  updatePassword() async {
    Map customer;
    await Firestore.instance
        .collection('customer')
        .where('email', isEqualTo: _email.text.trim())
        .getDocuments()
        .then((snapshot) {
      setState(() {
        customer = snapshot.documents[0].data;
        userid = snapshot.documents[0].documentID;
      });
      if (customer.isNotEmpty) {
        userExist = true;
      }
    }).catchError((error) => setState(() {
              errorMsg = 'No account found';
              userExist = false;
            }));

    if (userExist == true && _password.text == _confpassword.text) {
      Firestore.instance
          .collection('delivery')
          .document(userid)
          .updateData({"password": _password.text}).then((_) => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login())));
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void validate() {
    if (formKey.currentState.validate()) {
      updatePassword();
      print('validated');
    } else {
      print('not validated');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _confpassword.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
      Container(
        width: 500.0,
        height: 190.0,
        child: Stack(
          children: [
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
              offset: Offset(280.0, 10.0),
              child: Container(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  'Reset \npassword',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffd47b3f)),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(20.0, 180.0),
              child: Container(
                height: 0.5,
                width: 380,
                color: Color(0xffd47b3f),
              ),
            )
          ],
        ),
      ),
      Form(
        key: formKey,
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
                      ),
                      textInputAction: TextInputAction.next,
                      controller: _email,
                      validator: MultiValidator([
                        EmailValidator(errorText: 'Not a valid email'),
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
            SizedBox(height: 10),
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
                        hintText: "Create Password",
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
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
            SizedBox(height: 10),
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
                        hintText: "Confirm Password",
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      controller: _confpassword,
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
          ],
        ),
      ),
      SizedBox(height: 15),
      Text(
        errorMsg,
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 14,
          color: const Color(0xffd47b3f),
        ),
        textAlign: TextAlign.left,
      ),
      SizedBox(height: 40),
      GestureDetector(
        onTap: validate,
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
                'Reset',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 18,
                  color: const Color(0xffd47b3f),
                ),
                textAlign: TextAlign.left,
              ),
            )),
      ),
    ]))));
  }
}
