import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:portage/models/customer.dart';

class MyOrdersPage extends StatefulWidget with NavigationStates {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrdersPage> {
  Customer user = Customer();
  String id;
  Future<void> _showDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel request'),
            content: SingleChildScrollView(
              child: Text('Do you want to cancel the request?'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Firestore.instance
                      .collection('delivery')
                      .document(id)
                      .updateData({"status": "Canceled"});
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> _showDeleteDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete'),
            content: SingleChildScrollView(
              child: Text('Do you want to Delete the request?'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Firestore.instance
                      .collection('delivery')
                      .document(id)
                      .delete();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
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
                      offset: Offset(280.0, 10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Deliveries',
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
              Container(
                height: 615,
                width: 385,
                padding: EdgeInsets.only(left: 5),
                //color: Colors.red,
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('delivery')
                        .where('email', isEqualTo: Customer.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null)
                        return CircularProgressIndicator();
                      final List<DocumentSnapshot> docs =
                          snapshot.data.documents;

                      return ListView(
                          children: docs
                              .map((doc) => Card(
                                    child: ListTile(
                                      title: Text(
                                        'Status: ' + doc['status'],
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      subtitle: Text('From: ' +
                                          doc['from'] +
                                          '\nTo: ' +
                                          doc['to'] +
                                          '\nDriver: ' +
                                          doc['driver'] +
                                          '\nDriver Contact :' +
                                          doc['driverPhone'] +
                                          '\nPrice: ' +
                                          doc['price']),
                                      onLongPress: () {
                                        setState(() {
                                          id = doc.documentID.toString();
                                        });
                                        _showDeleteDialog();
                                      },
                                      onTap: () {
                                        if (doc['status'] != 'Delivered') {
                                          setState(() {
                                            id = doc.documentID.toString();
                                          });
                                          _showDialog();
                                        }
                                      },
                                    ),
                                  ))
                              .toList());
                    },
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
