import 'package:flutter/material.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

import '../../../exporter/exporter.dart';

class ReferalSettingsDialogBox extends StatefulWidget {
  const ReferalSettingsDialogBox({super.key});

  @override
  State<ReferalSettingsDialogBox> createState() =>
      _ReferalSettingsDialogBoxState();
}

class _ReferalSettingsDialogBoxState extends State<ReferalSettingsDialogBox> {
  int selectedValue = 0;
  int selectedValueFriend = 0;

  TextEditingController controllerPercentage = TextEditingController();
  TextEditingController controllerFlat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.secondaryColor,
      title: Row(
        children: [
          Text(
            'Wallet',
            style: context.inter60016.copyWith(
              color: CustomColors.buttonColor1,
            ),
          ),
          Gap(CustomPadding.paddingLarge),
          Text('>', style: context.inter60014),
          Gap(CustomPadding.paddingLarge),
          Text('Settings  ', style: context.inter60014),
        ],
      ),
      content: SizedBox(
        height: SizeUtils.height * .6,
        width: SizeUtils.width * .3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Gap(CustomPadding.paddingLarge),

            settingsDetailsFields(
              context,
              stepCount: 1,
              headTitle: 'Commission for Referee',
              headSubTitle:
                  'Customer (Referee) will get following commission after a successful referral',
              selectedValue: selectedValue,
              controller: controllerPercentage,
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
              },
            ),

            Gap(CustomPadding.paddingLarge),

            settingsDetailsFields(
              context,
              stepCount: 2,
              headTitle: 'Commission to the referred friends',
              headSubTitle:
                  'Referred friends will get following reward from the referee',
              selectedValue: selectedValueFriend,
              controller: controllerFlat,
              onChanged: (value) {
                setState(() {
                  selectedValueFriend = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        MiniGradientBorderButton(
          text: 'Cancel',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MiniLoadingButton(
          useGradient: true,
          needRow: false,
          onPressed: () {},
          text: 'Save and Activate',
          gradientColors: CustomColors.borderGradient.colors,
        ),
      ],
    );
  }

  Column settingsDetailsFields(
    BuildContext context, {
    required int stepCount,
    required String headTitle,
    required String headSubTitle,
    required int selectedValue,
    required TextEditingController controller,
    required Function(int?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Step $stepCount:', style: context.inter60014),
            Text(
              headTitle,
              style: context.inter50014.copyWith(color: CustomColors.hintGrey),
            ),
          ],
        ),
        Gap(CustomPadding.padding),

        Text(
          headSubTitle,
          style: context.inter40016.copyWith(fontSize: 13.fSize),
        ),
        Gap(CustomPadding.paddingLarge),
        Row(
          children: [
            Row(
              children: [
                Radio<int>(
                  value: 0,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text('Percentage'),
              ],
            ),
            Gap(CustomPadding.paddingLarge),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                ),
                Text('Flat'),
              ],
            ),
          ],
        ),
        Gap(CustomPadding.paddingLarge),
        Row(
          children: [
            Text.rich(
              TextSpan(
                text: selectedValue == 0 ? 'Percentage' : 'Amount',
                style: context.inter60014,
                children: <TextSpan>[
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: CustomColors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          'Referee will get this ${selectedValue == 0 ? 'percentage' : 'flat'} off',
        ),
        Gap(CustomPadding.padding),
        SizedBox(
          height: 35,
          child: TextFormField(
            controller: controller,
            cursorHeight: 20,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            decoration: InputDecoration(
              hintText:
                  'Enter ${selectedValue == 0 ? 'percentage' : 'amount'} here',
              contentPadding: EdgeInsets.symmetric(
                vertical: CustomPadding.paddingSmall,
                horizontal: CustomPadding.padding,
              ),
              suffixText: selectedValue == 0 ? '%' : '',
            ),
            onChanged: (value) {
              if (selectedValue == 0) {
                String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (newValue.isNotEmpty) {
                  int enteredValue = int.tryParse(newValue) ?? 0;
                  if (enteredValue > 100) {
                    controller.text = '100';
                    controller.selection = TextSelection.collapsed(
                      offset: controller.text.length,
                    );
                  } else {
                    controller.text = newValue;
                    controller.selection = TextSelection.collapsed(
                      offset: controller.text.length,
                    );
                  }
                } else {
                  controller.text = '';
                }
              } else if (selectedValue == 1) {
                String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                controller.text = newValue;
                controller.selection = TextSelection.collapsed(
                  offset: controller.text.length,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
