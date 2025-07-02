import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class AddImageContainer extends StatelessWidget {
  final VoidCallback? onTapEdit;
  final String? imageUrl;
  final Uint8List? previewBytes;
  final bool isImageView; // Add this parameter

  const AddImageContainer({
    super.key,
    this.onTapEdit,
    this.imageUrl,
    this.previewBytes,
    this.isImageView = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isImageView ? double.infinity : 200,
      height: 200,
      decoration: BoxDecoration(
        color: CustomColors.hoverColor,
        borderRadius: BorderRadius.circular(CustomPadding.padding),
        border: Border.all(color: CustomColors.hoverColor, width: 1),
      ),
      child: Stack(
        children: [
          if (previewBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(CustomPadding.padding),
              child: Image.memory(
                previewBytes!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else if (imageUrl != null && imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(CustomPadding.padding),
              child: Image.network(
                imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  logError('Error loading image: $error');
                  return Center(
                    child: Icon(
                      LucideIcons.image,
                      color: CustomColors.hoverColor,
                      size: SizeUtils.height * 0.1,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
              ),
            )
          else
            Center(
              child: Icon(
                LucideIcons.image,
                color: CustomColors.hoverColor,
                size: SizeUtils.height * 0.1,
              ),
            ),
          // Only show edit button if not in image view mode and onTapEdit is provided
          if (!isImageView && onTapEdit != null)
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: onTapEdit,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: CustomColors.borderGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    previewBytes != null ||
                            (imageUrl != null && imageUrl!.isNotEmpty)
                        ? Icons.edit
                        : LucideIcons.plus,
                    color: CustomColors.secondaryColor,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:taproot_admin/exporter/exporter.dart';

// class AddImageContainer extends StatelessWidget {
//   final bool isImageView;
//   final String? path;

//   const AddImageContainer({super.key, this.isImageView = false, this.path});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: CustomPadding.paddingLarge.v),
//       child: Container(
//         width: 200.v,
//         height: 150.h,
//         decoration: BoxDecoration(
//           color: CustomColors.lightGreen,
//           borderRadius: BorderRadius.circular(CustomPadding.padding.v),
//         ),
//         child:
//             isImageView
//                 ? ClipRRect(
//                   borderRadius: BorderRadius.circular(CustomPadding.padding.v),
//                   child: Image.network(path.toString(), fit: BoxFit.cover),
//                 )
//                 : Center(
//                   child: Icon(
//                     Icons.add,
//                     size: 40.v,
//                     color: CustomColors.greenDark,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
