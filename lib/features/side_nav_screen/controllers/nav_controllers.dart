import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/widgets.dart';

class NavControllers {
  static SideMenuController sideMenuController = SideMenuController(
    initialPage: 0,
  );
  static PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
}
