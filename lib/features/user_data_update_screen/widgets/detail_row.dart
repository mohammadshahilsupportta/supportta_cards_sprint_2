// import 'package:flutter/material.dart';
// import 'package:taproot_admin/exporter/exporter.dart';

// class DetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final VoidCallback? ontap;

//   const DetailRow({
//     super.key,
//     required this.label,
//     required this.value,
//     this.ontap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isLink = ontap != null;
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: 10,
//         horizontal: CustomPadding.paddingLarge.v,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: context.inter50014.copyWith(fontSize: 14.fSize)),
//           GestureDetector(
//             onTap: ontap,
//             child: Text(
//               value,
//               style: context.inter50014.copyWith(
//                 fontSize: 14.fSize,
//                 color: isLink ? CustomColors.green : Colors.black87,
//                 decoration:
//                     isLink ? TextDecoration.underline : TextDecoration.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? ontap;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final isLink = ontap != null;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: CustomPadding.paddingLarge.v,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left label
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: context.inter50014.copyWith(fontSize: 14.fSize),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          /// Gap between label and value
          SizedBox(width: 16),

          /// Right value
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: ontap,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: context.inter50014.copyWith(
                  fontSize: 14.fSize,
                  color: isLink ? CustomColors.green : Colors.black87,
                  decoration:
                      isLink ? TextDecoration.underline : TextDecoration.none,
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
