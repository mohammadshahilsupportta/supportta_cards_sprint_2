import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class LogisticTileWidget extends StatelessWidget {
  final bool isGapExist;
  final Color? tileColor;
  final String title;
  final double tileWidgetBorderRadius;
  final int numericaldata;
  final double normalPadding;
  final Widget? supportingWidget;
  final Icon? trailingIcon;
  final Color? numericalColor;
  final Widget? notifyTrailingWidget;

  const LogisticTileWidget({
    super.key,
    required this.tileWidgetBorderRadius,
    required this.normalPadding,
    this.supportingWidget,
    required this.numericaldata,
    this.trailingIcon,
    required this.title,
    this.tileColor,
    this.isGapExist = false,
    this.numericalColor,
    this.notifyTrailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle numericalStyle = context.inter60024.copyWith(
      color: numericalColor ?? Colors.black,
    );

    TextStyle titleStyle = context.inter50014.copyWith(
      color: CustomColors.hintGrey,
      fontSize: 20,
    );
    return Card(
      color: tileColor ?? Colors.amber,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tileWidgetBorderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(normalPadding * 2),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: titleStyle),

                      // SizedBox(height: 8),
                      CustomGap.gapXL,
                      Row(
                        children: [
                          Text('$numericaldata', style: numericalStyle),
                          isGapExist ? Spacer() : Gap(normalPadding * 2),
                          supportingWidget ?? SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(top: 0, right: 0, child: trailingIcon ?? SizedBox()),

            Positioned(
              bottom: 0,
              right: 0,

              child: notifyTrailingWidget ?? SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
