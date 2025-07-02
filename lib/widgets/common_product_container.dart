import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class CommonProductContainer extends StatefulWidget {
  final bool isAmountContainer;
  final List<Widget>? children;
  final String title;
  final double? grandTotal;
  final bool isOrderDetails;

  const CommonProductContainer({
    required this.title,
    super.key,
    this.children,
    this.isAmountContainer = false,
    this.grandTotal,
    this.isOrderDetails = false,
  });

  @override
  State<CommonProductContainer> createState() => _CommonProductContainerState();
}

class _CommonProductContainerState extends State<CommonProductContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.paddingLarge.v),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(CustomPadding.paddingLarge),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: SizeUtils.height * 0.06,
              decoration: BoxDecoration(
                color:
                    widget.isOrderDetails
                        ? CustomColors.secondaryColor
                        : CustomColors.hoverColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(CustomPadding.paddingLarge),
                  topRight: Radius.circular(CustomPadding.paddingLarge),
                ),
              ),

              child: Row(
                children: [
                  Gap(CustomPadding.paddingLarge),

                  Text(widget.title, style: context.inter60022),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children ?? [],
            ),
            widget.isAmountContainer
                ? Divider(indent: 40, endIndent: 40)
                : SizedBox(),
            widget.isAmountContainer
                ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: CustomPadding.padding.v,
                    horizontal: CustomPadding.paddingXL.v,
                  ),
                  child: Row(
                    children: [
                      Text('Total Amount', style: context.inter50024),
                      Spacer(),
                      Text('₹${widget.grandTotal}', style: context.inter50024),
                    ],
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
