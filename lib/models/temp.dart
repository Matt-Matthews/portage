import 'package:cloud_firestore/cloud_firestore.dart';

addData() {
  Map<String, dynamic> regData = {"firstname": "matthew", "lastname": "matt"};
  CollectionReference collectionReference =
      Firestore.instance.collection('customer');
  collectionReference.add(regData);
}

List customer;
fetchData() {
  CollectionReference collectionReference =
      Firestore.instance.collection('customer');
  collectionReference.snapshots().listen((snapshot) async {
    // setState(() {
    customer = snapshot.documents;
    //});
  });
}
