import 'dart:math';

import 'package:barber_shop/Auth/fire_auth_services.dart';
import 'package:barber_shop/components/shopNearYou.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Auth/loginPage.dart';
import '../components/servicesSection.dart';
import '../resources/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            // welcome section
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    debugPrint('########## User Logged Out');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                  child: const CircleAvatar(
                    radius: 28,
                  ),
                ),
                const SizedBox(width: 20),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome", style: TextStyle(fontSize: 15)),
                    Text("Mahdi Islam Pranto",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: primaryColor,
                    ))
              ],
            ),

            Divider(
              height: 30,
              color: primaryColor,
              thickness: 0.2,
              indent: 0,
            ),

            const SizedBox(height: 10),

            // Services Section

            const Align(
                alignment: Alignment.centerLeft,
                child: Text("SERVICES",
                    style:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),

            const SizedBox(height: 20),
            // all services
            const ServicesSection(),

            const SizedBox(height: 40),

            // best Shops near you section

            const Align(
                alignment: Alignment.centerLeft,
                child: Text("BEST SHOPS NEAR YOU",
                    style:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),

            const ShopNearYou(),

            const SizedBox(height: 40),

            // book Appointment section

            const Align(
                alignment: Alignment.centerLeft,
                child: Text("BOOK AN APPOINTMENT",
                    style:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
