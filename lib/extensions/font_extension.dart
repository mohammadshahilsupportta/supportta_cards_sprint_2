import 'package:flutter/material.dart';
import '/gen/fonts.gen.dart';

const String fontFamily1 = FontFamily.inter;

extension BuildContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get adaptiveTextColor =>
      Theme.of(this).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;

  TextStyle baseTextStyle(String fontFamily, FontWeight fontWeight) {
    return TextStyle(
      decoration: TextDecoration.none,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: adaptiveTextColor,
    );
  }

  TextStyle get labelLarge => baseTextStyle(fontFamily1, FontWeight.w700);
  TextStyle get labelMedium => baseTextStyle(fontFamily1, FontWeight.w500);
  TextStyle get labelSmall => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get bodyLarge => baseTextStyle(fontFamily1, FontWeight.w700);
  TextStyle get bodyMedium => baseTextStyle(fontFamily1, FontWeight.w500);
  TextStyle get bodySmall => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get headlineLarge => baseTextStyle(fontFamily1, FontWeight.w700);
  TextStyle get headlineMedium => baseTextStyle(fontFamily1, FontWeight.w500);
  TextStyle get headlineSmall => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get titleLarge => baseTextStyle(fontFamily1, FontWeight.w700);
  TextStyle get titleMedium => baseTextStyle(fontFamily1, FontWeight.w600);
  TextStyle get titleSmall => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get displayLarge => baseTextStyle(fontFamily1, FontWeight.w700);

  TextStyle get displayMedium => baseTextStyle(fontFamily1, FontWeight.w500);
  TextStyle get displaySmall => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get caption => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get overline => baseTextStyle(fontFamily1, FontWeight.w400);
  TextStyle get button => baseTextStyle(fontFamily1, FontWeight.w700);
  // TextStyle get Inter40016 => baseTextStyle(fontFamily1, FontWeight.w400,\

  TextStyle get inter40016 => displaySmall.copyWith(fontSize: 16);

  TextStyle get inter50016 => displayMedium.copyWith(fontSize: 16);
  TextStyle get inter50014 => displayMedium.copyWith(fontSize: 14);
  TextStyle get inter50018 => displayMedium.copyWith(fontSize: 18);
  TextStyle get inter50024 => displayMedium.copyWith(fontSize: 24);
  TextStyle get inter70016 => displayLarge.copyWith(fontSize: 16);
  TextStyle get inter70030 => displayLarge.copyWith(fontSize: 30);

  TextStyle get inter60024 => titleMedium.copyWith(fontSize: 24);
  TextStyle get inter60012 => titleMedium.copyWith(fontSize: 12);
  TextStyle get inter60014 => titleMedium.copyWith(fontSize: 14);
  TextStyle get inter60016 => titleMedium.copyWith(fontSize: 16);

  TextStyle get inter60020 => titleMedium.copyWith(fontSize: 20);
  TextStyle get inter60022 => titleMedium.copyWith(fontSize: 22);
  // TextStyle get inter60024 => titleMedium.copyWith(fontSize: 24);
  // TextStyle get latoBold => baseTextStyle(fontFamily1, FontWeight.w700);
  // TextStyle get latoBlack => baseTextStyle('Lato', FontWeight.w900);
  // TextStyle get latoLight => baseTextStyle('Lato', FontWeight.w300);
  // TextStyle get latoThin => baseTextStyle('Lato', FontWeight.w100);
}
