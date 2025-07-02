import 'package:flutter/material.dart';
import 'package:taproot_admin/constants/constants.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  const RefreshButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.buttonColor1,
        borderRadius: BorderRadius.circular(CustomPadding.paddingXL),
      ),
      child: IconButton(
        // color: Colors.blue,
        // highlightColor: Colors.blue,
        tooltip: 'Refresh',
        onPressed: () {
          onTap();
        },
        icon: Icon(Icons.refresh, color: CustomColors.secondaryColor),
      ),
    );
  }
}
