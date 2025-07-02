import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '/exporter/exporter.dart'; // adjust your path

enum ButtonSize {
  small,
  medium,
  large;

  double get width {
    switch (this) {
      case ButtonSize.small:
        return 140;
      case ButtonSize.medium:
        return 200;
      case ButtonSize.large:
        return 300;
    }
  }

  double get height {
    switch (this) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 50;
      case ButtonSize.large:
        return 60;
    }
  }

  double get fontSize {
    switch (this) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 17;
      case ButtonSize.large:
        return 19;
    }
  }
}

class MiniGradientBorderButton extends StatelessWidget {
  const MiniGradientBorderButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.size = ButtonSize.small,
    this.backgroundColor = Colors.white,
    this.borderRadius = 8,
    this.borderWidth = 2,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF007BFF), Color(0xFF00C6FF)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final ButtonSize size;
  final Color backgroundColor;
  final double borderRadius;
  final IconData? icon;
  final double borderWidth;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    final double width = size.width.h;
    final double height = size.height.h;

    return MouseRegion(
      cursor:
          enabled && !isLoading
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap:
            enabled && !isLoading
                ? () {
                  HapticFeedback.lightImpact();
                  FocusScope.of(context).unfocus();
                  onPressed();
                }
                : null,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              // Outer gradient border
              Container(
                decoration: BoxDecoration(
                  gradient: enabled ? gradient : null,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              // Inner container with background color
              Positioned(
                top: borderWidth,
                bottom: borderWidth,
                left: borderWidth,
                right: borderWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: enabled ? backgroundColor : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(
                      borderRadius - borderWidth,
                    ),
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? SizedBox(
                              width: 18.h,
                              height: 18.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.adaptSize,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ), // loader color
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icon != null) ...[
                                  ShaderMask(
                                    shaderCallback:
                                        (bounds) =>
                                            gradient.createShader(bounds),
                                    blendMode: BlendMode.srcIn,
                                    child: Icon(icon, size: 18),
                                  ),
                                  Gap(CustomPadding.padding),
                                ],
                                ShaderMask(
                                  shaderCallback:
                                      (bounds) => gradient.createShader(bounds),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: size.fontSize.fSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
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
