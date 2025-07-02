import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ExpenseDescriptionContainer extends StatelessWidget {
  final List<Widget>? children;
  const ExpenseDescriptionContainer({this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: CustomPadding.paddingLarge.v),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: CustomPadding.padding.v),
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomPadding.padding.v),
            border: Border.all(color: CustomColors.textColorLightGrey),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children ?? [],
            ),
          ),
        ),
      ),
    );
  }
}
