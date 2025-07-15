import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
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
                    onPressed: () {},

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
                  columns: [
                    DataColumn(
                      label: Text('Full Name', style: headingTextStyle),
                    ),
                    DataColumn(
                      label: Text('Phone Number', style: headingTextStyle),
                    ),

                    DataColumn(label: Text('Count', style: headingTextStyle)),

                    DataColumn(
                      label: Text('Total Amount', style: headingTextStyle),
                    ),

                    DataColumn(
                      label: Text('Withdraw', style: headingTextStyle),
                    ),

                    DataColumn(
                      label: Text('Wallet Amount', style: headingTextStyle),
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
      // logWarning('Row tapped: ${user.fullName}');
      // innerNavigatorKey?.currentState?.push(
      //   MaterialPageRoute(
      //     builder: (context) => UserDataUpdateScreen(user: user),
      //   ),
      // );
    }

    return DataRow(
      cells: [
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text("q", style: TextStyle(fontSize: 16.fSize)),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text("q", style: TextStyle(fontSize: 16.fSize)),
            ),
          ),
        ),

        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text("q", style: TextStyle(fontSize: 16.fSize)),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text("q", style: TextStyle(fontSize: 16.fSize)),
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text("q", style: TextStyle(fontSize: 16.fSize)),
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
              child: Text("q", style: TextStyle(fontSize: 16.fSize)),
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
