import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class PaddingRow extends StatelessWidget {
  final List<Widget> children;
  const PaddingRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.paddingLarge.v),
      child: Row(children: children),
    );
  }
}
