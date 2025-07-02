import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:one_clock/one_clock.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Dashboard_screen/view/dashboard_screen.dart';
import 'package:taproot_admin/features/Expense_screen/view/expense_view.dart';
import 'package:taproot_admin/features/auth_screen/data/auth_service.dart';
import 'package:taproot_admin/features/leads_screen.dart/view/leads.dart';
import 'package:taproot_admin/features/order_screen/view/order_screen.dart';
import 'package:taproot_admin/features/product_screen/views/product_screen.dart';
import 'package:taproot_admin/features/side_nav_screen/controllers/nav_controllers.dart';
import 'package:taproot_admin/features/users_screen/view/user_management_screen.dart';
import 'package:taproot_admin/gen/assets.gen.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

import '../../portfolio_product_screen/view/porfolio_product.dart';
import '../widgets/side_menu_lucide_icon_widgt.dart';

class SideDrawerNavScreen extends StatefulWidget {
  final int passedIndex;

  static const String path = '/sideDrawerNav';
  const SideDrawerNavScreen({super.key, this.passedIndex = 0});

  @override
  State<SideDrawerNavScreen> createState() => _SideDrawerNavScreenState();
}

class _SideDrawerNavScreenState extends State<SideDrawerNavScreen> {
  int _currentIndex = 0;

  final GlobalKey<NavigatorState> _innerNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _innerOrderNavigatorKey =
      GlobalKey<NavigatorState>();
  final List<String> _pageTitles = [
    'Dashboard',
    'Orders',
    'Product',
    'NFC Cards',
    'Users',
    'Expense',
    'Leads',
  ];

