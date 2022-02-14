import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:portage/models/customer.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:portage/screens/splash.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xff0c1a43),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      ListTile(
                        title: Text(
                          Customer.name + " " + Customer.surname,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          Customer.email,
                          style: TextStyle(
                            color: const Color(0xffd47b3f),
                            fontSize: 15,
                          ),
                        ),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: const Color(0xffd47b3f).withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                      Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            child: Container(
                              child: Row(children: [
                                Icon(
                                  Icons.home,
                                  color: const Color(0xffd47b3f),
                                  size: 35,
                                ),
                                SizedBox(width: 20),
                                Text('Home',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.HomePageClickedEvent);
                            },
                          )),
                      SizedBox(height: 10),
                      Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            child: Container(
                              child: Row(children: [
                                Icon(
                                  Icons.person,
                                  color: const Color(0xffd47b3f),
                                  size: 35,
                                ),
                                SizedBox(width: 20),
                                Text('Account',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyAccountClickedEvent);
                            },
                          )),
                      SizedBox(height: 10),
                      Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            child: Container(
                              child: Row(children: [
                                Icon(
                                  Icons.emoji_transportation,
                                  color: const Color(0xffd47b3f),
                                  size: 35,
                                ),
                                SizedBox(width: 20),
                                Text('Deliveries',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyOrdersClickedEvent);
                            },
                          )),
                      SizedBox(height: 10),
                      Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            child: Container(
                              child: Row(children: [
                                Icon(
                                  Icons.message,
                                  color: const Color(0xffd47b3f),
                                  size: 35,
                                ),
                                SizedBox(width: 20),
                                Text('FAQ',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.FAQClickedEvent);
                            },
                          )),
                      Divider(
                        height: 54,
                        thickness: 0.5,
                        color: const Color(0xffd47b3f).withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                      Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            child: Container(
                              child: Row(children: [
                                Icon(
                                  Icons.settings,
                                  color: const Color(0xffd47b3f),
                                  size: 35,
                                ),
                                SizedBox(width: 20),
                                Text('Settings',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.SettingsClickedEvent);
                            },
                          )),
                      SizedBox(height: 10),
                      Container(
                          height: 40,
                          padding: EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            child: Container(
                              child: Row(children: [
                                Icon(
                                  Icons.logout,
                                  color: const Color(0xffd47b3f),
                                  size: 35,
                                ),
                                SizedBox(width: 20),
                                Text('Logout',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ]),
                            ),
                            onTap: () {
                              onIconPressed();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SplashScreen()),
                                  ModalRoute.withName("/"));
                            },
                          )),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xff0c1a43),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Color(0xffd47b3f),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
