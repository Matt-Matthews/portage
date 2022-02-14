import 'package:flutter/material.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';

class Settings extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
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
                          'Settings',
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
              Text('Settings')
            ],
          ),
        ));
  }
}
