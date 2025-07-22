// import 'package:flutter/material.dart';
// import 'package:taproot_admin/constants/constants.dart' as ApiType;
// import 'package:taproot_admin/core/api/dio_helper.dart';
// import 'package:taproot_admin/features/Referral_screen/data/referral_settings_model.dart';
// import 'package:taproot_admin/widgets/mini_gradient_border.dart';
// import 'package:taproot_admin/widgets/mini_loading_button.dart';

// import '../../../exporter/exporter.dart';

// class ReferalSettingsDialogBox extends StatefulWidget {
//   final ReferralSetting? existingSetting;
//   const ReferalSettingsDialogBox({super.key, this.existingSetting});

//   @override
//   State<ReferalSettingsDialogBox> createState() =>
//       _ReferalSettingsDialogBoxState();
// }

// class _ReferalSettingsDialogBoxState extends State<ReferalSettingsDialogBox> {
//   final _formKey = GlobalKey<FormState>();
//   // int selectedValue =0;

//   // int selectedValueFriend = 0;

//   // TextEditingController controllerPercentage = TextEditingController();
//   // TextEditingController controllerFlat = TextEditingController();
//   int selectedCommissionType = 0; // 0 = percentage, 1 = flat
//   TextEditingController commissionController = TextEditingController();

//   // Discount for referee (person who gets referred)
//   int selectedDiscountType = 0; // 0 = percentage, 1 = flat
//   TextEditingController discountController = TextEditingController();

//   void _loadExistingSettings() {
//     if (widget.existingSetting != null) {
//       final setting = widget.existingSetting!;

//       // Load commission settings
//       if (setting.commissionType == CommissionType.Percentage) {
//         selectedCommissionType = 0;
//         commissionController.text =
//             setting.commissionPercentage?.toString() ?? '';
//       } else {
//         selectedCommissionType = 1;
//         commissionController.text = setting.commissionAmount?.toString() ?? '';
//       }

//       // Load discount settings
//       if (setting.discountType == DiscountType.Percentage) {
//         selectedDiscountType = 0;
//         discountController.text = setting.discountPercentage?.toString() ?? '';
//       } else {
//         selectedDiscountType = 1;
//         discountController.text = setting.discountAmount?.toString() ?? '';
//       }
//     }
//   }

//   @override
//   void initState() {
//     _loadExistingSettings();
//     // TODO: implement initState
//     super.initState();
//   }
 
 

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: CustomColors.secondaryColor,
//       title: Row(
//         children: [
//           Text(
//             'Wallet',
//             style: context.inter60016.copyWith(
//               color: CustomColors.buttonColor1,
//             ),
//           ),
//           Gap(CustomPadding.paddingLarge),
//           Text('>', style: context.inter60014),
//           Gap(CustomPadding.paddingLarge),
//           Text('Settings  ', style: context.inter60014),
//         ],
//       ),
//       content: SizedBox(
//         height: SizeUtils.height * .6,
//         width: SizeUtils.width * .3,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Divider(),
//             Gap(CustomPadding.paddingLarge),

//             settingsDetailsFields(
//               context,
//               stepCount: 1,
//               headTitle: 'Commission for Referee',
//               headSubTitle:
//                   'Customer (Referee) will get following commission after a successful referral',
//               selectedValue: selectedCommissionType,
//               controller: commissionController,
//               onChanged: (value) {
//                 setState(() {
//                   selectedCommissionType = value!;
//                   commissionController.clear();
//                 });
//               },
//             ),

//             Gap(CustomPadding.paddingLarge),

