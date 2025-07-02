import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class SideMenuLucideIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;

  const SideMenuLucideIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    return Icon(
      icon,
      size: 20.fSize,
      color: isSelected ? Colors.white : CustomColors.textColorDarkGrey,
    );

    // LucideIconWidget(
    //   icon: icon,
    //   color: isSelected ? Colors.white : CustomColors.textColorDarkGrey,
    //   size: 20.fSize,
    // );
  }
}
