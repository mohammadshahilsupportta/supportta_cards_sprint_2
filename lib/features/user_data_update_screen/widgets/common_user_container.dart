import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class CommonUserContainer extends StatelessWidget {
  final double? height;
  final List<Widget>? children;
  final String title;
  const CommonUserContainer({
    required this.title,
    super.key,
    this.children,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(CustomPadding.paddingLarge),
        ),
        height: height ?? SizeUtils.height * 0.48,
        // height: SizeUtils.height * 0.40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: SizeUtils.height * 0.06,
              decoration: BoxDecoration(
                color: CustomColors.hoverColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(CustomPadding.paddingLarge),
                  topRight: Radius.circular(CustomPadding.paddingLarge),
                ),
              ),

              child: Row(
                children: [
                  Gap(CustomPadding.paddingLarge),

                  Text(title, style: context.inter60022),
                ],
              ),
            ),
            Column(children: children ?? []),
          ],
        ),
      ),
    );
  }
}
