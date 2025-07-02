// import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ImageContainer extends StatelessWidget {
  final String imageState;
  final VoidCallback? onTap;
  final VoidCallback? onTapRemove;
  final bool isEdit;
  final String title;
  final IconData icon;
  final String? imageUrl;
  final Uint8List? previewBytes;

  const ImageContainer({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.imageState,
    required this.onTapRemove,
    this.imageUrl,
    this.previewBytes,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        (previewBytes != null || (imageUrl != null && imageUrl!.isNotEmpty));

    return SizedBox(
      width: 160.h,
      height: 200.v,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.inter60012),
          Gap(CustomPadding.padding.v),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.textColorLightGrey,
                borderRadius: BorderRadius.circular(CustomPadding.padding.v),
              ),
              width: 140.h,
              height: 150.v,
              child: Column(
                mainAxisAlignment:
                    isEdit ? MainAxisAlignment.end : MainAxisAlignment.center,
                children: [
                  if (hasImage)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(CustomPadding.padding.v),
                          bottom:
                              isEdit
                                  ? Radius.zero
                                  : Radius.circular(CustomPadding.padding.v),
                        ),
                        child: Stack(
                          children: [
                            if (previewBytes != null)
                              Image.memory(
                                previewBytes!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            else
                              CachedNetworkImage(
                                imageUrl: imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder:
                                    (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.white,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => const Icon(
                                      LucideIcons.image,
                                      color: CustomColors.textColorDarkGrey,
                                    ),
                                memCacheWidth: 140,
                                memCacheHeight: 150,
                                fadeInDuration: const Duration(
                                  milliseconds: 300,
                                ),
                              ),
                            if (isEdit && hasImage)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  hoverColor: Colors.red,
                                  icon: const Icon(Icons.close),
                                  color: CustomColors.secondaryColor,
                                  onPressed: onTapRemove,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  else
                    Icon(
                      LucideIcons.image,
                      color: CustomColors.textColorDarkGrey,
                      size: SizeUtils.height * 0.1,
                    ),
                  if (isEdit)
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: 140.h,
                        height: 30.v,
                        decoration: BoxDecoration(
                          gradient: CustomColors.borderGradient,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(CustomPadding.padding),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              imageState,
                              style: context.inter60012.copyWith(
                                color: CustomColors.secondaryColor,
                              ),
                            ),
                            Gap(8.v),
                            Icon(
                              icon,
                              color: CustomColors.secondaryColor,
                              size: SizeUtils.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
