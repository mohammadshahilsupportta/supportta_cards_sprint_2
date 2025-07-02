import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class DashBoardContainer extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final IconData icon;
  final Color iconColor;
  final bool isExpense;
  final String comparisonText;

  const DashBoardContainer({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.percentage,
    this.isExpense = false,
      required this.comparisonText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(CustomPadding.paddingXL.v),
        padding: EdgeInsets.all(CustomPadding.paddingXL.v),

        height: 170.v,
        decoration: BoxDecoration(
          color: CustomColors.greylight,
          borderRadius: BorderRadius.circular(CustomPadding.padding.v),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: context.inter50018.copyWith(
                    color: CustomColors.hintGrey,
                  ),
                ),
                Spacer(),
                Icon(icon, color: iconColor),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text('₹ $amount', style: context.inter60024),
                Gap(CustomPadding.paddingXL.v),
                Text(
                  '$percentage%',
                  style:
                      isExpense
                          ? TextStyle(color: CustomColors.red)
                          : TextStyle(color: CustomColors.green),
                ),
                isExpense
                    ? Icon(Icons.arrow_downward, color: CustomColors.red)
                    : Icon(Icons.arrow_upward, color: CustomColors.green),
                RichText(
                  text: TextSpan(
                    text: 'vs $comparisonText',
                    style: context.inter50018.copyWith(
                      fontSize: 14.fSize,
                      // fontWeight: FontWeight.w300,
                      color: CustomColors.textColorDarkGrey,
                    ),
                  ),
                ),
              ],
            ),
            Gap(CustomPadding.paddingLarge.v),
          ],
        ),
      ),
    );
  }
}
