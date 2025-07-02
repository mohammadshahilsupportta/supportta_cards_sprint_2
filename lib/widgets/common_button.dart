import 'package:flutter/material.dart';
import '/exporter/exporter.dart';

class CommonBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CommonBtn({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: CustomColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: CustomColors.secondaryColor, fontSize: 16),
        ),
      ),
    );
  }
}
