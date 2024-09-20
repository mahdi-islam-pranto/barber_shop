import 'package:flutter/material.dart';

import '../resources/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                const CircleAvatar(
                  radius: 28,
                ),
                const SizedBox(width: 20),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome", style: TextStyle(fontSize: 15)),
                    Text("Mahdi Islam Pranto",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
                const Spacer(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    color: const Color(0xff2F3646),
                  ),
                  height: 90,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/trimmer.png",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    color: const Color(0xff2F3646),
                  ),
                  height: 90,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/scissors.png",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    color: const Color(0xff2F3646),
                  ),
                  height: 90,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/razor.png",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    color: const Color(0xff2F3646),
                  ),
                  height: 90,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/moisturizing.png",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
