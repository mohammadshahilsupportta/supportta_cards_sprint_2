import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Referral_screen/view/refer_user_details.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/referal_settings_dialog_box.dart';
import 'package:taproot_admin/features/product_screen/widgets/search_widget.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class ReferScreen extends StatefulWidget {
  final GlobalKey<NavigatorState>? innerNavigatorKey;

  const ReferScreen({super.key, required this.innerNavigatorKey});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  final _tableKey = GlobalKey<PaginatedDataTableState>();

  @override
  Widget build(BuildContext context) {
    TextStyle headingTextStyle = context.inter60016.copyWith(
      fontSize: 18.fSize,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(CustomPadding.paddingLarge),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CustomPadding.paddingLarge,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Wallet  > Wallet User Details',
                    style: context.inter60016.copyWith(
                      color: CustomColors.buttonColor1,
                    ),
                  ),
                  Spacer(),
                  MiniGradientBorderButton(
                    text: 'Settings',
                    icon: LucideIcons.settings,
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ReferalSettingsDialogBox();
                          // return Dialog(
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Text('Wallet', style: context.inter60014),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                      );
                    },

                    gradient: LinearGradient(
                      colors: CustomColors.borderGradient.colors,
                    ),
                  ),
                  Gap(CustomPadding.paddingLarge.v),
                  MiniLoadingButton(
                    icon: Icons.add,
                    text: 'Add User',
                    onPressed: () {},
                    useGradient: true,
                    gradientColors: CustomColors.borderGradient.colors,
                  ),
                ],
              ),
            ),
            Gap(CustomPadding.paddingLarge),
            SizedBox(
              width: .87 * SizeUtils.width,
              child: Container(
                padding: EdgeInsets.all(CustomPadding.paddingLarge),
                decoration: BoxDecoration(
                  boxShadow: floatingShadowLarge,

                  color: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.circular(
                    CustomPadding.paddingLarge * 2,
                  ),
                ),
                child: PaginatedDataTable(
                  dividerThickness: 0.6,
                  header: Row(
                    children: [
                      SearchWidget(
                        hintText: 'Search User ID, Name, Number',
                        iconColor: CustomColors.buttonColor1,
                      ),
                    ],
                  ),
                  rowsPerPage: 7,
                  showFirstLastButtons: true,
                  arrowHeadColor: CustomColors.borderGradient.colors.first,
                  dataRowMaxHeight: 57.h,

                  columns: [
                    DataColumn(
                      label: Text('Full Name', style: headingTextStyle),
                    ),
                    DataColumn(
                      label: Text('Phone Number', style: headingTextStyle),
                    ),

                    DataColumn(label: Text('Count', style: headingTextStyle)),

                    DataColumn(
                      label: Column(
                        children: [
                          Text('Total Amount', style: headingTextStyle),
                          Text('(Earned)', style: headingTextStyle),
                        ],
                      ),
                    ),

                    DataColumn(
                      label: Text('Withdraw', style: headingTextStyle),
                    ),

                    DataColumn(
                      label: Column(
                        children: [
                          Text('Wallet Amount', style: headingTextStyle),
                          Text('(Balance)', style: headingTextStyle),
                        ],
                      ),
                    ),
                  ],
                  source: ReferDataTableSource(
                    3,
                    context,
                    widget.innerNavigatorKey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferDataTableSource extends DataTableSource {
  final BuildContext context;
  final GlobalKey<NavigatorState>? innerNavigatorKey;
  final int totalCount;

  ReferDataTableSource(this.totalCount, this.context, this.innerNavigatorKey);

  @override
  DataRow getRow(int index) {
    // if (users.isEmpty) {
    //   return DataRow(
    //     cells: List<DataCell>.generate(6, (_) => const DataCell(Text(''))),
    //   );
    // }

    // final actualIndex = index % users.length;
    // final user = users[actualIndex];

    void handleRowTap() {
      innerNavigatorKey?.currentState?.push(
        MaterialPageRoute(builder: (context) => ReferUserDetails()),
      );
    }

    return DataRow(
      cells: [
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text(
                "Patrick",
                style: context.inter50016.copyWith(
                  color: CustomColors.buttonColor1,
                  fontSize: 16.fSize,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text(
                "6873464366",
                style: context.inter50016.copyWith(
                  fontSize: 16.fSize,
                  color: CustomColors.textColorDark,
                ),
              ),
            ),
          ),
        ),

        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text(
                "10",
                style: context.inter50016.copyWith(
                  color: CustomColors.textColorDark,
                  fontSize: 16.fSize,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Container(
                width: 100.h,
                height: 40.v,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CustomPadding.padding),
                  color: Color(0xffF4F5F6),
                ),
                child: Center(
                  child: Text(
                    "₹400.00",
                    style: context.inter50014.copyWith(
                      fontSize: 14.fSize,
                      color: CustomColors.textColorDarkGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text(
                "₹250.00",
                style: context.inter50016.copyWith(
                  color: CustomColors.green,
                  fontSize: 16.fSize,
                ),
              ),
            ),
          ),
        ),
        // DataCell(
        //   InkWell(
        //     onTap: handleRowTap,
        //     child: Center(child: Text(user.website)),
        //   ),
        // ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Container(
                width: 100.h,
                height: 40.v,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CustomPadding.padding),
                  color: Color(0xffDCEEF0),
                ),
                child: Center(
                  child: Text(
                    "₹150.00",
                    style: context.inter50014.copyWith(
                      color: CustomColors.buttonColor1,
                      fontSize: 14.fSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}