//             settingsDetailsFields(
//               context,
//               stepCount: 2,
//               headTitle: 'Commission to the referred friends',
//               headSubTitle:
//                   'Referred friends will get following reward from the referee',
//               selectedValue: selectedDiscountType,
//               controller: discountController,
//               onChanged: (value) {
//                 setState(() {
//                   selectedDiscountType = value!;
//                   discountController.clear();
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         MiniGradientBorderButton(
//           text: 'Cancel',
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         MiniLoadingButton(
//           useGradient: true,
//           needRow: false,
//           onPressed: () {},
//           text: 'Save and Activate',
//           gradientColors: CustomColors.borderGradient.colors,
//         ),
//       ],
//     );
//   }

//   Column settingsDetailsFields(
//     BuildContext context, {
//     required int stepCount,
//     required String headTitle,
//     required String headSubTitle,
//     required int selectedValue,
//     required TextEditingController controller,
//     required Function(int?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('Step $stepCount:', style: context.inter60014),
//             Text(
//               headTitle,
//               style: context.inter50014.copyWith(color: CustomColors.hintGrey),
//             ),
//           ],
//         ),
//         Gap(CustomPadding.padding),

//         Text(
//           headSubTitle,
//           style: context.inter40016.copyWith(fontSize: 13.fSize),
//         ),
//         Gap(CustomPadding.paddingLarge),
//         Row(
//           children: [
//             Row(
//               children: [
//                 Radio<int>(
//                   value: 0,
//                   groupValue: selectedValue,
//                   onChanged: onChanged,
//                 ),
//                 Text('Percentage'),
//               ],
//             ),
//             Gap(CustomPadding.paddingLarge),
//             Row(
//               children: [
//                 Radio<int>(
//                   value: 1,
//                   groupValue: selectedValue,
//                   onChanged: onChanged,
//                 ),
//                 Text('Flat'),
//               ],
//             ),
//           ],
//         ),
//         Gap(CustomPadding.paddingLarge),
//         Row(
//           children: [
//             Text.rich(
//               TextSpan(
//                 text: selectedValue == 0 ? 'Percentage' : 'Amount',
//                 style: context.inter60014,
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: ' *',
//                     style: TextStyle(color: CustomColors.red),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Text(
//           'Referee will get this ${selectedValue == 0 ? 'percentage' : 'flat'} off',
//         ),
//         Gap(CustomPadding.padding),
//         SizedBox(
//           height: 35,
//           child: TextFormField(
//             controller: controller,
//             cursorHeight: 20,
//             textAlignVertical: TextAlignVertical.center,
//             keyboardType: TextInputType.numberWithOptions(decimal: false),
//             decoration: InputDecoration(
//               hintText:
//                   'Enter ${selectedValue == 0 ? 'percentage' : 'amount'} here',
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: CustomPadding.paddingSmall,
//                 horizontal: CustomPadding.padding,
//               ),
//               suffixText: selectedValue == 0 ? '%' : '',
//             ),
//             onChanged: (value) {
//               if (selectedValue == 0) {
//                 String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
//                 if (newValue.isNotEmpty) {
//                   int enteredValue = int.tryParse(newValue) ?? 0;
//                   if (enteredValue > 100) {
//                     controller.text = '100';
//                     controller.selection = TextSelection.collapsed(
//                       offset: controller.text.length,
//                     );
//                   } else {
//                     controller.text = newValue;
//                     controller.selection = TextSelection.collapsed(
//                       offset: controller.text.length,
//                     );
//                   }
//                 } else {
//                   controller.text = '';
//                 }
//               } else if (selectedValue == 1) {
//                 String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
//                 controller.text = newValue;
//                 controller.selection = TextSelection.collapsed(
//                   offset: controller.text.length,
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:taproot_admin/features/Referral_screen/data/refer_service.dart';
import 'package:taproot_admin/features/Referral_screen/data/referral_settings_model.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

import '../../../exporter/exporter.dart';

class ReferalSettingsDialogBox extends StatefulWidget {
  final ReferralSetting? existingSetting;
  const ReferalSettingsDialogBox({super.key, this.existingSetting});

  @override
  State<ReferalSettingsDialogBox> createState() =>
      _ReferalSettingsDialogBoxState();
}

class _ReferalSettingsDialogBoxState extends State<ReferalSettingsDialogBox> {
  final _formKey = GlobalKey<FormState>();
  
  int selectedCommissionType = 0; // 0 = percentage, 1 = flat
  TextEditingController commissionController = TextEditingController();

  // Discount for referee (person who gets referred)
  int selectedDiscountType = 0; // 0 = percentage, 1 = flat
  TextEditingController discountController = TextEditingController();

  bool isSaving = false;

  void _loadExistingSettings() {
    if (widget.existingSetting != null) {
      final setting = widget.existingSetting!;

      // Load commission settings
      if (setting.commissionType == CommissionType.Percentage) {
        selectedCommissionType = 0;
        commissionController.text =
            setting.commissionPercentage?.toString() ?? '';
      } else {
        selectedCommissionType = 1;
        commissionController.text = setting.commissionAmount?.toString() ?? '';
      }

      // Load discount settings
      if (setting.discountType == DiscountType.Percentage) {
        selectedDiscountType = 0;
        discountController.text = setting.discountPercentage?.toString() ?? '';
      } else {
        selectedDiscountType = 1;
        discountController.text = setting.discountAmount?.toString() ?? '';
      }
    }
  }

  @override
  void initState() {
    _loadExistingSettings();
    super.initState();
  }

  Future<void> _saveSettings() async {
    if (commissionController.text.isEmpty || discountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final setting = _createReferralSetting();
      
      if (widget.existingSetting != null) {
        // Update existing setting
        await ReferService.updateReferralSetting(
          widget.existingSetting!.id!,
          setting,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Referral settings updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Create new setting
        await ReferService.createReferralSetting(setting);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Referral settings created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save referral settings: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  ReferralSetting _createReferralSetting() {
    return ReferralSetting(
      id: widget.existingSetting?.id,
      // Commission settings (for referrer)
      commissionType: selectedCommissionType == 0 
          ? CommissionType.Percentage 
          : CommissionType.Flat,
      commissionPercentage: selectedCommissionType == 0 
          ? double.tryParse(commissionController.text) 
          : null,
      commissionAmount: selectedCommissionType == 1 
          ? double.tryParse(commissionController.text) 
          : null,
      
      // Discount settings (for referee)
      discountType: selectedDiscountType == 0 
          ? DiscountType.Percentage 
          : DiscountType.Flat,
      discountPercentage: selectedDiscountType == 0 
          ? double.tryParse(discountController.text) 
          : null,
      discountAmount: selectedDiscountType == 1 
          ? double.tryParse(discountController.text) 
          : null,
      
      status: 'Active',
      isDeleted: false,
      createdAt: widget.existingSetting?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

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
              selectedValue: selectedCommissionType,
              controller: commissionController,
              onChanged: (value) {
                setState(() {
                  selectedCommissionType = value!;
                  commissionController.clear();
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
              selectedValue: selectedDiscountType,
              controller: discountController,
              onChanged: (value) {
                setState(() {
                  selectedDiscountType = value!;
                  discountController.clear();
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
          isLoading: isSaving,
          onPressed: () =>  isSaving ? null : _saveSettings,
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
