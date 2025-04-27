import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final double? paddingLeft;
  const SectionHeader({
    super.key,
    required this.text,
    this.paddingLeft = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft ?? 16.0),
      child: Text(text,
          style: const TextStyle(
              color: Colors.black45,
              fontSize: 22,
              fontFamily: "Sora",
              fontWeight: FontWeight.bold)),
    );
  }
}