  @override
  void initState() {
    super.initState();
    NavControllers.sideMenuController.addListener((index) {
      setState(() {
        _currentIndex = index;
        NavControllers.pageController.jumpToPage(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Gap(CustomPadding.paddingXXL.v),
            Text(_pageTitles[_currentIndex]),
          ],
        ),
        actions: [
          Row(
            children: [
              Column(
                children: [
                  Gap(CustomPadding.paddingLarge),

                  DigitalClock(
                    isLive: true,
                    textScaleFactor: 1.1,
                    datetime: DateTime.now(),
                    useMilitaryTime: false,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Gap(CustomPadding.paddingXL),
        ],
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.all(CustomPadding.padding),
          child: Image.asset(
            Assets.png.supporttalogo.path,
            fit: BoxFit.contain,
          ),
        ),
        toolbarHeight: kToolbarHeight.h,

        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: SideMenu(
                    controller: NavControllers.sideMenuController,

                    style: SideMenuStyle(
                      // decoration: BoxDecoration(color: Colors.red),
                      // unselectedIconColorExpandable: Colors.white,
                      selectedTitleTextStyleExpandable: TextStyle(
                        color: Colors.white,
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.bold,
                      ),
                      arrowOpen: CustomColors.buttonColor1,
                      unselectedTitleTextStyleExpandable: TextStyle(
                        color: CustomColors.textColorDarkGrey,
                        fontSize: 14.fSize,
                      ),
                      backgroundColor: Colors.white,
                      displayMode: SideMenuDisplayMode.open,
                      openSideMenuWidth: (150 / 1440) * SizeUtils.width,
                      selectedColor: CustomColors.borderGradient.colors.first,

                      selectedTitleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedTitleTextStyle: TextStyle(
                        color: CustomColors.textColorDarkGrey,
                        fontSize: 14.fSize,
                      ),
                      hoverColor: CustomColors.hoverColor,
                      itemOuterPadding: EdgeInsets.symmetric(
                        vertical: CustomPadding.paddingSmall.v,
                      ),
                    ),
                    items: [
                      SideMenuItem(
                        title: 'Dashboard',
                        iconWidget: SideMenuLucideIcon(
                          icon: LucideIcons.clipboardMinus,
                          index: 0,
                          currentIndex: _currentIndex,
                        ),
                        onTap: (index, _) {
                          setState(() {
                            _currentIndex = index;
                          });
                          NavControllers.sideMenuController.changePage(index);
                        },
                      ),
                      SideMenuItem(
                        title: 'Orders',
                        iconWidget: SideMenuLucideIcon(
                          icon: LucideIcons.box,
                          index: 1,
                          currentIndex: _currentIndex,
                        ),
                        onTap: (index, _) {
                          setState(() {
                            _currentIndex = index;
                          });
                          NavControllers.sideMenuController.changePage(index);
                        },
                      ),

                      SideMenuExpansionItem(
                        icon: Icon(LucideIcons.shoppingCart),
                        title: 'Product',
                        children: [
                          SideMenuItem(
                            //    trailing: SizedBox(width: .001 * SizeUtils.height),
                            title: 'NFC Card',
                            iconWidget: SideMenuLucideIcon(
                              icon: LucideIcons.idCard,
                              index: 2,
                              currentIndex: _currentIndex,
                            ),
                            onTap: (index, _) {
                              setState(() {
                                _currentIndex = index;
                              });
                              NavControllers.sideMenuController.changePage(
                                index,
                              );
                            },
                          ),
                          SideMenuItem(
                            title: 'Portfolio',
                            iconWidget: SideMenuLucideIcon(
                              icon: LucideIcons.tabletSmartphone,
                              index: 3,
                              currentIndex: _currentIndex,
                            ),
                            onTap: (index, _) {
                              setState(() {
                                _currentIndex = index;
                              });
                              NavControllers.sideMenuController.changePage(
                                index,
                              );
                            },
                          ),
                        ],
                      ),

                      SideMenuItem(
                        title: 'Users',
                        iconWidget: SideMenuLucideIcon(
                          icon: LucideIcons.users,
                          index: 4,
                          currentIndex: _currentIndex,
                        ),
                        onTap: (index, _) {
                          setState(() {
                            _currentIndex = index;
                          });
                          NavControllers.sideMenuController.changePage(index);
                        },
                      ),
                      SideMenuItem(
                        title: 'Expense',
                        iconWidget: SideMenuLucideIcon(
                          icon: LucideIcons.network,
                          index: 5,
                          currentIndex: _currentIndex,
                        ),
                        onTap: (index, _) {
                          setState(() {
                            _currentIndex = index;
                          });

                          NavControllers.sideMenuController.changePage(index);
                        },
                      ),
                      SideMenuItem(
                        title: 'Leads',
                        iconWidget: SideMenuLucideIcon(
                          icon: LucideIcons.briefcaseBusiness,
                          index: 6,
                          currentIndex: _currentIndex,
                        ),
                        onTap: (index, _) {
                          setState(() {
                            _currentIndex = index;
                          });

                          NavControllers.sideMenuController.changePage(index);
                        },
                      ),
                    ],
                    footer: Padding(
                      padding: EdgeInsets.only(bottom: CustomPadding.paddingXL),
                      child: Container(
                        color: CustomColors.secondaryColor,
                        child: Padding(
                          padding: EdgeInsets.all(CustomPadding.padding),
                          child: TextButton.icon(
                            style: ButtonStyle(
                              overlayColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Colors.red.shade100;
                                    }
                                    return null;
                                  }),
                            ),
                            onPressed: () => _handleLogout(context),
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: NavControllers.pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Navigator(
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(builder: (_) => DashboardScreen());
                  },
                ),
                Navigator(
                  key: _innerOrderNavigatorKey,
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder:
                          (_) => OrderScreen(
                            innerNavigatorKey: _innerOrderNavigatorKey,
                          ),
                    );
                  },
                ),
                Navigator(
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (_) => ProductScreen(),
                      settings: settings,
                    );
                  },
                ),
                Navigator(
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (_) => PorfolioProduct(),
                      settings: settings,
                    );
                  },
                ),

                Navigator(
                  key: _innerNavigatorKey,
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder:
                          (_) => UserManagementScreen(
                            innerNavigatorKey: _innerNavigatorKey,
                          ),
                      settings: settings,
                    );
                  },
                ),
                Navigator(
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (_) => ExpenseView(),
                      settings: settings,
                    );
                  },
                ),
                Navigator(
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (_) => LeadScreen(),
                      settings: settings,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: CustomColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              MiniGradientBorderButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context, false),
              ),
              MiniLoadingButton(
                useGradient: true,
                needRow: false,

                text: 'Logout',
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await Future.delayed(const Duration(milliseconds: 300));
      SnackbarHelper.showSuccess(context, 'Logout Successfully');
      await AuthService.sessionLogout(context);
    }
  }
}
