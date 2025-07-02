import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class DetailRowCopy extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const DetailRowCopy({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: CustomPadding.paddingLarge.v,
      ),
      child: Row(
        children: [
          Text(label, style: context.inter50014.copyWith(fontSize: 14.fSize)),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Text(
              value,
              style: context.inter50014.copyWith(
                fontSize: 14.fSize,
                color: CustomColors.textFieldBorderGrey,
              ),
            ),
          ),
          Gap(CustomPadding.padding.v),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value)).then((_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Copied'),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      duration: Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              });
            },
            child: Icon(icon, color: CustomColors.green),
          ),
        ],
      ),
    );
  }
}
