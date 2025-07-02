import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ServiceCard extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isEdited;
  final String title;
  final String description;
  final String? imageUrl;
  final bool isAddCard;

  const ServiceCard({
    required this.title,
    this.isEdited = false,
    required this.description,
    this.onTap,
    super.key,
    this.imageUrl,
    this.isAddCard = false,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {




  @override
  Widget build(BuildContext context) {
    if (widget.isAddCard) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
          height: 400.v,
          width: 330.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomPadding.padding),
            border: Border.all(
              color: CustomColors.textColorLightGrey,
              // style: BorderStyle.dashed, // Removed as BorderStyle does not support 'dashed'
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(CustomPadding.padding),
                decoration: BoxDecoration(
                  gradient: CustomColors.borderGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.plus,
                  color: CustomColors.secondaryColor,
                  size: 32,
                ),
              ),
              Gap(CustomPadding.padding.v),
              Text(
                'Add Service',
                style: context.inter50016.copyWith(
                  color: CustomColors.burgandryRed,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
      height: 400.v,
      width: 330.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CustomPadding.padding),
        border: Border.all(color: CustomColors.textColorLightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.title, style: context.inter50016),
              Spacer(),
              if (widget.isEdited) ...[
                TextButton(
                  onPressed: widget.onTap,
                  child: Text(
                    'Edit',
                    style: context.inter60012.copyWith(
                      color: CustomColors.greenDark,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Delete',
                    style: context.inter60012.copyWith(color: CustomColors.red),
                  ),
                ),
              ],
            ],
          ),
          Gap(CustomPadding.padding.v),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 155.v,
                  decoration: BoxDecoration(
                    color: CustomColors.textColorLightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:
                      widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              widget.imageUrl!,
                              width: double.infinity,
                              height: 155.v,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    LucideIcons.image,
                                    color: CustomColors.textColorDarkGrey,
                                    size: SizeUtils.height * 0.1,
                                  ),
                                );
                              },
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                            ),
                          )
                          : Center(
                            child: Icon(
                              LucideIcons.image,
                              color: CustomColors.textColorDarkGrey,
                              size: SizeUtils.height * 0.1,
                            ),
                          ),
                ),
              ),
            ],
          ),
          Gap(CustomPadding.padding.v),
          Text(
            'Description',
            style: context.inter50014.copyWith(
              color: CustomColors.textFieldBorderGrey,
            ),
          ),
          Gap(CustomPadding.padding.v),
          Expanded(
            child: SingleChildScrollView(
              child: Text(widget.description, style: context.inter40016),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
// import 'package:taproot_admin/exporter/exporter.dart';

// class ServiceCard extends StatefulWidget {
//   final VoidCallback? onTap;
//   final bool isEdited;
//   final String title;
//   final String description;
//   final String? imageUrl;
//   const ServiceCard({
//     required this.title,
//     this.isEdited = false,
//     required this.description,
//     this.onTap,
//     super.key,
//     this.imageUrl,
//   });

//   @override
//   State<ServiceCard> createState() => _ServiceCardState();
// }

// class _ServiceCardState extends State<ServiceCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
//       height: 400.v,
//       width: 330.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(CustomPadding.padding),
//         border: Border.all(color: CustomColors.textColorLightGrey),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(widget.title, style: context.inter50016),
//               Spacer(),
//               widget.isEdited
//                   ? TextButton(
//                     onPressed: widget.onTap,
//                     child: Text(
//                       'Edit',
//                       style: context.inter60012.copyWith(
//                         color: CustomColors.greenDark,
//                       ),
//                     ),
//                   )
//                   : SizedBox(),
//               widget.isEdited
//                   ? TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       'Delete',
//                       style: context.inter60012.copyWith(
//                         color: CustomColors.red,
//                       ),
//                     ),
//                   )
//                   : SizedBox(),
//             ],
//           ),
//           Gap(CustomPadding.padding.v),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   height: 155.v,
//                   decoration: BoxDecoration(
//                     color: CustomColors.textColorLightGrey,
//                   ),
//                   child:
//                       widget.imageUrl != null && widget.imageUrl!.isNotEmpty
//                           ? ClipRRect(
//                             borderRadius: BorderRadius.circular(4),
//                             child: Image.network(
//                               widget.imageUrl!,
//                               width: double.infinity,
//                               height: 155.v,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Center(
//                                   child: Icon(
//                                     LucideIcons.image,
//                                     color: CustomColors.textColorDarkGrey,
//                                     size: SizeUtils.height * 0.1,
//                                   ),
//                                 );
//                               },
//                               loadingBuilder: (
//                                 context,
//                                 child,
//                                 loadingProgress,
//                               ) {
//                                 if (loadingProgress == null) return child;
//                                 return Center(
//                                   child: CircularProgressIndicator(
//                                     value:
//                                         loadingProgress.expectedTotalBytes !=
//                                                 null
//                                             ? loadingProgress
//                                                     .cumulativeBytesLoaded /
//                                                 loadingProgress
//                                                     .expectedTotalBytes!
//                                             : null,
//                                   ),
//                                 );
//                               },
//                             ),
//                           )
//                           : Center(
//                             child: Icon(
//                               LucideIcons.image,
//                               color: CustomColors.textColorDarkGrey,
//                               size: SizeUtils.height * 0.1,
//                             ),
//                           ),
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             'Description',
//             style: context.inter50014.copyWith(
//               color: CustomColors.textFieldBorderGrey,
//             ),
//           ),
//           Gap(CustomPadding.padding.v),
//           Expanded(
//             child: SizedBox(
//               child: SingleChildScrollView(
//                 child: Text(widget.description, style: TextStyle()),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:taproot_admin/exporter/exporter.dart';

// class ServiceCard extends StatelessWidget {
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final bool isEdited;
//   final String title;
//   final String description;

//   const ServiceCard({
//     Key? key,
//     required this.title,
//     required this.description,
//     this.isEdited = false,
//     this.onEdit,
//     this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
//       height: 400.v,
//       width: 330.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(CustomPadding.padding),
//         border: Border.all(color: CustomColors.textColorLightGrey),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(child: Text(title, style: context.inter50016)),
//               if (isEdited) ...[
//                 TextButton(
//                   onPressed: onEdit,
//                   child: Text(
//                     'Edit',
//                     style: context.inter60012.copyWith(
//                       color: CustomColors.greenDark,
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: onDelete,
//                   child: Text(
//                     'Delete',
//                     style: context.inter60012.copyWith(color: CustomColors.red),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//           Gap(CustomPadding.padding.v),
//           Expanded(child: SingleChildScrollView(child: Text(description))),
//         ],
//       ),
//     );
//   }
// }
