import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ReferDetailWidget extends StatelessWidget {
  final int flex;
  final Color titleTextColor;
  final String titleText;
  final String bodyText;
  final bool needGradient;
  const ReferDetailWidget({
    super.key,
    required this.flex,
    required this.titleText,
    required this.bodyText,
    this.titleTextColor = CustomColors.violet,
    this.needGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: CustomPadding.padding),
        height: 121.v,
        decoration: BoxDecoration(
          gradient:
              needGradient
                  ? LinearGradient(
                    colors: [Color(0xffB4DBFD), Color(0xffDCEEF0)],
                  )
                  : null,
          borderRadius: BorderRadius.circular(CustomPadding.paddingXL),
          border: Border.all(width: .5, color: CustomColors.textColorLightGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titleText,
              style: context.inter60020.copyWith(color: titleTextColor),
            ),
            Text(
              bodyText,
              style: context.inter70030.copyWith(
                fontSize: 30.fSize,
                color: CustomColors.blueText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
