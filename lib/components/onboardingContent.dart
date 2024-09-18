import 'package:flutter/material.dart';

import '../resources/colors.dart';

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: CircleAvatar(
              backgroundImage: AssetImage(illustration),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: TextStyle(
              fontSize: 20,
              color: textColor,
            )),
        const SizedBox(height: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
