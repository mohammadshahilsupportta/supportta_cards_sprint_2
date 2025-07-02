import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: CustomColors.hintGrey),
          Gap(CustomPadding.paddingLarge.v),
          Text(
            'Not Found',
            style: context.inter60016.copyWith(color: CustomColors.textColor),
          ),
          Gap(CustomPadding.paddingSmall.v),
        ],
      ),
    );
  }
}
