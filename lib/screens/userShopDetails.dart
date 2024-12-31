import 'package:flutter/material.dart';

class UserShopDetails extends StatefulWidget {
  final Map<String, dynamic> shopData;
  const UserShopDetails({super.key, required this.shopData});

  @override
  State<UserShopDetails> createState() => _UserShopDetailsState();
}

// get shop data from the database based on the Map shopData

class _UserShopDetailsState extends State<UserShopDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // get shop name from the database

        title: Text(widget.shopData['name']),
      ),
    );
  }
}
