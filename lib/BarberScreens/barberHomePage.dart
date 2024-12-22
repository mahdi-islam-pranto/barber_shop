import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../components/popUpMenuItems.dart';

import '../components/shopNearYou.dart';
import '../resources/colors.dart';
import 'addShopForm.dart';

class Barberhomepage extends StatefulWidget {
  const Barberhomepage({super.key});

  @override
  State<Barberhomepage> createState() => _BarberhomepageState();
}

// get current user data
FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;

String? email = user?.email;
String? name = user?.displayName;
String? photoUrl = user?.photoURL;
String? uid = user?.uid;

class _BarberhomepageState extends State<Barberhomepage> {
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
                              const Text("Welcome Barber!",
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

            // Added Barber Shops near you section

            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("MY BARBER SHOPS",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(boxColor),
                      ),
                      onPressed: () {
                        // navigate to add shop form screen
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AddShopForm();
                        }));
                      },
                      child: Text("ADD SHOP",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                          )),
                    ),
                  ],
                )),

            const ShopNearYou(),

            const SizedBox(height: 40),

            // My added services

            const Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("MY SERVICES",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                )),

            const SizedBox(
              height: 40,
            ),

            // booked appointments
            const Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("BOOKED APPOINTMENTS",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
