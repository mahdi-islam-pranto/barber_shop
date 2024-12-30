import 'package:flutter/material.dart';

import '../resources/colors.dart';

class ShopOverview extends StatelessWidget {
  final String shopName;
  final String location;
  final String rating;
  final String imagePath;
  const ShopOverview(
      {super.key,
      required this.shopName,
      required this.location,
      required this.rating,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // circle avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: buttonColor,
            child: ClipOval(
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                width: 56,
                height: 56,
              ),
            ),
          ),

          // shop name, location, reviwes text

          const SizedBox(
            height: 3,
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 3.5, // make width 120

            child: Text(shopName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14)),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 3.5, // make width 120
            child: Text(location,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 13, color: Colors.white30)),
          ),

          const SizedBox(
            height: 3,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(rating, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
