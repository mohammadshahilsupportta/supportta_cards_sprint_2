import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ExpandTileContainer extends StatelessWidget {
  final List<Widget>? children;
  final String title;
  const ExpandTileContainer({super.key, this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CustomPadding.padding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomPadding.padding),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add, color: CustomColors.greenDark),
                    Text(
                      'Add Item',
                      style: TextStyle(color: CustomColors.greenDark),
                    ),
                  ],
                ),
              ),
              backgroundColor: CustomColors.secondaryColor,
              title: Text(title, style: context.inter60022),
              children: children ?? [],
            ),
          ),
        ),
      ),
    );
  }
}
