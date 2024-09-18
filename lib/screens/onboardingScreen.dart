import 'package:flutter/material.dart';

import '../components/onboardingContent.dart';
import '../components/onboardingDots.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _selctedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TODO: Onboard Content

            const Spacer(flex: 1),
            SizedBox(
              height: 450,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    _selctedIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardContent(
                    illustration: demoData[index]['illustration'],
                    title: demoData[index]['title'],
                    text: demoData[index]['text'],
                  );
                },
              ),
            ),
            const Spacer(),

            // TODO: Animated Dots

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: AnimatedDot(isActive: _selctedIndex == index),
                ),
              ),
            ),
            const Spacer(flex: 1),

            // TODO: Button

            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Get Started".toUpperCase(),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> demoData = [
  {
    "illustration": "assets/images/barberhome1.jpeg",
    "title": "All your favorites",
    "text":
        "Order from the best local restaurants \nwith easy, on-demand delivery.",
  },
  {
    "illustration": "assets/images/barberhome2.jpeg",
    "title": "Free delivery offers",
    "text":
        "Free delivery for new customers via Apple Pay\nand others payment methods.",
  },
  {
    "illustration": "assets/images/barberhome3.jpeg",
    "title": "Choose your food",
    "text":
        "Easily find your type of food craving and\nyou’ll get delivery in wide range.",
  },
];
