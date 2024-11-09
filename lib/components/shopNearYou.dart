import 'package:flutter/material.dart';

import '../resources/colors.dart';

class ShopNearYou extends StatelessWidget {
  const ShopNearYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // all shops each
            Column(
              children: [
                // circle avatar
                CircleAvatar(
                  radius: 38,
                  backgroundColor: buttonColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/shop.png",
                        ),
                      ),
                    ],
                  ),
                ),

                // shop name, location, reviwes text

                const SizedBox(
                  height: 3,
                ),

                const Text("Look Change Saloon",
                    style: TextStyle(fontSize: 16)),

                const Text("Mohammadpur, Dhaka",
                    style: TextStyle(fontSize: 14, color: Colors.white30)),

                const SizedBox(
                  height: 3,
                ),

                const Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text("4.5", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),

            // all shops each
            Column(
              children: [
                // circle avatar
                CircleAvatar(
                  radius: 38,
                  backgroundColor: buttonColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/images/shop.png",
                        ),
                      ),
                    ],
                  ),
                ),

                // shop name, location, reviwes text

                const SizedBox(
                  height: 3,
                ),

                const Text("Trim Haircut", style: TextStyle(fontSize: 16)),

                const Text("Dhanmondi, Dhaka",
                    style: TextStyle(fontSize: 14, color: Colors.white30)),

                const SizedBox(
                  height: 3,
                ),

                const Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text("4.3", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
