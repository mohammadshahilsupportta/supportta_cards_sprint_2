import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../exporter/exporter.dart';

class CustomSideMenuTitleForExpandedTiles extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CustomSideMenuTitleForExpandedTiles({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  isSelected
                      ? CustomColors.buttonColor1
                      : CustomColors.textColorDarkGrey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color:
                    isSelected
                        ? CustomColors.buttonColor1
                        : CustomColors.textColorDarkGrey,
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
