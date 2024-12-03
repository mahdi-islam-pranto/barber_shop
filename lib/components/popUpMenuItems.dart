import 'package:flutter/material.dart';

class PopUpMenuItems extends StatelessWidget {
  const PopUpMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 50,
          child: const Text("popup"),
        ),
        Container(
          color: Colors.red,
          height: 50,
          child: const Text("popup"),
        ),
        Container(
          color: Colors.red,
          height: 50,
          child: const Text("popup"),
        ),
      ],
    );
  }
}
