import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';

class FAQ extends StatefulWidget with NavigationStates {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final _email = TextEditingController();
  final _note = TextEditingController();
  String email;
  String notes;
  String msg = '';
  sendFaq() {
    email = _email.text;
    notes = _note.text;
    Map<String, dynamic> faqData = {"email": "$email", "note": "$notes"};

    CollectionReference collectionReference =
        Firestore.instance.collection('faq');
    collectionReference.add(faqData);

    setState(() {
      msg = "Your FAQ will be attended as soon as possible.";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _note.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
          height: 615,
          child: Column(
            children: [
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
                          borderRadius: BorderRadius.all(
                              Radius.elliptical(9999.0, 9999.0)),
                          color: const Color(0xff0c1a43),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(320.0, 10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'FAQ',
                          style: TextStyle(
                              fontSize: 25,
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
              Container(
                width: 340.0,
                height: 40.0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.email,
                      color: const Color(0xffd47b3f),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      margin: EdgeInsets.only(top: 19),
                      child: TextField(
                        style: TextStyle(color: const Color(0xffd47b3f)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "email",
                        ),
                        textInputAction: TextInputAction.done,
                        controller: _email,
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
                width: 340.0,
                height: 200.0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 120),
                        child: Icon(
                          Icons.edit,
                          color: const Color(0xffd47b3f),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      margin: EdgeInsets.only(top: 19),
                      child: TextField(
                        style: TextStyle(color: const Color(0xffd47b3f)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Notes",
                        ),
                        textInputAction: TextInputAction.done,
                        controller: _note,
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
              SizedBox(
                height: 50,
              ),
              Container(
                child: Text(
                  msg,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14,
                    color: const Color(0xffd47b3f),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
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
                    onTap: sendFaq,
                    child: Center(
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 18,
                          color: const Color(0xffd47b3f),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )),
              ),
            ],
          ),
        ))));
  }
}
