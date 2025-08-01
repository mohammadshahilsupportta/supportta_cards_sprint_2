import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class GradientBorderField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextEditingController? controller;
  const GradientBorderField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.paddingLarge.v),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.transparent, // Set transparent to use ShaderMask
        ),
      ),
      child: ShaderMask(
        shaderCallback:
            (bounds) => LinearGradient(
              colors: CustomColors.borderGradient.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: CustomPadding.paddingLarge.v,
          ),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomPadding.padding.v),
            border: Border.all(width: 2, color: Colors.white),
          ),
          child: TextFormField(
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                foreground:
                    Paint()
                      ..shader = LinearGradient(
                        colors: CustomColors.buttonGradient.colors,
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ).createShader(Rect.fromLTWH(0, 0, 200, 20)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
