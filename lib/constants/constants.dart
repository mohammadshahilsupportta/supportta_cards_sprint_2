import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gap/gap.dart';

const String baseUrl = "http://213.210.36.7:5000";
const String baseUrlImage =
    'https://supportta-cards.blr1.cdn.digitaloceanspaces.com/test';
// const String baseUrl = 'http://192.168.1.37:5000';

class CustomPadding {
  static const double padding = 8;
  static const double paddingLarge = 16;
  //  static const double paddingMedium = 20;
  static const double paddingXL = 32;
  static const double paddingXXL = 64;
  static const double paddingSmall = 4;
  static const double paddingTiny = 2;
}

class CustomGap {
  static final gap = Gap(CustomPadding.padding);
  static final gapLarge = Gap(CustomPadding.paddingLarge);
  static final gapXL = Gap(CustomPadding.paddingXL);
  static final gapXXL = Gap(CustomPadding.paddingXXL);
  static final gapSmall = Gap(CustomPadding.paddingSmall);
  static final gapTiny = Gap(CustomPadding.paddingTiny);
}

class CustomDuration {
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationLarge = Duration(seconds: 1);
}

class CustomColors {
  // static const primaryColor = Color(0xffFFA500);
  static const primaryColor = burgandryRed;
  static const backgroundColor = Color(0xffF8F9FC);
  // static Color hoverColor = Color.fromARGB(
  //   255,
  //   234,
  //   120,
  //   112,
  // ).withValues(alpha: 0.4);

  static Color hoverColor = borderGradient.colors.last.withValues(alpha: 0.15);

  static const Color totalOrderColor = Colors.indigo;
  static const Color totalOrdersCompleted = Colors.green;
  static const Color totalOrdersCancelled = Color(0xFFF44336);
  static const Color burgandryRed = Color(0xFF800020);
  static const Color hintGrey = Color(0xff7F6E72);
  static const secondaryColor = Colors.white;
  static const tertiaryColor = Color.fromARGB(255, 240, 240, 240);
  // static const backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const textColor = Color.fromARGB(255, 0, 0, 0);
  static const textColorLight = Color.fromARGB(255, 255, 255, 255);
  static const textColorDark = Color.fromARGB(255, 0, 0, 0);
  static Color textColorGrey = Colors.black.withValues(alpha: 0.4);
  static const textColorLightBlack = Color.fromARGB(255, 50, 50, 50);
  static const textColorLightGrey = Color.fromARGB(255, 200, 200, 200);
  static const textColorDarkGrey = Color.fromARGB(255, 50, 50, 50);
  static const Color buttonColor1 = Colors.blue;
  static const Color red = Colors.red;
  static const Color buttonColor2 = Colors.lightGreen;
  static const Color green = Color(0xff27AE60);
  static const Color brown = Color(0xffa2845e);
  static const Color retryRed = Color(0xFFF44336);
  static const Color confirmOrange = Color(0xFFFF9800);
  static const Color dispatchblue = Color(0xFF2196F3);
  static const Color completeGreen = Color(0xFF4CAF50);

  static const Color greenDark = Color(0xff005624);
  static const Color lightGreen = Color(0xffE0EEE8);
  static const Color greylight = Color(0xffF4F5F6);
  static const Color textFieldBorderGrey = Color(0xFF79747E);
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonColor1, buttonColor2],
  );
  static const LinearGradient borderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xff0078e0), Color(0xff00b2af)],
  );
  static const LinearGradient borderGradientRed = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF44336), Color(0xFFF44336)],
  );
}

Iterable<LocalizationsDelegate<dynamic>> customLocalizationsDelegates = const [
  CountryLocalizations.delegate,

  /// CountryLocalizations.getDelegate(enableLocalization: false),  // For no localization only english just declare delegate this way.
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

// LocalizationsDelegate<dynamic> listDelegates =
//    [
//     CountryLocalizations.delegate,

//     /// CountryLocalizations.getDelegate(enableLocalization: false),  // For no localization only english just declare delegate this way.
//     GlobalMaterialLocalizations.delegate,
//     GlobalWidgetsLocalizations.delegate,

// ];
const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

List profileImages = [
  "https://images.unsplash.com/photo-1712847331947-9460dd2f264b?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
  "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
  "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
  "https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
  "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHBvcnRyYWl0fGVufDB8fDB8fHww",
  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHBvcnRyYWl0fGVufDB8fDB8fHww",
  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHBvcnRyYWl0fGVufDB8fDB8fHww",
  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHBvcnRyYWl0fGVufDB8fDB8fHww",
  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHBvcnRyYWl0fGVufDB8fDB8fHww",
  "https://images.unsplash.com/photo-1554151228-14d9def656e4?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjN8fHBvcnRyYWl0fGVufDB8fDB8fHww",
];

String get randomProfileImage {
  List newList = List.from(profileImages);
  newList.shuffle();
  return newList.first;
}

List<String> firstNames = [
  "Emma",
  "Olivia",
  "Ava",
  "Isabella",
  "Sophia",
  "Mia",
  "Charlotte",
  "Amelia",
  "Harper",
  "Evelyn",
  "Liam",
  "Noah",
  "Oliver",
  "Elijah",
  "William",
  "James",
  "Benjamin",
  "Lucas",
  "Henry",
  "Alexander",
];

List<String> lastNames = [
  "Smith",
  "Johnson",
  "Williams",
  "Brown",
  "Jones",
  "Garcia",
  "Miller",
  "Davis",
  "Rodriguez",
  "Martinez",
  "Hernandez",
  "Lopez",
  "Gonzalez",
  "Wilson",
  "Anderson",
  "Thomas",
  "Taylor",
  "Moore",
  "Jackson",
  "Martin",
];

String get randomName {
  List<String> newFirstNames = List.from(firstNames);
  List<String> newLastNames = List.from(lastNames);

  newFirstNames.shuffle();
  newLastNames.shuffle();

  return "${newFirstNames.first} ${newLastNames.first}";
}

const dummyProfile =
    "https://t3.ftcdn.net/jpg/05/16/27/58/240_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg";

final List<BoxShadow> floatingShadow = [
  BoxShadow(
    color: CustomColors.textFieldBorderGrey,
    spreadRadius: .5,
    blurRadius: 2,
    offset: Offset(0, 1), // Vertical shadow
  ),
];
final List<BoxShadow> floatingShadowLarge = [
  BoxShadow(
    color: CustomColors.textFieldBorderGrey.withValues(alpha: 0.2),
    spreadRadius: .5,
    blurRadius: 2,
    offset: Offset(0, 4), // Vertical shadow
  ),
];
