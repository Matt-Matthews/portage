import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:geocoder/geocoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portage/models/customer.dart';
//import 'package:geoflutterfire/geoflutterfire.dart' as geoF;
import 'package:portage/models/driver.dart';
//import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:paystack_manager/paystack_pay_manager.dart';

class HomePage extends StatefulWidget with NavigationStates {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  Position currentPosition;
  final Set<Polyline> _polyline = {};
  List<LatLng> routeCoord = [];
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: 'AIzaSyCzUsXvK6ij9EhZIjtFO_0eBJQ8h_7GSXA');

  LatLng loc = LatLng(-23.847885, 29.381333);
  LatLng des = LatLng(-23.846552, 29.382345);

  void addPolyline(LatLng desloc) async {
    Position pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng _latling = LatLng(pos.latitude, pos.longitude);
    routeCoord = await googleMapPolyline.getCoordinatesWithLocation(
        origin: _latling, destination: desloc, mode: RouteMode.driving);
    setState(() {
      _polyline.add(Polyline(
        polylineId: PolylineId('route'),
        visible: true,
        points: routeCoord,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
      ));
    });
  }

  void locatePosition() async {
    currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng latlinPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlinPosition, zoom: 16);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    final coordinates =
        new Coordinates(currentPosition.latitude, currentPosition.longitude);
    var placemark =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = placemark.first;
    print("${first.featureName} : ${first.addressLine}");
    _fromAddress.text = first.addressLine.toString();
  }

  //ByteData _carMarker;
  Set<Marker> _markers = {};
  Future<Uint8List> _marker(String path, int width) async {
    ByteData _carMarker = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        _carMarker.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
    //BitmapDescriptor.fromAssetImage(
    //ImageConfiguration(), 'lib/assets/images/car.png');
  }

  //LatLng _newpos = LatLng(-23.847885, 29.381333);
  void _addMarker() async {
    //final geo = geoF.Geoflutterfire();
    Map driver;
    // ignore: await_only_futures
    Firestore.instance
        .collection('delivery')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        driver = snapshot.documents[0].data;
        Driver.name = driver['driver'].toString();
      });
    });
    /*await Firestore.instance
        .collection('delivery')
        .where('status', isEqualTo: 'approved')
        .getDocuments()
        .then((snapshot) {
      setState(() {
        driver = snapshot.documents[0].data;
        Driver.name = driver['driver'];
      });
    });*/
    //List em;
    Map bm;
    String _lat;
    String _long;
    double lat;
    double long;
    LatLng pos;
    /*await Firestore.instance
        .collection('driverlocation')
        .where('drivername', isEqualTo: Driver.name)
        .getDocuments()
        .then((snapshot) {
      setState(() {
        bm = snapshot.documents[0].data;
        _lat = bm['latitude'].toString();
        _long = bm['longitude'].toString();
        lat = double.parse(_lat);
        long = double.parse(_long);
        pos = LatLng(lat, long);
      });
    });*/

    Firestore.instance
        .collection('driverlocation')
        .where('drivername', isEqualTo: Driver.name)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        bm = snapshot.documents[0].data;
        _lat = bm['latitude'].toString();
        _long = bm['longitude'].toString();
        lat = double.parse(_lat);
        long = double.parse(_long);
        pos = LatLng(lat, long);
      });
    });

    print('marker added');
    Uint8List _carM = await _marker('lib/assets/images/car.png', 25);
    this.setState(() {
      _markers.add(Marker(
        markerId: MarkerId('driver'),
        position: pos,
        //rotation: pos.heading,
        zIndex: 2,
        icon: BitmapDescriptor.fromBytes(_carM),
      ));
    });
    //addPolyline(_newpos);
  }

  void _addDesMarker() async {
    //String address = '1-35 39th Ave, Seshego-B, Polokwane, 0742';
    var placemark =
        await Geocoder.local.findAddressesFromQuery(_toAddress.text);
    var first = placemark.first;
    print("${first.featureName} : ${first.coordinates}");

    LatLng _latling =
        LatLng(first.coordinates.latitude, first.coordinates.longitude);

    //LatLng(currentPosition.latitude, currentPosition.longitude);
    Uint8List _carM = await _marker('lib/assets/images/pin.png', 25);
    this.setState(() {
      _markers.add(Marker(
        markerId: MarkerId('destination'),
        position: _latling,
        //rotation: currentPosition.heading,
        zIndex: 2,
        icon: BitmapDescriptor.fromBytes(_carM),
      ));
    });
    addPolyline(_latling);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    locatePosition();

    //_addMarker();
    //addPolyline();
  }

  String payType = 'Cash';
  String payError;
  void _confirm() async {
    if (payType == 'Cash') {
      sendRequest();
    } else {
      try {
        PaystackPayManager(context: context)
          ..setSecretKey("sk_live_8199d079f126c98cd888a465dcdef88777394819")
          ..setCompanyAssetImage(Image(
            image: const AssetImage('lib/assets/images/portage.png'),
          ))
          ..setAmount(20000)
          ..setReference(DateTime.now().millisecondsSinceEpoch.toString())
          ..setCurrency("ZAR")
          ..setEmail("mathewspaku@gmail.com")
          ..setFirstName("Mathews")
          ..setLastName("Paku")
          ..setMetadata(
            {
              "custom_fields": [
                {
                  "value": "Portage",
                  "display_name": "Payment_to",
                  "variable_name": "Payment_to"
                }
              ]
            },
          )
          ..onSuccesful(sendRequest)
          ..onPending(sendRequest)
          ..onFailed(_onPaymentFailed)
          ..onCancel(_onCancel)
          ..initialize();
      } catch (error) {
        print('Payment Error ==> $error');
      }
    }
  }

  _onPaymentFailed() {
    print("payment failed");
  }

  _onCancel() {
    print('canceled');
  }

  sendRequest() {
    Map<String, dynamic> reqData = {
      "to": _toAddress.text,
      "from": _fromAddress.text,
      "notes": _notes.text,
      "status": "Pending",
      "payType": payType,
      "price": "R200",
      "name": Customer.name,
      "contact": Customer.contact,
      "email": Customer.email,
      "driver": "Pending",
      "driverPhone": "Pending",
      "driveremail": "Pending"
    };
    CollectionReference collectionReference =
        Firestore.instance.collection('delivery');
    collectionReference.add(reqData);
    _showDialog();
  }

  Future<void> _showDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Successful'),
            content: SingleChildScrollView(
              child: Text(
                  'Your request has been sent and will be attended very soon.'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  final _toAddress = TextEditingController();
  final _fromAddress = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _toAddress.dispose();
    _fromAddress.dispose();
    _notes.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: true,
            markers: _markers,
            polylines: _polyline,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          Transform.translate(
              offset: Offset(50.0, 20.0),
              child: Container(
                  width: 350.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xffd47b3f)),
                  ),
                  child: Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    /* Icon(
                      Icons.location_on,
                      color: const Color(0xffd47b3f),
                    ),
                    SizedBox(
                      width: 10,
                    ),*/
                    Container(
                      width: 300,
                      height: 40,
                      margin: EdgeInsets.only(top: 5),
                      child: TextField(
                        style: TextStyle(
                            fontSize: 13, color: const Color(0xffd47b3f)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Where to",
                          icon: Icon(
                            Icons.location_on,
                            color: const Color(0xffd47b3f),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        controller: _toAddress,
                      ),
                    ),
                    SizedBox(
                      width: 1,
                      height: 25,
                      child: Container(
                        color: const Color(0xffd47b3f),
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                        child: GestureDetector(
                      onTap: _addDesMarker,
                      child: Icon(
                        Icons.search,
                        color: const Color(0xffd47b3f),
                      ),
                    ))
                  ]))),
          Transform.translate(
              offset: Offset(340.0, 730.0),
              child: Container(
                child: FloatingActionButton(
                  onPressed: _addMarker,
                  backgroundColor: const Color(0xff0c1a43),
                  heroTag: "btn 2",
                  child: Icon(Icons.emoji_transportation,
                      color: const Color(0xffd47b3f)),
                ),
              )),
          Transform.translate(
              offset: Offset(340.0, 660.0),
              child: Container(
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (_isClose) {
                        _width = 360;
                        _height = 310;
                        _icon =
                            Icon(Icons.close, color: const Color(0xffd47b3f));
                        _isClose = false;
                      } else {
                        _width = 0;
                        _height = 0;
                        _icon = Icon(Icons.add, color: const Color(0xffd47b3f));
                        _isClose = true;
                      }
                    });
                  },
                  backgroundColor: const Color(0xff0c1a43),
                  child: _icon,
                  heroTag: "btn 1",
                ),
              )),
          Transform.translate(
              offset: Offset(30.0, 340.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 20),
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffd47b3f)),
                ),
                child: Column(children: [
                  SizedBox(height: 10),
                  Container(
                    width: 340.0,
                    height: 40.0,
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        Container(
                          width: 330,
                          height: 40,
                          //margin: EdgeInsets.only(top: 19),
                          child: TextField(
                            style: TextStyle(
                                fontSize: 13, color: const Color(0xffd47b3f)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "From:",
                              icon: Icon(
                                Icons.location_on,
                                color: const Color(0xffd47b3f),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            controller: _fromAddress,
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
                    height: 40.0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 330,
                          height: 40,
                          //margin: EdgeInsets.only(top: 19),
                          child: TextField(
                            style: TextStyle(
                                fontSize: 13, color: const Color(0xffd47b3f)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "TO:",
                              icon: Icon(
                                Icons.location_on,
                                color: const Color(0xffd47b3f),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            controller: _toAddress,
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
                    height: 100.0,
                    //padding: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          width: 285,
                          //height: 40,
                          //margin: EdgeInsets.only(top: 19),
                          child: TextField(
                            style: TextStyle(
                                fontSize: 13, color: const Color(0xffd47b3f)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Notes",
                            ),
                            textInputAction: TextInputAction.done,
                            controller: _notes,
                            maxLines: 10,
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
                  Row(
                    children: [
                      RadioButtonGroup(
                        orientation: GroupedButtonsOrientation.HORIZONTAL,
                        labels: ["Cash", "Online"],
                        onSelected: (String selected) => setState(() {
                          _picked = selected;
                          print(_picked.toString());
                          payType = _picked.toString();
                        }),
                        picked: _picked,
                        itemBuilder: (Radio rb, Text txt, int i) {
                          return Row(
                            children: [rb, txt],
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 20,
                        width: 1,
                        color: Color(0xffd47b3f),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 20,
                        width: 1,
                        color: Color(0xffd47b3f),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Text('R200'),
                      )
                    ],
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
                        onTap: _confirm,
                        child: Center(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              color: const Color(0xffd47b3f),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )),
                  ),
                ]),
              ))
        ],
      ),
    ));
  }

  bool _isClose = true;
  Icon _icon = Icon(Icons.add, color: const Color(0xffd47b3f));
  String _picked = 'Cash';
  double _width = 0;
  double _height = 0;
}
