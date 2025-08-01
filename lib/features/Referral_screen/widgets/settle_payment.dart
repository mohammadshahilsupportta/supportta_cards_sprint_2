import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_service.dart';
import 'package:taproot_admin/features/Referral_screen/models/account_details_model.dart';
import 'package:taproot_admin/features/Referral_screen/models/bank_detail_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class SettlePayment extends StatefulWidget {
  PaymentDetailsResponse paymentDetailsResponse;
  final String userId;
  final String? fullName;
  final bool? accountTypeBank;
  SettlePayment({
    super.key,
    this.fullName,
    required this.accountTypeBank,
    required this.userId,
    required this.paymentDetailsResponse,
  });

  @override
  State<SettlePayment> createState() => _SettlePaymentState();
}

class _SettlePaymentState extends State<SettlePayment> {
  final TextEditingController transactionController = TextEditingController(
    text: '#',
  );
  final _formKey = GlobalKey<FormState>();

  Future<void> redeemBalance() async {
    final paymentData = widget.paymentDetailsResponse.result;

    final isBank = widget.accountTypeBank == true;

    final accountDetails = SettleAccountDetails(
      transactionId:
          '#${transactionController.text.trim().replaceAll('#', '')}',

      // transactionId: transactionController.text.trim(),
      accountHolderName: isBank ? paymentData.accountHolderName : null,
      accountNumber: isBank ? paymentData.accountNumber : null,
      bankName: isBank ? paymentData.bankName : null,
      branch: isBank ? paymentData.branch : null,
      ifsc: isBank ? paymentData.ifsc : null,
      upiID: !isBank ? paymentData.upiID : null,
      upiUserName: !isBank ? paymentData.accountHolderName : null,
    );

    try {
      final response = await ReferService.settlePaymentToBank(
        userId: widget.userId,
        accountData: accountDetails,
      );
      logSuccess(response);
    } catch (e) {
      logError("Payment failed: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.textColorLight,
      title: Text('Settle Payment'),
      content: SizedBox(
        height: SizeUtils.height * .6,
        width: SizeUtils.width * .3,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Divider(thickness: 0.5),
                CustomGap.gapLarge,
                CommonProductContainer(
                  title: 'Personal Details',
                  children: [
                    DetailRow(
                      label: 'Full Name',
                      value: widget.fullName ?? '-',
                    ),
                    CustomGap.gapLarge,
                  ],
                ),

                if (widget.accountTypeBank == null) ...[
                  CommonProductContainer(
                    title: 'Additional Details',
                    children: [
                      CustomGap.gapXL,

                      Center(child: Text('Details not added')),
                      CustomGap.gapXL,
                    ],
                  ),
                ] else if (widget.accountTypeBank == true) ...[
                  CommonProductContainer(
                    title: 'Bank Account Details',
                    children: [
                      DetailRow(label: 'Account Holder Name', value: 'Patrick'),
                      DetailRow(label: 'Bank Name', value: 'Bank of Flutter'),
                      DetailRow(label: 'IFSC Code', value: 'FLUT0001234'),
                      DetailRow(label: 'Account Number', value: '1234567890'),
                      DetailRow(label: 'Branch', value: 'Kochi'),
                      CustomGap.gapLarge,
                    ],
                  ),
                ] else if (widget.accountTypeBank == false) ...[
                  CommonProductContainer(
                    title: 'UPI Details',
                    children: [
                      DetailRow(label: 'UPI ID', value: 'patrick@upi'),
                      DetailRow(label: 'Name', value: 'Patrick'),
                      CustomGap.gapLarge,
                    ],
                  ),
                ],
                widget.accountTypeBank == null
                    ? SizedBox()
                    : CommonProductContainer(
                      title: 'Transaction ID',
                      children: [
                        TextFormContainer(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Transaction ID is required';
                            } else if (value.length != 12) {
                              return 'Transaction ID must be exactly 12 digits';
                            }
                            return null;
                          },
                          labelText: '',
                          controller: transactionController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                        ),
                        CustomGap.gapLarge,
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        MiniGradientBorderButton(
          text: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        MiniLoadingButton(
          text: 'Confirm',
          needRow: false,

          useGradient: true,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              redeemBalance();
            }
          },
        ),
      ],
    );
  }
}
