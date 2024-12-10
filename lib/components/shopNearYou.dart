import 'package:barber_shop/components/shopOverview.dart';
import 'package:flutter/material.dart';

class ShopNearYou extends StatelessWidget {
  const ShopNearYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        height: MediaQuery.of(context).size.height / 5.2,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const <Widget>[
            // all shops each
            ShopOverview(
              shopName: 'Look Change Saloon',
              location: "Mohammadpur, Dhaka",
              rating: "4.5",
              imagePath: "assets/images/shop.png",
            ),
            SizedBox(width: 20),

            ShopOverview(
              shopName: 'Trim Haircut',
              location: "Dhanmondi, Dhaka",
              rating: "4.5",
              imagePath: "assets/images/shop.png",
            ),

            SizedBox(width: 20),

            ShopOverview(
              shopName: 'Diamond Saloon',
              location: "Uttra, Dhaka",
              rating: "4.4",
              imagePath: "assets/images/shop.png",
            ),

            SizedBox(width: 20),

            ShopOverview(
              shopName: 'Trim Haircut',
              location: "Dhanmondi, Dhaka",
              rating: "4.5",
              imagePath: "assets/images/shop.png",
            ),
            SizedBox(width: 20),
          ],
        ));
  }
}
