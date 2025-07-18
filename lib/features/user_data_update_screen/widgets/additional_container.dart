import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/image_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/launch_url.dart';

import '../../users_screen/data/user_data_model.dart';

class AdditionalContainer extends StatefulWidget {
  final TextEditingController? primaryWebsiteController;
  final TextEditingController? secondaryWebsiteController;
  final PortfolioDataModel? portfolio;
  final bool isEdit;
  final User user;
  final String? bannerImageUrl;
  final String? logoImageUrl;
  final Function(PlatformFile file)? onLogoSelected;
  final Function(PlatformFile file)? onBannerSelected;
  final Function()? onLogoRemoved;
  final Function()? onBannerRemoved;

  const AdditionalContainer({
    super.key,
    required this.user,
    this.isEdit = false,
    this.portfolio,
    this.primaryWebsiteController,
    this.secondaryWebsiteController,
    this.bannerImageUrl,
    this.logoImageUrl,
    this.onLogoSelected,
    this.onBannerSelected,
    this.onLogoRemoved,
    this.onBannerRemoved,
  });

  @override
  State<AdditionalContainer> createState() => _AdditionalContainerState();
}

class _AdditionalContainerState extends State<AdditionalContainer> {
  PlatformFile? pickedLogoImage;
  PlatformFile? pickedBannerImage;
  Uint8List? previewLogoBytes;
  Uint8List? previewBannerBytes;
  bool isLogoRemoved = false;
  bool isBannerRemoved = false;

  void _pickImage({required bool isLogo}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          if (isLogo) {
            pickedLogoImage = result.files.first;
            previewLogoBytes = pickedLogoImage!.bytes;
            widget.onLogoSelected?.call(pickedLogoImage!);
          } else {
            pickedBannerImage = result.files.first;
            previewBannerBytes = pickedBannerImage!.bytes;
            widget.onBannerSelected?.call(pickedBannerImage!);
          }
        });
      }
    } catch (e) {
      logError('Error picking or uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
      }
    }
  }

  // void _removeLogoImage() {
  //   setState(() {
  //     previewLogoBytes = null;
  //   });
  // }

  // void _removeBannerImage() {
  //   setState(() {
  //     previewBannerBytes = null;
  //   });
  // }
  void _removeLogoImage() {
    setState(() {
      previewLogoBytes = null;
      isLogoRemoved = true;
      widget.onLogoRemoved?.call();
    });
  }

  void _removeBannerImage() {
    setState(() {
      previewBannerBytes = null;
      isBannerRemoved = true;
      widget.onBannerRemoved?.call();
    });
  }

  String getPrimaryWebsite() {
    final link = widget.portfolio?.workInfo?.primaryWebsite;
    return (link != null && link.trim().isNotEmpty)
        ? link
        : 'No Data Available';
  }

  String getSecondaryWebsite() {
    final link = widget.portfolio?.workInfo?.secondaryWebsite;
    return (link != null && link.trim().isNotEmpty)
        ? link
        : 'No Data Available';
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      height: SizeUtils.height * .34,

      title: 'Additional Details',
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  widget.isEdit
                      ? TextFormContainer(
                        controller: widget.primaryWebsiteController,
                        labelText: 'Website Link',
                      )
                      : DetailRow(
                        label: 'Website Link',
                        value: getPrimaryWebsite(),
                        // value:
                        //     widget.portfolio?.workInfo?.primaryWebsite ??
                        //     'loading....',
                        ontap:
                            () => launchWebsiteLink(
                              widget.portfolio?.workInfo?.primaryWebsite ?? '',
                              context,
                            ),
                      ),
                  widget.isEdit
                      ? TextFormContainer(
                        controller: widget.secondaryWebsiteController,
                        labelText: 'Website Link',
                      )
                      : DetailRow(
                        label: 'Website Link',
                        value: getSecondaryWebsite(),
                        // value:
                        //     widget.portfolio?.workInfo?.secondaryWebsite ?? '-',
                        ontap:
                            () => launchWebsiteLink(
                              widget.portfolio?.workInfo?.secondaryWebsite ??
                                  '',
                              context,
                            ),
                      ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: CustomPadding.paddingXL.v),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    children: [
                      ImageContainer(
                        onTapRemove: widget.isEdit ? _removeLogoImage : null,
                        previewBytes: previewLogoBytes,
                        imageUrl: isLogoRemoved ? null : widget.logoImageUrl,
                        // imageUrl: widget.logoImageUrl,
                        isEdit: widget.isEdit,
                        icon:
                            (previewLogoBytes == null &&
                                    (widget.logoImageUrl == null ||
                                        widget.logoImageUrl!.isEmpty))
                                ? LucideIcons.upload
                                : LucideIcons.repeat,
                        // icon:
                        //     previewLogoBytes == null
                        //         ? LucideIcons.upload
                        //         : LucideIcons.repeat,
                        title: 'Logo',
                        onTap:
                            widget.isEdit
                                ? () => _pickImage(isLogo: true)
                                : null,
                        imageState:
                            (previewLogoBytes == null &&
                                    (widget.logoImageUrl == null ||
                                        widget.logoImageUrl!.isEmpty))
                                ? 'Upload'
                                : 'Replace',

                        // imageState:
                        //     previewLogoBytes == null ? 'Upload' : 'Replace',
                      ),
                      Gap(16.h),
                      ImageContainer(
                        onTapRemove: widget.isEdit ? _removeBannerImage : null,
                        previewBytes: previewBannerBytes,
                        imageUrl:
                            isBannerRemoved ? null : widget.bannerImageUrl,
                        // imageUrl: widget.bannerImageUrl,
                        isEdit: widget.isEdit,
                        icon:
                            (previewBannerBytes == null &&
                                    (widget.bannerImageUrl == null ||
                                        widget.bannerImageUrl!.isEmpty))
                                ? LucideIcons.upload
                                : LucideIcons.repeat,
                        title: 'Banner Image',
                        onTap:
                            widget.isEdit
                                ? () => _pickImage(isLogo: false)
                                : null,
                        imageState:
                            (previewBannerBytes == null &&
                                    (widget.bannerImageUrl == null ||
                                        widget.bannerImageUrl!.isEmpty))
                                ? 'Upload'
                                : 'Replace',

                        // imageState:
                        //     previewBannerBytes == null ? 'Upload' : 'Replace',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
