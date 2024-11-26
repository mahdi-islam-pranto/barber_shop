import 'dart:async';

import 'package:barber_shop/resources/colors.dart';
import 'package:barber_shop/screens/homepage.dart';
import 'package:barber_shop/screens/onboardingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Stack(children: [
        Center(
          child: Image.asset('assets/images/shop.png',
              height: 100, width: 100, fit: BoxFit.cover),
        ),
        //
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: TextButton(
                    onPressed: () {
                      var url = Uri.parse("https://ihelpbd.com");
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Design & development by ',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: "Mahd Islam Pranto",
                          style: TextStyle(
                            color: buttonColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}

class SplashServices {
  void isLogin(BuildContext context) {
    //user already logged in or not
    //firebase init
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

// user logged in
    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      });
    } else {
      // user not logged in
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
        );
      });
    }
  }
}
