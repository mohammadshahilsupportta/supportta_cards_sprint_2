import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_category_models.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_service.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_service.dart';
import 'package:taproot_admin/features/product_screen/widgets/add_product.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_id_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class EditTemplateProduct extends StatefulWidget {
  final Template? template;
  final VoidCallback onRefreshProduct;
  final String? productName;
  final String? cardType;

  const EditTemplateProduct({
    super.key,
    this.productName,
    this.cardType,
    required this.template,
    required this.onRefreshProduct,
  });

  static const path = '/editproduct';

  @override
  State<EditTemplateProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditTemplateProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();

  late String dropdownValue;
  Thumbnail? selectedThumbnail;
  File? selectedImageFile;

  List<String> existingImageUrls = [];
  List<File?> selectedImages = [];
  List<String> uploadedImageKeys = [];
  String discountPrice = '';
  List<TemplateCategory> templateCategories = [];
  TemplateCategory? selectedCategory;

  final Map<int, String> oldImageKeys = {};
  final Map<int, String> tempUploadedKeys = {};

  Future<void> deleteImage(ProductImage image) async {
    try {
      await ProductService.deleteImage(image);
    } catch (e) {
      logError('error delete $e');
    }
  }

  Future<void> updateProduct() async {
    try {
      if (nameController.text.isEmpty) {
        throw Exception('Template name is required');
      }

      if (selectedCategory == null) {
        throw Exception('Please select a category');
      }

      if (selectedThumbnail == null) {
        throw Exception('Image is required');
      }

      final thumbnail = Thumbnail(
        key: selectedThumbnail!.key,
        name: selectedThumbnail!.name,
        size: selectedThumbnail!.size,
        mimetype: selectedThumbnail!.mimetype,
      );

      final response = await TemplateService.editTemplate(
        templateId: widget.template!.id.toString(),
        name: nameController.text.trim(),
        categoryId: selectedCategory!.id,
        thumbnail: thumbnail,
      );

      if (response.success) {
        SnackbarHelper.showSuccess(context, 'Template updated successfully');
        widget.onRefreshProduct();
        Navigator.pop(context, true);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      logError('Error updating template: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception:', '').trim()),
        ),
      );
    }
  }

  void removeImage({required int index, required bool isExistingUrl}) {
    logSuccess('Removing image:');
    logSuccess('Index: $index');
    logSuccess('Is existing: $isExistingUrl');

    setState(() {
      if (isExistingUrl) {
        if (index < existingImageUrls.length) {
          existingImageUrls.removeAt(index);
          if (oldImageKeys.containsKey(index)) {
            oldImageKeys.remove(index);
            tempUploadedKeys.remove(index);
          }
          if (index < selectedImages.length) {
            selectedImages.removeAt(index);
          }
        }
      } else {
        final newIndex = index - existingImageUrls.length;
        if (newIndex >= 0 && newIndex < uploadedImageKeys.length) {
          uploadedImageKeys.removeAt(newIndex);
          final actualIndex = existingImageUrls.length + newIndex;
          if (actualIndex < selectedImages.length) {
            selectedImages.removeAt(actualIndex);
          }
        }
      }

      logSuccess('After removal:');
      logSuccess('Existing URLs: ${existingImageUrls.length}');
      logSuccess('Uploaded Keys: ${uploadedImageKeys.length}');
      logSuccess('Selected Images: ${selectedImages.length}');
    });
  }

  void onCancel() async {
    for (var newKey in tempUploadedKeys.values) {
      try {
        await ProductService.deleteImage(ProductImage(key: newKey));
        logSuccess('New image deleted: $newKey');
      } catch (e) {
        logError('Failed to delete new image: $e');
      }
    }

    setState(() {
      existingImageUrls.clear();
      if (widget.template != null && widget.template!.thumbnail != null) {}

      selectedImages.clear();
      uploadedImageKeys.clear();
      oldImageKeys.clear();
      tempUploadedKeys.clear();
    });

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchTextFieldValue();
    fetchProductCategories();
    if (widget.template?.thumbnail != null) {
      selectedThumbnail = Thumbnail(
        key: widget.template!.thumbnail!.key,
        name: widget.template!.thumbnail!.name,
        size:
            widget.template!.thumbnail?.size is int
                ? widget.template!.thumbnail?.size as int
                : int.tryParse(
                  widget.template!.thumbnail?.size?.toString() ?? '0',
                ),
        mimetype: widget.template!.thumbnail?.mimetype ?? 'image/jpeg',
      );
    }
  }

  void fetchTextFieldValue() {
    nameController.text = widget.template!.name.toString();
  }

  Future<void> fetchProductCategories() async {
    try {
      final response = await TemplateService.getTemplateCategory();
      setState(() {
        templateCategories = response;
        if (widget.template?.category!.id != null) {
          selectedCategory = templateCategories.firstWhere(
            (category) => category.id == widget.template!.category!.id,
            orElse: () => templateCategories.first,
          );
        } else if (templateCategories.isNotEmpty) {
          selectedCategory = templateCategories.first;
        }
      });
    } catch (e) {
      logError('Error fetching product categories: $e');
    }
  }

  void _pickThumbnailImage() async {
    logSuccess('Starting _pickThumbnailImage');

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final imageBytes = pickedFile.bytes;
      final fileName = pickedFile.name;

      if (imageBytes != null) {
        try {
          final uploadResult = await TemplateService.uploadImageFile(
            imageBytes,
            fileName,
          );

          final uploadedKey = uploadResult['key'];

          if (uploadedKey != null) {
            setState(() {
              selectedThumbnail = Thumbnail(
                name: fileName,
                key: uploadedKey,
                size: pickedFile.size,
                mimetype: pickedFile.extension ?? '',
              );
              selectedImageFile = File(pickedFile.path!);
              logSuccess('Thumbnail uploaded: $uploadedKey');
            });
          }
        } catch (e) {
          logError('Thumbnail upload failed: $e');
        }
      }
    }
  }

  void _removeThumbnailImage() {
    setState(() {
      selectedThumbnail = null;
      selectedImageFile = null;
    });
  }

  String getImageUrl(String key) {
    return '$baseUrlImage/templates/$key';
  }

  void _showCategoryDropdownList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: CustomColors.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CustomPadding.paddingLarge.v),
          ),
          child: SizedBox(
            width: SizeUtils.width * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.buttonColor1,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(CustomPadding.paddingLarge.v),
                    ),
                  ),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Select Category',
                      style: context.inter50018.copyWith(
                        color: CustomColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 180),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: templateCategories.length,
                    itemBuilder: (context, index) {
                      final category = templateCategories[index];
                      return ListTile(
                        title: Text(capitalize(category.name)),
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                Divider(),
                MiniGradientBorderButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showAddCategoryDialog(context);
                  },
                  text: 'Add Category',
                  icon: Icons.add_circle_outline,
                ),
                Gap(CustomPadding.padding.v),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    String newCategoryName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomColors.secondaryColor,
          title: Text('Category'),
          contentPadding: EdgeInsets.all(CustomPadding.paddingLarge.v),
          content: TextFormContainer(
            labelText: 'Category name',
            onChanged: (value) => newCategoryName = value,
          ),
          actions: [
            MiniGradientBorderButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
            MiniLoadingButton(
              text: 'Add',
              onPressed: () async {
                final response = await TemplateService.addTemplateCategory(
                  categoryName: newCategoryName,
                );
                if (context.mounted) {
                  await fetchProductCategories();
                  Navigator.pop(context);
                  SnackbarHelper.showSuccess(
                    context,
                    response['message'] ?? 'Category added successfully',
                  );
                }
              },
              needRow: false,
              useGradient: true,
            ),
          ],
        );
      },
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(CustomPadding.paddingXL.v),
            Row(
              children: [
                Gap(CustomPadding.paddingXL.v),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Product',
                    style: context.inter60016.copyWith(
                      color: CustomColors.greenDark,
                    ),
                  ),
                ),
                Gap(CustomPadding.padding.v),
                Text('>', style: context.inter60016),
                Gap(CustomPadding.padding.v),
                Text('${widget.template?.name}', style: context.inter60016),
                Spacer(),

                MiniGradientBorderButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  gradient: LinearGradient(
                    colors: CustomColors.borderGradient.colors,
                  ),
                ),
                Gap(CustomPadding.paddingLarge.v),
                MiniLoadingButton(
                  icon: LucideIcons.save,
                  text: 'Save',
                  onPressed: () async {
                    await updateProduct();
                  },
                  useGradient: true,
                  gradientColors: CustomColors.borderGradient.colors,
                ),
                Gap(CustomPadding.paddingXL.v),
              ],
            ),
            Gap(CustomPadding.paddingLarge.v),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: CustomPadding.paddingLarge.v,
                vertical: CustomPadding.paddingLarge.v,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: CustomPadding.paddingLarge.v,
              ),
              decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: BorderRadius.circular(
                  CustomPadding.paddingLarge.v,
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductIdContainer(
                    productId: widget.template!.code.toString(),
                  ),
                  Gap(CustomPadding.paddingXL.v),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddImageContainer(
                          file: selectedImageFile,
                          path: widget.template!.thumbnail?.key ?? '',
                          imageBasePath: 'templates',
                          height: 250,
                          pickImage: _pickThumbnailImage,
                          removeImage: _removeThumbnailImage,
                          selectedImage: selectedImageFile,
                          imagekey: selectedThumbnail?.key,
                          isImageView:
                              selectedImageFile == null &&
                              selectedThumbnail != null,
                        ),
                      ],
                    ),
                  ),

                  Gap(CustomPadding.paddingLarge.v),

                  Gap(CustomPadding.paddingLarge.v),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormContainer(
                          controller: nameController,
                          labelText: 'Template Name',
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Gap(CustomPadding.paddingLarge.v),
                                Text('Design Type'),
                                Expanded(
                                  child: GestureDetector(
                                    onTap:
                                        () =>
                                            _showCategoryDropdownList(context),
                                    child: Container(
                                      height: 50.v,
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            CustomPadding.paddingLarge.v,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal:
                                            CustomPadding.paddingLarge.v,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          CustomPadding.paddingSmall.v,
                                        ),
                                        border: Border.all(
                                          color:
                                              CustomColors.textColorLightGrey,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            capitalize(
                                              selectedCategory?.name ??
                                              'Select Category',
                                            ),

                                            style: context.inter50016.copyWith(
                                              color: CustomColors.textColor,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: CustomColors.textColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
