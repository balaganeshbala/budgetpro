import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(text,
          style: const TextStyle(
              color: Colors.black45,
              fontSize: 22,
              fontFamily: "Sora",
              fontWeight: FontWeight.bold)),
    );
  }
}
