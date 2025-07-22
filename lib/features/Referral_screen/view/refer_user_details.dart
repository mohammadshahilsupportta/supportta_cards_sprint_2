import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Referral_screen/data/bank_detail_model.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_detail_model.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_service.dart';
import 'package:taproot_admin/features/Referral_screen/data/transaction_wallet_model.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/common_details_container.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/refer_detail_widget.dart';
import 'package:taproot_admin/features/Referral_screen/widgets/shimmer.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class ReferUserDetails extends StatefulWidget {
  final String userId;
  const ReferUserDetails({super.key, required this.userId});

  @override
  State<ReferUserDetails> createState() => _ReferUserDetailsState();
}

class _ReferUserDetailsState extends State<ReferUserDetails>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController _shimmerController;
  WalletDetailsResponse? walletResult;
  PaymentDetailsResponse? paymentResult;
  SimpleTransactionResponse? simpleTransactions;
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();

    _shimmerController = InstagramShimmer.createController(this);
    fetchData();
    // fetchWalletDetails();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Initialize variables to store API responses
      WalletDetailsResponse? walletResponse;
      PaymentDetailsResponse? paymentResponse;
      SimpleTransactionResponse? transactionsResponse;

      // Fetch wallet details
      try {
        walletResponse = await ReferService.fetchWalletDetails(widget.userId);
        logInfo('Wallet details fetched successfully');
      } catch (e) {
        logError('Error fetching wallet details: $e');
      }

      // Fetch payment details
      try {
        paymentResponse = await ReferService.fetchPaymentDetails(widget.userId);
        logInfo('Payment details fetched successfully');
      } catch (e) {
        logError('Error fetching payment details: $e');
      }

      // Fetch transactions
      try {
        transactionsResponse = await ReferService.fetchSimpleTransactions(
          widget.userId,
        );
        logInfo('Transactions fetched successfully');
      } catch (e) {
        logError('Error fetching transactions: $e');
      }

      // Check if widget is still mounted
      if (!mounted) return;

      // Update state with whatever data we have
      setState(() {
        walletResult = walletResponse;
        paymentResult = paymentResponse;
        simpleTransactions = transactionsResponse;
        isLoading = false;
      });
    } catch (e) {
      logError('Error in fetchData: $e');
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> fetchData() async {
  //   try {
  //     // Fetch both wallet and payment details in parallel
  //     final futures = await Future.wait([
  //       ReferService.fetchWalletDetails(widget.userId),
  //       ReferService.fetchPaymentDetails(widget.userId),
  //       ReferService.fetchSimpleTransactions('686cb1f6a15833d5297c7b13'),
  //     ]);

  //     if (!mounted) return;

  //     Future.microtask(() {
  //       setState(() {
  //         walletResult = futures[0] as WalletDetailsResponse;
  //         paymentResult = futures[1] as PaymentDetailsResponse;
  //         simpleTransactions = futures[2] as SimpleTransactionResponse;
  //         isLoading = false;
  //       });
  //     });
  //   } catch (e) {
  //     logError('Error fetching data: $e');
  //     if (!mounted) return;

  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final totalAmountEarned =
        walletResult != null
            ? '₹${walletResult!.result.wallet.totalEarned.toStringAsFixed(2)}'
            : '₹0.00';
    final balanceAmount =
        walletResult != null
            ? '₹${walletResult!.result.wallet.balance.toStringAsFixed(2)}'
            : '₹0.00';
    final withdrawedAmount =
        walletResult != null
            ? '₹${walletResult!.result.wallet.totalWithdrawn.toStringAsFixed(2)}'
            : '₹0.00';
    final referCount =
        walletResult != null ? '${walletResult!.result.referralCount}' : '0';

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

            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child:
                  isLoading
                      ? InstagramShimmer.shimmerRow(
                        key: ValueKey('shimmer-summary-row'),
                        controller: _shimmerController,
                        flexValues: [2, 3, 3, 3],
                      )
                      : Row(
                        key: ValueKey('loaded-summary-row'),
                        children: [
                          ReferDetailWidget(
                            flex: 2,
                            titleText: 'No:of Purchases ',
                            bodyText: referCount,
                          ),
                          ReferDetailWidget(
                            flex: 3,
                            titleText: 'Total Amount ( Earned )',
                            bodyText: totalAmountEarned,
                          ),
                          ReferDetailWidget(
                            flex: 3,
                            titleText: 'Withdraw',
                            bodyText: withdrawedAmount,
                          ),
                          ReferDetailWidget(
                            needGradient: true,
                            flex: 3,
                            titleText: 'Wallet Amount ( Balance )',
                            titleTextColor: CustomColors.textColorDark,
                            bodyText: balanceAmount,
                          ),
                        ],
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: CustomPadding.paddingLarge,
                        ),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child:
                              isLoading
                                  ? InstagramShimmer.shimmerContainer(
                                    key: ValueKey('shimmer-personal'),
                                    controller: _shimmerController,
                                    height: SizeUtils.height * .22,
                                    child:
                                        InstagramShimmer.personalDetailsPlaceholder(),
                                  )
                                  : CommonDetailsContainer(
                                    key: ValueKey('loaded-personal'),
                                    height: SizeUtils.height * .22,
                                    title: 'Personal Details',
                                    children: [
                                      DetailRow(
                                        label: 'Full Name',
                                        value:
                                            walletResult?.result.user.name ??
                                            "",
                                      ),
                                      DetailRow(
                                        label: 'Email',
                                        value:
                                            walletResult?.result.user.email ??
                                            "",
                                      ),
                                      DetailRow(
                                        label: 'Phone Number',
                                        value:
                                            walletResult
                                                ?.result
                                                .user
                                                .phoneNumber ??
                                            "",
                                      ),
                                    ],
                                  ),
                        ),
                      ),

                      Gap(CustomPadding.paddingLarge),

                      Container(
                        padding: EdgeInsets.only(
                          left: CustomPadding.paddingLarge,
                        ),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child:
                              isLoading
                                  ? InstagramShimmer.shimmerContainer(
                                    key: ValueKey('shimmer-account'),
                                    controller: _shimmerController,
                                    height: SizeUtils.height * .41,
                                    child:
                                        InstagramShimmer.accountDetailsPlaceholder(),
                                  )
                                  : CommonDetailsContainer(
                                    key: ValueKey('loaded-account'),
                                    height:
                                        paymentResult?.result.defaultAcc ==
                                                'Bank_Account'
                                            ? SizeUtils.height * .3
                                            : SizeUtils.height * .2,
                                    title: 'Account Details',
                                    children: [
                                      if (paymentResult?.result.defaultAcc ==
                                          'Bank_Account') ...[
                                        DetailRow(
                                          label: 'Account Holder Name',
                                          value:
                                              paymentResult
                                                  ?.result
                                                  .accountHolderName ??
                                              'Not provided',
                                        ),
                                        DetailRow(
                                          label: 'Bank name',
                                          value:
                                              paymentResult?.result.bankName ??
                                              'Not provided',
                                        ),
                                        DetailRow(
                                          label: 'IFSC Code',
                                          value:
                                              paymentResult?.result.ifsc ??
                                              'Not provided',
                                        ),
                                        DetailRow(
                                          label: 'Account number',
                                          value:
                                              paymentResult
                                                  ?.result
                                                  .accountNumber
                                                  .toString() ??
                                              'Not provided',
                                        ),
                                        DetailRow(
                                          label: 'Branch',
                                          value:
                                              paymentResult?.result.bankName ??
                                              'Not provided',
                                        ),
                                      ],
                                      if (paymentResult?.result.defaultAcc ==
                                          'UPI') ...[
                                        DetailRow(
                                          label: 'UPI Id',
                                          value:
                                              paymentResult?.result.upiID ??
                                              'Not provided',
                                        ),
                                        DetailRow(
                                          label: 'Name',
                                          value:
                                              paymentResult
                                                  ?.result
                                                  .accountHolderName ??
                                              'Not provided',
                                        ),
                                      ],
                                    ],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(CustomPadding.paddingLarge),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: CustomPadding.paddingLarge),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child:
                          isLoading
                              ? InstagramShimmer.shimmerContainer(
                                key: ValueKey('shimmer-transactions'),
                                controller: _shimmerController,
                                height: SizeUtils.height * .63,
                                child:
                                    InstagramShimmer.transactionsPlaceholder(),
                              )
                              : CommonDetailsContainer(
                                key: ValueKey('loaded-transactions'),
                                title: 'Transactions',
                                children: [
                                  SizedBox(
                                    height: SizeUtils.height * .4,
                                    child:
                                        simpleTransactions
                                                    ?.transactions
                                                    .isEmpty ??
                                                true
                                            ? Center(
                                              child: Text(
                                                'No transactions found',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            )
                                            : ListView.separated(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    CustomPadding.paddingLarge,
                                              ),
                                              separatorBuilder: (
                                                context,
                                                index,
                                              ) {
                                                return Divider();
                                              },
                                              itemCount:
                                                  simpleTransactions
                                                      ?.transactions
                                                      .length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                final transaction =
                                                    simpleTransactions!
                                                        .transactions[index];
                                                return TransactionListItem(
                                                  transaction: transaction,
                                                );
                                              },
                                            ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ],
            ),

            Gap(CustomPadding.paddingXXL),
          ],
        ),
      ),
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final SimpleTransaction transaction;
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: CustomPadding.padding,
        horizontal: CustomPadding.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Transaction icon

          // Transaction details
          Text(
            transaction.getDisplayCode(),
            style: context.inter40016.copyWith(
              // color: CustomColors.textColorDarkGrey,
              color: transaction.getAmountColor(),
            ),
          ),
          Text(
            dateFormat.format(transaction.date),
            style: context.inter40016.copyWith(
              color: transaction.getAmountColor(),
              // CustomColors.textColorDarkGrey,
            ),
          ),

          // Date and amount
          Text(
            transaction.getFormattedAmount(),
            style: context.inter60014.copyWith(
              color: transaction.getAmountColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// class TransactionListItem extends StatelessWidget {
//   final SimpleTransaction transaction;
//   final DateFormat dateFormat = DateFormat('dd MMM yyyy');

//   TransactionListItem({required this.transaction});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: CustomPadding.padding,
//         horizontal: CustomPadding.paddingSmall,
//       ),
//       child: Row(
//         children: [
//           // Transaction icon
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color:
//                   transaction.isCredit
//                       ? CustomColors.green.withAlpha(26)
//                       : CustomColors.textColorDarkGrey.withAlpha(26),
//             ),
//             child: Icon(
//               transaction.isCredit
//                   ? LucideIcons.arrowDownLeft
//                   : LucideIcons.arrowUpRight,
//               color: transaction.getAmountColor(),
//               size: 20,
//             ),
//           ),

//           Gap(CustomPadding.padding),

//           // Transaction details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   transaction.getDescription(),
//                   style: context.inter60014.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Gap(4),
//                 Text(
//                   transaction.getDisplayCode(),
//                   style: context.inter40016.copyWith(
//                     color: CustomColors.textColorDarkGrey,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Date and amount
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 transaction.getFormattedAmount(),
//                 style: context.inter60014.copyWith(
//                   color: transaction.getAmountColor(),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Gap(4),
//               Text(
//                 dateFormat.format(transaction.date),
//                 style: context.inter40016.copyWith(
//                   color: CustomColors.textColorDarkGrey,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
