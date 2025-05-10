import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../components/popUpMenuItems.dart';
import '../components/servicesSection.dart';
import '../components/userShopNearYou.dart';
import '../resources/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Move user data to instance variables
  late FirebaseAuth auth;
  User? user;
  String? email;
  String? name;
  String? photoUrl;
  String? uid;

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  // Method to refresh user data
  void _refreshUserData() {
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    email = user?.email;
    name = user?.displayName;
    photoUrl = user?.photoURL;
    uid = user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    // Refresh user data on each build
    _refreshUserData();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            // welcome section
            Row(
              children: [
                // user image

                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      // open pop up dialog
                      showPopover(
                        context: context,
                        bodyBuilder: (context) => const PopOverMenuItems(),
                        onPop: () => print('Popover was popped!'),
                        direction: PopoverDirection.bottom,
                        backgroundColor: Color(0xff2F3646),
                        width: 250,
                        height: 200,
                        arrowHeight: 15,
                        arrowWidth: 20,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: backGroundColor,
                      radius: 25,
                      backgroundImage: photoUrl == null
                          ? const AssetImage("assets/images/user.png")
                          : NetworkImage(user!.photoURL.toString()),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // get current user data from firestore
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        // print('user name: ${userData["name"]}');
                        // print('user email: ${userData["email"]}');
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Welcome!",
                                  style: TextStyle(fontSize: 15)),
                              Text(userData["name"],
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        );
                      } else {
                        return const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome!", style: TextStyle(fontSize: 15)),
                              Text("user",
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        );
                      }
                    }),

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("BEST SHOPS NEAR YOU",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("SEE ALL",
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  ],
                )),

            const UserShopNearYou(),

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
