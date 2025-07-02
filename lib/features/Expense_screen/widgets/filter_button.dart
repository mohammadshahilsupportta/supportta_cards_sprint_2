import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.v,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CustomPadding.paddingXXL.v),
        border: Border.all(color: CustomColors.textColorLightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Filter', style: context.inter50014),
          Gap(CustomPadding.padding.v),
          Icon(Icons.filter_alt_rounded, color: CustomColors.textColorGrey),
        ],
      ),
    );
  }
}
