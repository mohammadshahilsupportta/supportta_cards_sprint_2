import 'package:taproot_admin/features/Dashboard_screen/view/dashboard_screen.dart';
import 'package:taproot_admin/features/Expense_screen/view/expense_view.dart';
import 'package:taproot_admin/features/leads_screen.dart/view/leads.dart';
import 'package:taproot_admin/features/order_screen/view/order_screen.dart';
import 'package:taproot_admin/features/product_screen/views/product_screen.dart';
import 'package:taproot_admin/features/user_data_update_screen/views/add_user_portfolio.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/services/connectivity_service.dart';

import '../features/side_nav_screen/view/side_drawer_nav_screen.dart';
import '../features/side_nav_screen/view/side_nav_screen.dart';
import '../features/users_screen/view/user_management_screen.dart';
import '/features/auth_screen/view/auth_screen.dart';

import '/features/landing_screen/landing_page.dart';
import 'package:flutter/material.dart';

import '../core/logger.dart';

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name!);
    logInfo('Route name: ${settings.name}');
    logInfo('URI path: ${uri.path}');

    logInfo(uri);

    switch (uri.path) {
      // case UserDataUpdateScreen.path:
      //   return pageRoute(settings, const UserDataUpdateScreen()

      //   );
      case DashboardScreen.path:
        return pageRoute(settings, DashboardScreen());
      case ConnectionCheckerScreen.path:
        return pageRoute(settings, const ConnectionCheckerScreen());
      case LeadScreen.path:
        return pageRoute(settings, const LeadScreen());
      case ExpenseView.path:
        return pageRoute(settings, const ExpenseView());

      case OrderScreen.path:
        return pageRoute(settings, const OrderScreen());

      // case EditProduct.path:
      //   return pageRoute(settings, const EditProduct());

      case ProductScreen.path:
        return pageRoute(settings, const ProductScreen());

      case UserManagementScreen.path:
        return pageRoute(settings, const UserManagementScreen());

      case SideDrawerNavScreen.path:
        return pageRoute(settings, const SideDrawerNavScreen());

      case SideNavScreen.path:
        return pageRoute(settings, const SideNavScreen());

      case AuthScreen.path:
        return pageRoute(settings, const AuthScreen());

      //TODO : navigate to the add user portfolio screen
      case '/addUserPortfolio':
        final user = settings.arguments as User;
        return pageRoute(settings, AddUserPortfolio(user: user));

      case LandingPage.path:
        return pageRoute(settings, const LandingPage());

      default:
        return null;
    }
  }

  static List<Route<dynamic>> onGenerateInitialRoute(String path) {
    Uri uri = Uri.parse(path);

    logInfo(uri);

    return [
      pageRoute(
        const RouteSettings(name: ConnectionCheckerScreen.path),
        const ConnectionCheckerScreen(),
        animate: false,
      ),
    ];
  }

  // static List<Route<dynamic>> onGenerateInitialRoute(String path) {
  //   Uri uri = Uri.parse(path);

  //   logInfo(uri);

  //   //TODO: step 2: use the shared pref value to navigate to the side navigation page or the auth page

  //   //if shared preference Service is null , we can navigate to the landing page
  //   //if shared preference Service is not null , we can navigate to the splash Screen then to home page

  //   return [
  //     pageRoute(
  //       RouteSettings(name: AuthScreen.path),
  //       const AuthScreen(),
  //       animate: false,
  //     ),
  //   ];
  // }

  static Route<T> pageRoute<T>(
    RouteSettings settings,
    Widget screen, {
    bool animate = true,
  }) {
    if (!animate) {
      return PageRouteBuilder(
        settings: settings,
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) => screen,
      );
    }
    return MaterialPageRoute(settings: settings, builder: (context) => screen);
  }
}
