import 'package:barber_shop/components/shopOverview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopNearYou extends StatelessWidget {
  const ShopNearYou({super.key});

  @override
  Widget build(BuildContext context) {
    // get current user data
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('BarberShops')
            .doc(user?.uid)
            .collection('shops')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                height: MediaQuery.of(context).size.height / 5.2,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return // all shops each
                          // put shop data from the database here
                          Row(
                        children: [
                          ShopOverview(
                            shopName: '${snapshot.data?.docs[index]['name']}',
                            location:
                                "${snapshot.data?.docs[index]['address']}",
                            rating: "${snapshot.data?.docs[index]['rating']}",
                            imagePath:
                                "${snapshot.data?.docs[index]['images'][0]}", // get the first image
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      );
                    }));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
