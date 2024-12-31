import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';
import '../screens/userShopDetails.dart';
import 'shopOverview.dart';

class UserShopNearYou extends StatefulWidget {
  const UserShopNearYou({super.key});

  @override
  State<UserShopNearYou> createState() => _UserShopNearYouState();
}

class _UserShopNearYouState extends State<UserShopNearYou> {
  // inistate

  @override
  Widget build(BuildContext context) {
    // get all shops near you from the database and display them

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collectionGroup('shops').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: textColor,
              ),
            );
          }

          // Handle empty data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No shops available'),
            );
          }
          print("database data shops: ${snapshot.data?.docs.length}");
          return Container(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            height: MediaQuery.of(context).size.height / 5.2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var shopData = snapshot.data?.docs[index];
                  var images = shopData?['images'] as List?;
                  return // all shops each
                      // put shop data from the database here
                      Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // go to shop details page
                          // pass shop data to shop details page
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserShopDetails(
                                shopData:
                                    shopData?.data() as Map<String, dynamic>);
                          }));
                        },
                        child: ShopOverview(
                          imagePath: images == null
                              ? "assets/images/shop.png"
                              : images[0],
                          shopName: shopData?['name'] ?? 'Shop Name',
                          rating: shopData?['rating'] ?? '4.8',
                          location: shopData?['address'] ?? 'Shop Address',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                }),
          );
        });
  }
}
