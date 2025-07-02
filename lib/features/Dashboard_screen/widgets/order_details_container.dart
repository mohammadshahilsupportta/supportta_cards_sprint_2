import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class OrderDetailsContainer extends StatelessWidget {
  final String title;
  final String statusTitle;
  final int totalCount;
  final int? statusCount;
  final double? borderRadius;
  const OrderDetailsContainer({
    super.key,
    required this.totalCount,
    this.statusCount,
    required this.statusTitle,
    required this.title,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: CustomPadding.paddingXL),

        padding: EdgeInsets.all(CustomPadding.paddingXL),
        // width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: CustomColors.greylight,
          borderRadius: BorderRadius.circular(
            borderRadius ?? CustomPadding.padding,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(title, style: context.inter50014),
                Spacer(),
                Icon(LucideIcons.package, color: CustomColors.brown),
              ],
            ),
            Gap(CustomPadding.paddingXL),

            Row(
              children: [
                Text(totalCount.toString(), style: context.inter60024),
                Gap(CustomPadding.paddingXL),
                // Text(
                //   statusCount.toString(),
                //   style: TextStyle(color: CustomColors.green),
                // ),
                Gap(CustomPadding.padding),

                Text(statusTitle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
