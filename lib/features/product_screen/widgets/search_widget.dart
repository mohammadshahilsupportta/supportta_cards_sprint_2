import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const SearchWidget({
    super.key,
    required this.hintText,
     this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeUtils.width / 3.h,
      child: TextFormField(controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.inter40016.copyWith(color: CustomColors.hintGrey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.textColorLightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.textColorLightGrey),
          ),
          suffixIcon: Icon(LucideIcons.search),
        ),
      ),
    );
  }
}
