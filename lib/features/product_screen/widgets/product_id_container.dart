import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ProductIdContainer extends StatelessWidget {
  final String productId;
  const ProductIdContainer({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.v,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CustomPadding.padding.v),
        color: CustomColors.hoverColor,
      ),
      child: Row(
        children: [
          Gap(CustomPadding.padding.v),
          Text(productId, style: context.inter60022),
        ],
      ),
    );
  }
}
