import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '/exporter/exporter.dart';

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

class MiniLoadingButton extends StatelessWidget {
  const MiniLoadingButton({
    super.key,
    this.icon,
    this.needRow = true,
    this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.size = ButtonSize.small,
    this.backgroundColor = const Color(0xFF007BFF),
    this.textColor = Colors.white,
    this.borderRadius = 8,
    this.useGradient = false,
    this.gradientColors,
  });
  final bool needRow;
  final String? text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final ButtonSize size;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final IconData? icon;
  final bool useGradient;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          width: size.width.h,
          height: size.height.h,
          decoration: BoxDecoration(
            color:
                useGradient
                    ? null
                    : (enabled ? backgroundColor : Colors.grey.shade400),
            gradient:
                useGradient && enabled
                    ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,

                      // end: Alignment.topCenter,
                      colors:
                          gradientColors ??
                          [Color(0xFF007BFF), Color(0xFF00C6FF)],
                      // colors: [],
                    )
                    : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child:
                isLoading
                    ? SizedBox(
                      width: 18.h,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.adaptSize,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        needRow ? Icon(icon, color: textColor) : SizedBox(),
                        needRow ? Gap(CustomPadding.padding) : SizedBox(),
                        Builder(
                          builder: (context) {
                            if (text != null) {
                              return Text(
                                text!,
                                style: TextStyle(
                                  fontSize: size.fontSize.fSize,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
