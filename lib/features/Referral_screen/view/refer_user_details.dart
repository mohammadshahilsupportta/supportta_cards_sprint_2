import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/common_details_container.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/refer_detail_widget.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class ReferUserDetails extends StatefulWidget {
  const ReferUserDetails({super.key});

  @override
  State<ReferUserDetails> createState() => _ReferUserDetailsState();
}

class _ReferUserDetailsState extends State<ReferUserDetails> {
  @override
  Widget build(BuildContext context) {
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
                    text: 'Back',
                    icon: LucideIcons.arrowLeft,
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    gradient: LinearGradient(
                      colors: CustomColors.borderGradient.colors,
                    ),
                  ),
                ],
              ),
            ),
            Gap(CustomPadding.paddingXL),
            Row(
              children: [
                ReferDetailWidget(
                  flex: 2,
                  titleText: 'No:of Purchases ',
                  bodyText: '100',
                ),
                ReferDetailWidget(
                  flex: 3,
                  titleText: 'Total Amount ( Earned )',
                  bodyText: '₹400.00',
                ),
                ReferDetailWidget(
                  flex: 3,
                  titleText: 'Withdraw',
                  bodyText: '₹300.00',
                ),
                ReferDetailWidget(
                  needGradient: true,
                  flex: 3,
                  titleText: 'Wallet Amount ( Balance )',
                  titleTextColor: CustomColors.textColorDark,
                  bodyText: '₹100.00',
                ),
              ],
            ),
            Gap(CustomPadding.paddingXL),
            SizedBox(
              width: 400.h,
              child: MiniLoadingButton(
                useGradient: true,
                needRow: false,
                text: 'Settle Payment',
                onPressed: () {},
                gradientColors: CustomColors.borderGradient.colors,
              ),
            ),
            Gap(CustomPadding.paddingXL),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: CustomPadding.paddingLarge,
                        ),

                        child: CommonDetailsContainer(
                          height: SizeUtils.height * .22,
                          title: 'Personal Details',
                          children: [
                            DetailRow(label: 'Full Name', value: 'Patrick'),
                            DetailRow(
                              label: 'Email',
                              value: 'patrick@gmil.com',
                            ),
                            DetailRow(
                              label: 'Phone Number',
                              value: '6873467367',
                            ),
                          ],
                        ),
                      ),
                      Gap(CustomPadding.paddingLarge),
                      Container(
                        padding: EdgeInsets.only(
                          left: CustomPadding.paddingLarge,
                        ),

                        child: CommonDetailsContainer(
                          height: SizeUtils.height * .41,
                          title: 'Account Details',
                          children: [
                            DetailRow(
                              label: 'Account Holder Name',
                              value: 'Patrick',
                            ),
                            DetailRow(
                              label: 'Bank name',
                              value: 'Federal Bank',
                            ),
                            DetailRow(label: 'IFSC Code', value: 'FDRL070987'),
                            DetailRow(
                              label: 'Account number',
                              value: '98766873467367',
                            ),
                            DetailRow(label: 'Branch', value: 'Kottayam'),
                            DetailRow(label: 'UPI Id', value: '6873467367@upi'),
                            DetailRow(label: 'Name', value: 'Patrick'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(CustomPadding.paddingLarge),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: CustomPadding.paddingLarge),

                    child: CommonDetailsContainer(title: 'Transactions'),
                  ),
                ),
              ],
            ),
            Gap(CustomPadding.paddingXL),
          ],
        ),
      ),
    );
  }
}
