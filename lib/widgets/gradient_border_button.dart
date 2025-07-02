import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class GradientBorderButton extends StatelessWidget {
  final double borderWidth;
  final LinearGradient? borderGradientColor;
  final Color buttonColors;
  final double buttonHeight;
  final Color? fontColor;
  final VoidCallback? onTap;
  final List<Widget> children;
  final double horizontalPadding;

  const GradientBorderButton({
    this.buttonHeight = 40,
    super.key,
    this.borderWidth = 1,
    this.borderGradientColor = CustomColors.buttonGradient,
    this.buttonColors = CustomColors.lightGreen,
    this.onTap,
    this.fontColor,
    required this.children,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    double baseBorder = CustomPadding.padding;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40.v,
          child: Stack(
            children: [
              Container(
                height: buttonHeight.h,
                decoration: BoxDecoration(
                  gradient: borderGradientColor,
                  borderRadius: BorderRadius.circular(baseBorder),
                ),
              ),
              Positioned(
                top: borderWidth,
                bottom: borderWidth,
                right: borderWidth,
                left: borderWidth,
                child: Container(
                  height: (buttonHeight - (2 * borderWidth)).h,
                  decoration: BoxDecoration(
                    color: buttonColors,
                    borderRadius: BorderRadius.circular(
                      baseBorder - borderWidth,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: children,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
