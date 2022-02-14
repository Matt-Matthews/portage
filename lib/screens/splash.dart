import 'package:flutter/material.dart';
import 'package:portage/screens/Login.dart';
import 'package:portage/screens/Register.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Container(
              padding: EdgeInsets.only(top: 400, left: 75),
              child: Column(
                children: [
                  Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                              width: 260,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xff0c1a43),
                                border:
                                    Border.all(color: const Color(0xffd47b3f)),
                              ),
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
                              )))),
                  SizedBox(height: 50),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Container(
                          width: 260,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xff0c1a43),
                            border: Border.all(color: const Color(0xffd47b3f)),
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 18,
                                color: const Color(0xffd47b3f),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )),
                    ),
                  )
                ],
              )),
          Transform.translate(
            offset: Offset(130.0, 78.0),
            child:
                // Adobe XD layer: 'portage' (shape)
                Container(
              width: 145.0,
              height: 158.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('lib/assets/images/portage.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(155.0, 240.0),
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
        ],
      ),
    );
  }
}
