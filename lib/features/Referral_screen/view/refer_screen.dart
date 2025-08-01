import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taproot_admin/core/api/dio_helper.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Referral_screen/models/refer_model.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_service.dart';
import 'package:taproot_admin/features/Referral_screen/models/referral_settings_model.dart';
import 'package:taproot_admin/features/Referral_screen/view/refer_user_details.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/referal_settings_dialog_box.dart';
import 'package:taproot_admin/features/product_screen/widgets/search_widget.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/not_found_widget.dart';

import '../../../core/api/base_url_constant.dart';

class ReferScreen extends StatefulWidget {
  final GlobalKey<NavigatorState>? innerNavigatorKey;

  const ReferScreen({super.key, required this.innerNavigatorKey});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  final _tableKey = GlobalKey<PaginatedDataTableState>();
  bool isLoading = true;
  bool isSearching = false;
  String searchQuery = "";
  List<Wallet> wallets = [];
  ReferralSetting? currentReferralSetting;
  String referralSettingsError = '';
  bool isLoadingReferralSettings = false;
  Future<void> fetchReferralSettings() async {
    try {
      setState(() {
        isLoadingReferralSettings = true;
        referralSettingsError = '';
      });

      final response = await ReferService.getCommission();

      if (response.success && response.results.isNotEmpty) {
        // Get the first active setting
        final activeSetting = response.results.firstWhere(
          (setting) => setting.status == 'Active' && !setting.isDeleted,
          orElse: () => response.results.first,
        );

        setState(() {
          currentReferralSetting = activeSetting;
        });
      } else {
        setState(() {
          referralSettingsError = 'No referral settings found';
        });
      }
    } catch (e) {
      setState(() {
        referralSettingsError = 'Failed to load referral settings: $e';
      });
    } finally {
      setState(() {
        isLoadingReferralSettings = false;
      });
    }
  }

  Future<void> fetchWalletData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final responseWallet = await DioHelper().get(
        '/wallet',
        type: ApiType.baseUrl,
        queryParameters: {
          'page': 1,
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      WalletResponse response = WalletResponse.fromJson(responseWallet.data);

      setState(() {
        wallets = response.results;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load wallet data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        isLoading = false;
        wallets = [];
      });
    }
  }

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
      isSearching = true;
    });
    fetchWalletData();
  }

  Future<void> _openSettingsDialog() async {
    final result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ReferalSettingsDialogBox(
          existingSetting: currentReferralSetting,
        );
      },
    );

    if (result == true) {
      await fetchReferralSettings();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWalletData();
    fetchReferralSettings();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headingTextStyle = context.inter60016.copyWith(
      fontSize: 17.fSize,
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
                    onPressed: _openSettingsDialog,

                    //  onPressed: isLoadingReferralSettings ? null : _openSettingsDialog,
                    // onPressed: () {
                    //   showDialog(
                    //     barrierDismissible: false,
                    //     context: context,
                    //     builder: (context) {
                    //       return ReferalSettingsDialogBox(
                    //         existingSetting: currentReferralSetting,
                    //       );
                    //       // return Dialog(
                    //       //   child: Column(
                    //       //     children: [
                    //       //       Row(
                    //       //         children: [
                    //       //           Text('Wallet', style: context.inter60014),
                    //       //         ],
                    //       //       ),
                    //       //     ],
                    //       //   ),
                    //       // );
                    //     },
                    //   );
                    // },
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
              child:
                  wallets.isEmpty
                      ? Column(children: [Gap(250), NotFoundWidget()])
                      : Container(
                        padding: EdgeInsets.all(CustomPadding.paddingLarge),
                        decoration: BoxDecoration(
                          boxShadow: floatingShadowLarge,

                          color: CustomColors.secondaryColor,
                          borderRadius: BorderRadius.circular(
                            CustomPadding.paddingLarge * 2,
                          ),
                        ),
                        child: PaginatedDataTable(
                          headingRowHeight: 60.h,
                          key: _tableKey,
                          dividerThickness: 0.6,
                          header: Row(
                            children: [
                              SearchWidget(
                                hintText: 'Search User ID, Name, Number',
                                iconColor: CustomColors.buttonColor1,
                                // ignore: non_constant_identifier_names
                                onChanged: (Value) {
                                  handleSearch(Value);
                                  _tableKey.currentState?.pageTo(0);
                                },
                              ),
                            ],
                          ),
                          rowsPerPage: 7,
                          showFirstLastButtons: true,
                          arrowHeadColor:
                              CustomColors.borderGradient.colors.first,
                          dataRowMaxHeight: 57.h,

                          columns: [
                            DataColumn(
                              label: Text('Full Name', style: headingTextStyle),
                            ),
                            DataColumn(
                              label: Text(
                                'Phone Number',
                                style: headingTextStyle,
                              ),
                            ),

                            DataColumn(
                              label: Text('Count', style: headingTextStyle),
                            ),

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
                                  Text(
                                    'Wallet Amount',
                                    style: headingTextStyle,
                                  ),
                                  Text('(Balance)', style: headingTextStyle),
                                ],
                              ),
                            ),
                          ],
                          source: ReferDataTableSource(
                            wallets,
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
  // final int totalCount;
  final List<Wallet> wallets;

  ReferDataTableSource(this.wallets, this.context, this.innerNavigatorKey);

  @override
  DataRow getRow(int index) {
    final wallet = wallets[index];
    final double withdrawedBalance = wallet.totalEarned - wallet.balance;

    // if (users.isEmpty) {
    //   return DataRow(
    //     cells: List<DataCell>.generate(6, (_) => const DataCell(Text(''))),
    //   );
    // }

    // final actualIndex = index % users.length;
    // final user = users[actualIndex];

    void handleRowTap() {
      innerNavigatorKey?.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ReferUserDetails(userId: wallet.userData.id),
        ),
      );
    }

    return DataRow(
      cells: [
        DataCell(
          InkWell(
            onTap: handleRowTap,
            child: Center(
              child: Text(
                wallet.userData.name,
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
                wallet.phoneNumber,
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
                wallet.referralCount.toString(),
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
                    '₹${wallet.totalEarned}',

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
                '₹$withdrawedBalance',
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
                    '₹${wallet.balance}',
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
  int get rowCount => wallets.length;

  @override
  int get selectedRowCount => 0;
}
