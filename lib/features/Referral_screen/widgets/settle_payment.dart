import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/Referral_screen/data/referral_settings_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';

class SettlePayment extends StatefulWidget {
  const SettlePayment({super.key});

  @override
  State<SettlePayment> createState() => _SettlePaymentState();
}

class _SettlePaymentState extends State<SettlePayment> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.textColorLight,
      title: Text('Settle Payment'),
      content: SizedBox(
        height: SizeUtils.height * .7,
        width: SizeUtils.width * .3,
        child: Column(
          children: [
            Divider(thickness: 0.5),
            CustomGap.gapLarge,
            CommonProductContainer(
              title: 'Personal Details',
              children: [
                DetailRow(label: 'Full Name', value: 'Patrick'),
                CustomGap.gapLarge,
              ],
            ),
            CommonProductContainer(
              title: 'Additional Details',
              children: [
                DetailRow(label: 'Account Holder Name', value: 'Patrick'),
                DetailRow(label: 'Bank name', value: 'Patrick'),
                DetailRow(label: 'IFSC Code', value: 'Patrick'),
                DetailRow(label: 'Account number', value: 'Patrick'),
                DetailRow(label: 'Branch', value: 'Patrick'),
                CustomGap.gapLarge,
              ],
            ),
            CommonProductContainer(
              title: 'Transaction ID',
              children: [TextFormContainer(labelText: ''), CustomGap.gapLarge],
            ),
          ],
        ),
      ),
    );
  }
}
