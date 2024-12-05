import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/Auth/loginPage.dart';
import 'package:barber_shop/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../screens/homepage.dart';

import 'dart:developer' as developer;

class PopOverMenuItems extends StatelessWidget {
  const PopOverMenuItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("User Profile",
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(userData["name"],
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(userData["email"],
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                  Text(
                      "Phone: ${userData["phone"] == 'null' ? "N/A" : userData["phone"]}",
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 14,
                      )),

                  /// logout button
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      onPressed: () {
                        try {
                          // logout user
                          FirebaseAuth.instance.signOut();
                          developer.log("User Logged Out");
                          print("############# User Logged Out");

                          FirebaseAuth.instance.userChanges().listen((user) {
                            if (user == null) {
                              developer.log("User Logged Out");
                              print("############# User Logged Out");
                            }
                          });
                          // navigate to login page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                          // show success message
                          AnimatedSnackBar.material(
                            'User Logged Out',
                            type: AnimatedSnackBarType.success,
                            duration: const Duration(seconds: 3),
                            mobileSnackBarPosition: MobileSnackBarPosition.top,
                          ).show(context);
                        } catch (e) {
                          print("Error:" + e.toString());
                        }
                      })
                ],
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("user",
                      maxLines: 1,
                      softWrap: false,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ],
              );
            }
          }),
    );
  }
}
