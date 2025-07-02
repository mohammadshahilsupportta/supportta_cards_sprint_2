import '/exporter/exporter.dart';

import '/widgets/loading_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CommonBottomSheet extends StatelessWidget {
  const CommonBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.popButton,
    this.maxWidth,
  });

  final Widget child;

  final String? title;

  final Widget? popButton;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(CustomPadding.paddingXL),
        bottom: SizeUtils.deviceType == DeviceType.mobile
            ? Radius.zero
            : Radius.circular(CustomPadding.paddingXL),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              maxWidth ?? (context.size!.width < 600 ? double.infinity : 400),
        ),
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: CustomPadding.paddingLarge,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(CustomPadding.paddingXL),
                    ),
                    gradient: CustomColors.buttonGradient,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: CustomPadding.paddingXXL,
                    ),
                    child: AutoSizeText(
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      (title ?? ""),
                      style: context.labelLarge.copyWith(
                        fontSize: SizeUtils.deviceType == DeviceType.mobile
                            ? 20.fSize
                            : 40.fSize,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: CustomPadding.paddingLarge,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      popButton ??
                          InkWell(
                            borderRadius: BorderRadius.circular(
                              CustomPadding.paddingXL,
                            ),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(
                                CustomPadding.paddingSmall,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(CustomPadding.paddingXL),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationSheet extends StatelessWidget {
  const ConfirmationSheet({
    super.key,
    required this.buttonText,
    required this.text,
  });

  final String text;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          // gapLargeCu,
          CustomGap.gapLarge,
          LoadingButton(
            buttonLoading: false,
            text: buttonText,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}
