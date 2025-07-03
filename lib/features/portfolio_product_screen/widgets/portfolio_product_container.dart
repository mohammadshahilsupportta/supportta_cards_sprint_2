import 'package:flutter/material.dart';
import 'package:taproot_admin/constants/constants.dart';
import 'package:taproot_admin/services/size_utils.dart';

class PortfolioProductContainer extends StatelessWidget {
  final Widget child;
  const PortfolioProductContainer({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: CustomPadding.paddingLarge.v,
        vertical: CustomPadding.paddingLarge.v,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: CustomPadding.paddingLarge.v,
      ),
      decoration: BoxDecoration(
        boxShadow: floatingShadowLarge,
    
        color: CustomColors.secondaryColor,
        borderRadius: BorderRadius.circular(
          CustomPadding.paddingLarge * 2,
        ),
      ),
      width: double.infinity,
      height: SizeUtils.height,
      child:child
      
    );
  }
}