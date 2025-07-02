import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/constants/constants.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/core/logger.dart';
import 'package:taproot_admin/features/order_screen/data/order_detail_add.model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/image_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/image_pick_upload_preview.dart';

enum ImageWidgetState { upload, replace, delete }

class ImageRowContainer extends StatefulWidget {
  final String title;
  final ImageSource? initialImage;
  final String userCode;
  final String imageType;
  final Function(ImageSource imageSource) onImageChanged;

  const ImageRowContainer({
    super.key,
    required this.userCode,
    required this.title,
    required this.imageType,
    required this.onImageChanged,
    this.initialImage,
  });

  @override
  State<ImageRowContainer> createState() => _ImageRowContainerState();
}

class _ImageRowContainerState extends State<ImageRowContainer> {
  Uint8List? previewBytes;
  String? imageUrl;
  ImageWidgetState imageState = ImageWidgetState.upload;

  PortfolioDataModel? portfolio;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    if (widget.initialImage != null && widget.initialImage!.image != null) {
      final imageDetails = widget.initialImage!.image!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            imageUrl = getPortfolioImageUrl(imageDetails.key);
            imageState = ImageWidgetState.replace;
          });
          widget.onImageChanged(widget.initialImage!);
        }
      });
    } else {
      fetchPortfolio(); // this already handles its own setState inside safely
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchPortfolio();
  // }

  Future<void> fetchPortfolio() async {
    setState(() => isLoading = true);
    try {
      final result = await PortfolioService.getPortfolio(
        userid: widget.userCode,
      );
      if (result != null) {
        portfolio = result;
        ImageDetails? imageDetails;

        switch (widget.imageType) {
          case 'companyLogo':
            final logo = portfolio?.workInfo.companyLogo;
            if (logo != null) {
              imageDetails = ImageDetails(
                key: logo.key,
                name: logo.name ?? '',
                mimetype: logo.mimetype ?? '',
                size: logo.size?.toInt() ?? 0,
              );
            }
            break;

          case 'profilePicture':
            final picture = portfolio?.personalInfo.profilePicture;
            if (picture != null) {
              imageDetails = ImageDetails(
                key: picture.key,
                name: picture.name ?? '',
                mimetype: picture.mimetype ?? '',
                size: picture.size?.toInt() ?? 0,
              );
            }
            break;
        }

        if (imageDetails != null) {
          setState(() {
            imageUrl = getPortfolioImageUrl(imageDetails?.key);
            imageState = ImageWidgetState.replace;
          });
          widget.onImageChanged(
            ImageSource(image: imageDetails, source: 'portfolio'),
          );
        } else {
          widget.onImageChanged(ImageSource(source: 'none'));
        }
      }
    } catch (e) {
      logError(e.toString());
      if (mounted && (e is! CustomException || (e.statusCode != 404))) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    logWarning('Picking image...');
    try {
      final pickerInstance = picker.ImagePicker();
      final pickedFile = await pickerInstance.pickImage(
        source: picker.ImageSource.gallery,
      );

      if (pickedFile == null) {
        logWarning('No image picked.');
        return;
      }

      final bytes = await pickedFile.readAsBytes();

      if (bytes.isEmpty) {
        logWarning('Image picked but no data found.');
        return;
      }

      setState(() {
        previewBytes = bytes;
        imageState = ImageWidgetState.replace;
      });

      final uploaded = await ImagePickerService.uploadImageFile(
        bytes,
        pickedFile.name,
      );

      final imageDetails = ImageDetails(
        key: uploaded.key,
        name: uploaded.name,
        mimetype: uploaded.mimeType,
        size: uploaded.size,
      );

      final newImageUrl = getPortfolioImageUrl(imageDetails.key);

      setState(() {
        imageUrl = newImageUrl;
        imageState = ImageWidgetState.replace;
      });

      widget.onImageChanged(ImageSource(image: imageDetails, source: 'order'));
    } catch (e, stackTrace) {
      logError('Image picking or upload failed: $e\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void _removeImage() {
    setState(() {
      previewBytes = null;
      imageUrl = null;
      imageState = ImageWidgetState.upload;
    });

    widget.onImageChanged(ImageSource(source: 'none'));
  }

  String? getPortfolioImageUrl(String? key) {
    if (key == null) return null;
    return '$baseUrlImage/portfolios/$key';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final label =
        (imageState == ImageWidgetState.replace) ? 'Replace' : 'Upload';
    final icon =
        (imageState == ImageWidgetState.replace)
            ? LucideIcons.repeat
            : LucideIcons.upload;

    return ImageContainer(
      title: widget.title,
      icon: icon,
      imageState: label,
      imageUrl: imageUrl,
      previewBytes: previewBytes,
      isEdit: true,
      onTap: _pickAndUploadImage,
      onTapRemove: _removeImage,
    );
  }
}
