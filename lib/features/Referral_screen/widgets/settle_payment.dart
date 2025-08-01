import 'package:flutter/material.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/services/size_utils.dart';
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
      title: Text('Settle Payment'),
      content: SizedBox(
        height: SizeUtils.height * .6,
        width: SizeUtils.width * .3,
        child: Column(
          children: [
            Divider(thickness: 0.5),
            CommonProductContainer(
              title: 'Personal Details',
              children: [DetailRow(label: 'Full Name', value: 'Patrick')],
            ),
          ],
        ),
      ),
    );
  }
}
