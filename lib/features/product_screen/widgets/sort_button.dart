import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';

enum SortOption { priceAsc, priceDsc, popular, newItem }

extension SortOptionExtension on SortOption {
  String get apiParameter {
    switch (this) {
      case SortOption.newItem:
        return 'new';
      case SortOption.priceAsc:
        return 'priceAsc';
      case SortOption.priceDsc:
        return 'priceDsc';
      case SortOption.popular:
        return 'popular';
      // case SortOption.newItem:
      //   return 'new';
    }
  }

  String get displayName {
    switch (this) {
      case SortOption.newItem:
        return 'Newest';
      case SortOption.priceAsc:
        return 'Price: Low to High';
      case SortOption.priceDsc:
        return 'Price: High to Low';
      case SortOption.popular:
        return 'Popular';
      
    }
  }
}

class SortButton extends StatelessWidget {
  final Function(SortOption) onSortChanged;
  final SortOption? currentSort;

  const SortButton({super.key, required this.onSortChanged, this.currentSort});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      offset: const Offset(0, 45),
      onSelected: onSortChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomPadding.padding.v),
      ),

      color: CustomColors.secondaryColor,
      itemBuilder:
          (BuildContext context) =>
              SortOption.values.map((option) {
                return PopupMenuItem<SortOption>(
                  value: option,
                  child: SizedBox(
                    width: 200.v,
                    child: Text(
                      option.displayName,
                      style: context.inter50014.copyWith(
                        color:
                            currentSort == option
                                ? CustomColors.buttonColor1
                                : CustomColors.textColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
      child: Container(
        width: 110.v,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CustomPadding.paddingXXL.v),
          border: Border.all(color: CustomColors.textColorLightGrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sort', style: context.inter50014),
            Gap(CustomPadding.padding.v),
            Icon(
              LucideIcons.arrowDownNarrowWide,
              color: CustomColors.textColorGrey,
            ),
          ],
        ),
      ),
    );
  }
}
