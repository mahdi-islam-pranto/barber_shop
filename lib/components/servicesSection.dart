import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            // service icon container
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                color: const Color(0xff2F3646),
              ),
              height: 90,
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/trimmer.png",
                    ),
                  ),
                ],
              ),
            ),

            // service text

            const SizedBox(
              height: 10,
            ),

            const Text("TRIM", style: TextStyle(fontSize: 16))
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            // service icon container
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                color: const Color(0xff2F3646),
              ),
              height: 90,
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/scissors.png",
                    ),
                  ),
                ],
              ),
            ),

            // service text

            const SizedBox(
              height: 10,
            ),

            const Text("HAIRCUT", style: TextStyle(fontSize: 16))
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            // service icon container
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                color: const Color(0xff2F3646),
              ),
              height: 90,
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/razor.png",
                    ),
                  ),
                ],
              ),
            ),

            // service text

            const SizedBox(
              height: 10,
            ),

            const Text("SHAVE", style: TextStyle(fontSize: 16))
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            // service icon container
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                color: const Color(0xff2F3646),
              ),
              height: 90,
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/images/moisturizing.png",
                    ),
                  ),
                ],
              ),
            ),

            // service text

            const SizedBox(
              height: 10,
            ),

            const Text("FACIAL", style: TextStyle(fontSize: 16))
          ],
        ),
      ],
    );
  }
}
