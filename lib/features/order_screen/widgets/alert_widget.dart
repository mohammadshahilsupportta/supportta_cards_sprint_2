import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

Future<bool> showConfirmationDialog(
  BuildContext context,
  String action,
  String message,
) async {
  return await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: CustomColors.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(action, style: context.inter60020),
              ),
              content: SizedBox(
                height: 100, // You can adjust this height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style: context.inter40016.copyWith(color: Colors.black87),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actionsPadding: const EdgeInsets.only(bottom: 16),
              actions: [
                MiniGradientBorderButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                MiniLoadingButton(
                  useGradient: true,
                  needRow: false,
                  text: 'Yes',
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
      ) ??
      false;
}
