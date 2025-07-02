import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../exporter/exporter.dart';

class NotifyChipWidget extends StatelessWidget {
  const NotifyChipWidget({super.key, required this.refundStatusValue});

  final double refundStatusValue;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(CustomPadding.padding * 2),
        color: CustomColors.totalOrdersCancelled,
        dashPattern: const [4, 3],
        strokeWidth: 1.5,

        padding: EdgeInsets.zero,
      ),
      child: Chip(
        surfaceTintColor: Colors.transparent,
        chipAnimationStyle: ChipAnimationStyle(),
        // backgroundColor: Colors.black,
        color: WidgetStatePropertyAll(Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomPadding.padding * 2),
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.banknoteArrowDown,
              color: CustomColors.totalOrdersCancelled,
            ),
            CustomGap.gap,
            Text(
              "Amount Refunded : ₹ ",
              style: context.inter60012.copyWith(
                color: CustomColors.totalOrdersCancelled,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "$refundStatusValue",
              style: context.inter60012.copyWith(
                color: CustomColors.totalOrdersCancelled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
