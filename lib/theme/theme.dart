import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

import '/gen/fonts.gen.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    expansionTileTheme: ExpansionTileThemeData(
      tilePadding: EdgeInsets.only(right: CustomPadding.padding),
      expandedAlignment: Alignment.centerLeft,
      //    expansionAnimationStyle: AnimationStyle(),
      shape: Border.all(color: Colors.transparent),
      //  backgroundColor: CustomColors.lightGreen,
      collapsedBackgroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Icon(Icons.circle_outlined, color: Colors.grey);
        }
        if (states.contains(WidgetState.selected)) {
          return Icon(
            Icons.circle,
            color: CustomColors.borderGradient.colors.first,
          );
        }
        return Icon(Icons.circle_outlined, color: Colors.grey.shade400);
      }),

      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey; // Disabled thumb
        }
        if (states.contains(WidgetState.selected)) {
          return CustomColors.borderGradient.colors.first; // ON thumb
        }
        return Colors.grey.shade400; // OFF thumb
      }),

      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey.shade300; // Disabled track
        }
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300; // OFF track
          // return CustomColors.borderGradient.colors.last.withValues(
          //   alpha: 0.3,
          // ); // ON track
        }
        return Colors.grey.shade300; // OFF track
      }),

      trackOutlineColor: WidgetStatePropertyAll(Colors.grey),
    ),

    // cardColor: Colors.yellow,
    // dialogBackgroundColor: Colors.white,
    // dialogTheme: ,
    cardTheme: CardThemeData(
      color: Colors.white,
      // color: CustomColors.borderGradient.colors.last.withValues(alpha: 0.1),
      shadowColor: Colors.transparent,
      // shadowColor: CustomColors.textFieldBorderGrey.withValues(alpha: 0.2),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomPadding.paddingLarge),
      ),
    ),
    dataTableTheme: DataTableThemeData(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      //   boxShadow: [
      //     BoxShadow(
      //       color: CustomColors.textFieldBorderGrey.withOpacity(0.2),
      //       blurRadius: 5,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      headingRowColor: WidgetStatePropertyAll(Colors.white),
      dataRowColor: WidgetStatePropertyAll(Colors.white),
      // dataRowHeight: 50,
      // headingRowHeight: 50,
      // columnSpacing: 20,
      // horizontalMargin: 10,
      // showBottomBorder: true,
      headingTextStyle: TextStyle(
        color: CustomColors.textColor,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      ),
      dataTextStyle: TextStyle(
        color: CustomColors.textColor,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      ),

      headingRowAlignment: MainAxisAlignment.center,
    ),
    fontFamily: FontFamily.inter,
    scaffoldBackgroundColor: CustomColors.backgroundColor,
    hoverColor: CustomColors.hoverColor,
    primaryColor: CustomColors.primaryColor,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: CustomColors.textColor),
      titleTextStyle: TextStyle(
        color: CustomColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.textColorLightGrey),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.textColorLightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomColors.textColorLightGrey),
      ),
    ),
  );
}
