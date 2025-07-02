import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taproot_admin/constants/constants.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/gen/assets.gen.dart';
import 'package:taproot_admin/services/size_utils.dart';

import '../widgets/custom_side_bar.dart';

class SideNavScreen extends StatefulWidget {
  final int passedIndex = 0;
  static const String path = '/sideNav';
  const SideNavScreen({super.key});

  @override
  State<SideNavScreen> createState() => _SideNavScreenState();
}

class _SideNavScreenState extends State<SideNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SizedBox(
      height: SizeUtils.height,
      width: SizeUtils.width,

      child: Text('Home'),
    ),

    SizedBox(
      height: SizeUtils.height,
      width: SizeUtils.width,

      child: Text('orders'),
    ),
    SizedBox(
      height: SizeUtils.height,
      width: SizeUtils.width,

      child: Text('cart'),
    ),
  ];

  void _onItemSelected(int index) {
    logInfo('Tapped index: $index');
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          // PopupMenuButton<String>(
          //   icon: const Icon(Icons.account_circle),
          //   onSelected: (value) {
          //     if (value == 'profile') {
          //     } else if (value == 'logout') {}
          //   },
          //   itemBuilder:
          //       (context) => [

          //         const PopupMenuItem(value: 'profile', child: Text('Profile')),
          //         const PopupMenuItem(
          //           value: 'settings',
          //           child: Text('Settings'),
          //         ),
          //         const PopupMenuItem(value: 'logout', child: Text('Logout')),
          //       ],
          // ),
        ],

        leadingWidth: SizeUtils.width * 0.1,
        toolbarHeight: SizeUtils.height * 0.1,
        leading: Padding(
          padding: EdgeInsets.all(CustomPadding.padding.v),
          child: SvgPicture.asset(Assets.svg.logo),
        ),
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          CustomSideBar(
            selectedIndex: _selectedIndex,
            onItemTap: _onItemSelected,
          ),
        ],
      ),
    );
  }
}
