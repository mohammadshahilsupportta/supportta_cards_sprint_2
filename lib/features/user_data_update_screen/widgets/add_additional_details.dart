import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/image_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';

class AddAdditionalDetails extends StatefulWidget {
  final TextEditingController primaryWebsitecontroller;
  final TextEditingController secondaryWebsitecontroller;
  final Function(PlatformFile file)? onLogoSelected;
  final Function(PlatformFile file)? onBannerSelected;

  const AddAdditionalDetails({
    super.key,
    required this.primaryWebsitecontroller,
    required this.secondaryWebsitecontroller,
    this.onLogoSelected,
    this.onBannerSelected,
  });

  @override
  State<AddAdditionalDetails> createState() => _AddAdditionalDetailsState();
}

class _AddAdditionalDetailsState extends State<AddAdditionalDetails> {
  PlatformFile? pickedLogoImage;
  PlatformFile? pickedBannerImage;
  Uint8List? previewLogoBytes;
  Uint8List? previewBannerBytes;

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
      logError('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
      }
    }
  }

  void _removeLogoImage() {
    setState(() {
      pickedLogoImage = null;
      previewLogoBytes = null;
    });
  }

  void _removeBannerImage() {
    setState(() {
      pickedBannerImage = null;
      previewBannerBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      title: 'Additional Details',
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextFormContainer(
                    controller: widget.primaryWebsitecontroller,
                    initialValue: '',
                    labelText: 'Primary Website Link',
                  ),
                  TextFormContainer(
                    controller: widget.secondaryWebsitecontroller,
                    initialValue: '',
                    labelText: 'Secondary Website Link',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: CustomPadding.paddingXL.v),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ImageContainer(
                        onTapRemove: _removeLogoImage,
                        previewBytes: previewLogoBytes,
                        isEdit: true,
                        icon:
                            previewLogoBytes == null
                                ? LucideIcons.upload
                                : LucideIcons.repeat,
                        title: 'Logo',
                        onTap: () => _pickImage(isLogo: true),
                        imageState:
                            previewLogoBytes == null ? 'Upload' : 'Replace',
                        imageUrl: null,
                      ),
                      Gap(16.h),
                      ImageContainer(
                        onTapRemove: _removeBannerImage,
                        previewBytes: previewBannerBytes,
                        isEdit: true,
                        icon:
                            previewBannerBytes == null
                                ? LucideIcons.upload
                                : LucideIcons.repeat,
                        title: 'Banner Image',
                        onTap: () => _pickImage(isLogo: false),
                        imageState:
                            previewBannerBytes == null ? 'Upload' : 'Replace',
                        imageUrl: null,
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
