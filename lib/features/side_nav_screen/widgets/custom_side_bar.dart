import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';

// import '../../../constants/constants.dart';

class CustomSideBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  const CustomSideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: CustomPadding.paddingXL.v,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: CustomPadding.paddingLarge.v,
        children: [
          Container(
            padding: EdgeInsets.all(CustomPadding.padding.v),
            width: SizeUtils.width * 0.045,
            decoration: BoxDecoration(
              color: Colors.white,
              //       color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  //  blurRadius: 4,
                  offset: const Offset(1, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(
                CustomPadding.padding.v + CustomPadding.padding.v,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NavItem(
                  icon: LucideIcons.clipboardMinus,
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemTap(0),
                ),
                //  CustomGap.gapLarge,
                NavItem(
                  icon: LucideIcons.box,
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemTap(1),
                ),

                NavItem(
                  icon: LucideIcons.shoppingCart,
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemTap(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
        decoration: BoxDecoration(
          gradient: isSelected ? CustomColors.borderGradient : null,
          // color: isSelected ? CustomColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(CustomPadding.padding.v),
        ),
        child:


        Icon(icon,
          color: isSelected ? Colors.white : CustomColors.textColorGrey,
          size: 20.v,
        ),
        //  LucideIconWidget(
        //   // icon: icon,
        //   color: isSelected ? Colors.white : CustomColors.textColorGrey,
        // ),
      ),
    );
  }
}
