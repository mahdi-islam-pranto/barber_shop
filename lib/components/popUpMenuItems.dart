import 'package:barber_shop/Auth/loginPage.dart';
import 'package:barber_shop/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Auth/fire_auth_services.dart';

class PopOverMenuItems extends StatelessWidget {
  const PopOverMenuItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user data inside the build method
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user?.uid;

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
                      onPressed: () async {
                        try {
                          // Use the centralized signOut method
                          await FireAuthServices().signOut(context);

                          // navigate to login page and remove all previous routes
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
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
