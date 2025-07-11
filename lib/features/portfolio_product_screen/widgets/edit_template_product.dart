import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // final Product? product;
  final Template? template;

  final VoidCallback onRefreshProduct;
  final String? productName;
  // final String? price;
  // final String? offerPrice;
  // final String? description;
  final String? cardType;

  const EditTemplateProduct({
    super.key,
    this.productName,
    // this.price,
    // this.offerPrice,
    // this.description,
    this.cardType,
    required this.template,
    // required this.product,
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
  ProductImage? selectedThumbnail;
  File? selectedImageFile;

  List<String> existingImageUrls = [];
  List<File?> selectedImages = [];
  List<String> uploadedImageKeys = [];
  String discountPrice = '';
  List<TemplateCategory> templateCategories = [];
  TemplateCategory? selectedCategory;
  // ProductCategory? selectedCategory;
  final Map<int, String> oldImageKeys = {};
  final Map<int, String> tempUploadedKeys = {};
  void _pickImage({required int index, required bool isExistingUrl}) async {
    logSuccess('Starting _pickImage:');
    logSuccess('Index: $index');
    logSuccess('Is existing: $isExistingUrl');
    logSuccess(
      'Current counts - Existing: ${existingImageUrls.length}, New: ${uploadedImageKeys.length}',
    );

    final totalImages = existingImageUrls.length + uploadedImageKeys.length;
    if (!isExistingUrl && totalImages >= 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maximum 4 images allowed')));
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      if (pickedFile.path != null) {
        final newImage = File(pickedFile.path!);
        final imageBytes = pickedFile.bytes;
        final filename = pickedFile.name;

        if (imageBytes != null) {
          try {
            final uploadResult = await ProductService.uploadImageFile(
              imageBytes,
              filename,
            );

            if (uploadResult['key'] != null) {
              setState(() {
                if (isExistingUrl) {
                  if (index < existingImageUrls.length) {
                    oldImageKeys[index] = existingImageUrls[index];
                    tempUploadedKeys[index] = uploadResult['key'];

                    while (selectedImages.length <= index) {
                      selectedImages.add(null);
                    }
                    selectedImages[index] = newImage;
                  }
                } else {
                  final newIndex = uploadedImageKeys.length;
                  uploadedImageKeys.add(uploadResult['key']);

                  while (selectedImages.length <=
                      existingImageUrls.length + newIndex) {
                    selectedImages.add(null);
                  }
                  selectedImages[existingImageUrls.length + newIndex] =
                      newImage;
                }

                logSuccess('After image pick:');
                logSuccess('Existing URLs: ${existingImageUrls.length}');
                logSuccess('Uploaded Keys: ${uploadedImageKeys.length}');
                logSuccess('Selected Images: ${selectedImages.length}');
              });
            }
          } catch (e) {
            logError('Image upload failed: $e');
          }
        }
      }
    }
  }

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
        throw Exception('Product name is required');
      }
      if (priceController.text.isEmpty) {
        throw Exception('Price is required');
      }
      if (discountPriceController.text.isEmpty) {
        throw Exception('Discount percentage is required');
      }
      if (descriptionController.text.isEmpty) {
        throw Exception('Description is required');
      }
      if (selectedCategory == null) {
        throw Exception('Please select a category');
      }

      final actualPrice = double.parse(priceController.text.trim());
      final discountPercentage = double.parse(
        discountPriceController.text.trim(),
      );

      if (actualPrice <= 0) {
        throw Exception('Price must be greater than 0');
      }
      if (discountPercentage < 0 || discountPercentage > 99) {
        throw Exception('Discount percentage must be between 0 and 99');
      }

      final discountAmount = (actualPrice * discountPercentage) / 100;
      final salePrice = actualPrice - discountAmount;
      // final discountPrice =
      //     discountPercentage == 0
      //         ? actualPrice
      //         : actualPrice - (actualPrice * discountPercentage / 100);

      List<ProductImage> productImages = [];
      logSuccess('Preparing images for update:');
      logSuccess('Existing URLs: ${existingImageUrls.length}');
      logSuccess('Uploaded Keys: ${uploadedImageKeys.length}');
      logSuccess('Selected Images: ${selectedImages.length}');

      for (int i = 0; i < existingImageUrls.length; i++) {
        if (!oldImageKeys.containsKey(i)) {
          String imageUrl = existingImageUrls[i];
          // ProductImage? existingImage = widget.template.thumbnail.key;
          // ?.firstWhere((img) => img.key == imageUrl);
          // if (existingImage != null) {
          //   productImages.add(existingImage);
          //   logSuccess('Added existing image: ${existingImage.key}');
          // }
        } else {
          String newKey = tempUploadedKeys[i] ?? '';
          if (newKey.isNotEmpty && selectedImages[i] != null) {
            int fileSize = selectedImages[i]!.lengthSync();
            String fileName = selectedImages[i]!.path.split('/').last;
            //  newKey.split('/').last;
            String extension = fileName.split('.').last.toLowerCase();

            productImages.add(
              ProductImage(
                key: newKey,
                name: fileName,
                size: fileSize,
                mimetype: 'image/$extension',
              ),
            );
            logSuccess('Added replaced image: $newKey');
          }
        }
      }

      for (int i = 0; i < uploadedImageKeys.length; i++) {
        String key = uploadedImageKeys[i];
        final actualIndex = existingImageUrls.length + i;

        if (actualIndex < selectedImages.length &&
            selectedImages[actualIndex] != null) {
          int fileSize = selectedImages[actualIndex]!.lengthSync();
          String fileName = selectedImages[actualIndex]!.path.split('/').last;
          //  key.split('/').last;
          String extension = fileName.split('.').last.toLowerCase();

          productImages.add(
            ProductImage(
              key: key,
              name: fileName,
              size: fileSize,
              mimetype: 'image/$extension',
            ),
          );
          logSuccess('Added new image: $key');
        }
      }

      if (productImages.isEmpty) {
        throw Exception('At least one image is required');
      }

      logSuccess('Updating product with:');
      logSuccess('Name: ${nameController.text.trim()}');
      logSuccess('Price: $actualPrice');
      logSuccess('Discount Percentage: $discountPercentage');
      logSuccess('Discount Amount: $discountAmount');
      logSuccess('Sale Price: $salePrice');
      logSuccess('Category: ${selectedCategory?.id}');
      logSuccess('Images count: ${productImages.length}');
      final response = await TemplateService.editTemplate(
        templateId: widget.template!.id.toString(),
        name: nameController.text.trim(),
        actualPrice: actualPrice,
        discountPrice: salePrice,
        discountPercentage: discountPercentage,
        productImages: productImages,
        description: descriptionController.text.trim(),
        categoryId: selectedCategory?.id ?? '',
      );

      // final response = await ProductService.editProduct(
      //   productId: widget.product!.id.toString(),
      //   name: nameController.text.trim(),
      //   actualPrice: actualPrice,
      //   discountPrice: salePrice,
      //   discountPercentage: discountPercentage,
      //   productImages: productImages,
      //   description: descriptionController.text.trim(),
      //   categoryId: selectedCategory?.id,
      // );

      if (response.success) {
        for (var oldKey in oldImageKeys.values) {
          try {
            await ProductService.deleteImage(ProductImage(key: oldKey));
            logSuccess('Old image deleted: $oldKey');
          } catch (e) {
            logError('Failed to delete old image: $e');
          }
        }

        oldImageKeys.clear();
        tempUploadedKeys.clear();

        SnackbarHelper.showSuccess(context, 'Product updated successfully');
        Navigator.pop(context, true);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      logError('Error updating product: $e');
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
      if (widget.template != null && widget.template!.thumbnail != null) {
        // existingImageUrls.addAll(
        //   widget.template!.thumbnail!.map((image) => image.key),
        // );
      }

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
      selectedThumbnail = ProductImage(
        key: widget.template!.thumbnail!.key,
        name: widget.template!.thumbnail!.name,
        size: int.tryParse(widget.template!.thumbnail?.size ?? '0') ?? 0,
        mimetype: widget.template!.thumbnail?.mimetype ?? 'image/jpeg',
      );
    }
  }

  void fetchTextFieldValue() {
    nameController.text = widget.template!.name.toString();
    // priceController.text = widget.product!.actualPrice.toString();
    // discountPriceController.text =
    //     widget.product!.discountPercentage.toString();
    // descriptionController.text = widget.product!.description.toString();
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

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final picked = result.files.first;
      if (picked.bytes != null) {
        try {
          final uploadResult = await ProductService.uploadImageFile(
            picked.bytes!,
            picked.name,
          );

          if (uploadResult['key'] != null) {
            setState(() {
              selectedImageFile = File(picked.path!);
              selectedThumbnail = ProductImage(
                key: uploadResult['key'],
                name: picked.name,
                size: picked.size,
                mimetype: 'image/${picked.extension}',
              );
            });
          }
        } catch (e) {
          logError('Image upload failed: $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Image upload failed')));
        }
      }
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
          final uploadResult = await ProductService.uploadImageFile(
            imageBytes,
            fileName,
          );

          final uploadedKey = uploadResult['key'];

          if (uploadedKey != null) {
            setState(() {
              selectedThumbnail =
                  Thumbnail(
                        name: fileName,
                        key: uploadedKey,
                        size: pickedFile.size.toString(),
                        mimetype: pickedFile.extension ?? '',
                      )
                      as ProductImage?;
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

  @override
  Widget build(BuildContext context) {
    logError(selectedThumbnail!.key);
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
                Text('${widget.productName}', style: context.inter60016),
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
                          imageBasePath: 'templates',
                          height: 250,
                          pickImage: _pickThumbnailImage,
                          removeImage: _removeThumbnailImage,
                          selectedImage: selectedImageFile,
                          imagekey: selectedThumbnail!.key,
                          isImageView:
                              selectedImageFile == null &&
                              selectedThumbnail != null,
                        ),
                      ],
                    ),
                  ),

                  //                   Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text('Thumbnail Image', style: context.inter60016),
                  //     Gap(10.v),
                  //     Row(
                  //       children: [
                  //         if (selectedImageFile != null)
                  //           Image.file(selectedImageFile!, width: 100, height: 100, fit: BoxFit.cover)
                  //         else if (selectedThumbnail != null)
                  //           Image.network(getImageUrl(selectedThumbnail!.key), width: 100, height: 100, fit: BoxFit.cover)
                  //         else
                  //           Container(width: 100, height: 100, color: Colors.grey[300]),
                  //         Gap(16),
                  //         ElevatedButton(
                  //           onPressed: pickImage,
                  //           child: Text('Change Image'),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // )

                  // Wrap(
                  //   spacing: 8,
                  //   runSpacing: 8,
                  //   children: [
                  //     Builder(
                  //       builder: (context) {
                  //         logSuccess('Building image grid:');
                  //         logSuccess(
                  //           'Existing images: ${existingImageUrls.length}',
                  //         );
                  //         logSuccess(
                  //           'Uploaded keys: ${uploadedImageKeys.length}',
                  //         );
                  //         logSuccess(
                  //           'Selected images: ${selectedImages.length}',
                  //         );
                  //         return const SizedBox.shrink();
                  //       },
                  //     ),

                  //     ...List.generate(4, (index) {
                  //       if (index < existingImageUrls.length) {
                  //         if (oldImageKeys.containsKey(index)) {
                  //           return AddImageContainer(
                  //             removeImage:
                  //                 () => removeImage(
                  //                   index: index,
                  //                   isExistingUrl: true,
                  //                 ),
                  //             pickImage:
                  //                 () => _pickImage(
                  //                   index: index,
                  //                   isExistingUrl: true,
                  //                 ),
                  //             isImageView: true,
                  //             selectedImage: selectedImages[index],
                  //             imagekey: tempUploadedKeys[index],
                  //             path: tempUploadedKeys[index],
                  //           );
                  //         } else {
                  //           return AddImageContainer(
                  //             removeImage:
                  //                 () => removeImage(
                  //                   index: index,
                  //                   isExistingUrl: true,
                  //                 ),
                  //             pickImage:
                  //                 () => _pickImage(
                  //                   index: index,
                  //                   isExistingUrl: true,
                  //                 ),
                  //             isImageView: true,
                  //             path: existingImageUrls[index],
                  //           );
                  //         }
                  //       }

                  //       final newIndex = index - existingImageUrls.length;
                  //       if (newIndex < uploadedImageKeys.length) {
                  //         return AddImageContainer(
                  //           removeImage:
                  //               () => removeImage(
                  //                 index: index,
                  //                 isExistingUrl: false,
                  //               ),
                  //           pickImage:
                  //               () => _pickImage(
                  //                 index: index,
                  //                 isExistingUrl: false,
                  //               ),
                  //           isImageView: true,
                  //           selectedImage:
                  //               index < selectedImages.length
                  //                   ? selectedImages[index]
                  //                   : null,
                  //           imagekey: uploadedImageKeys[newIndex],
                  //           path: uploadedImageKeys[newIndex],
                  //         );
                  //       }

                  //       if (index < 4 &&
                  //           (existingImageUrls.length +
                  //                   uploadedImageKeys.length) <
                  //               4) {
                  //         return AddImageContainer(
                  //           removeImage: () {},
                  //           pickImage:
                  //               () => _pickImage(
                  //                 index: index,
                  //                 isExistingUrl: false,
                  //               ),
                  //           isImageView: false,
                  //           path: '',
                  //         );
                  //       }

                  //       return const SizedBox.shrink();
                  //     }),
                  //   ],
                  // ),
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
                      Expanded(
                        child: TextFormContainer(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          controller: discountPriceController,
                          suffixText: '%',
                          labelText: 'Discount Percentage',
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final percentage = double.tryParse(value);
                              if (percentage != null &&
                                  percentage >= 0 &&
                                  percentage <= 99) {
                                setState(() {
                                  discountPrice = value;
                                });
                              }
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a discount percentage';
                            }
                            final percentage = double.tryParse(value);
                            if (percentage == null ||
                                percentage < 0 ||
                                percentage > 99) {
                              return 'Please enter a percentage between 0 and 99';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextFormContainer(
                              controller: priceController,

                              labelText: 'Price',
                            ),
                            Row(
                              children: [
                                Gap(CustomPadding.paddingLarge.v),
                                Text('Design Type'),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: CustomPadding.paddingLarge.v,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: CustomPadding.paddingLarge.v,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        CustomPadding.paddingSmall.v,
                                      ),
                                      border: Border.all(
                                        color: CustomColors.textColorLightGrey,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<TemplateCategory>(
                                        value: selectedCategory,
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        isExpanded: true,
                                        borderRadius: BorderRadius.circular(
                                          CustomPadding.padding.v,
                                        ),

                                        items:
                                            templateCategories.map((category) {
                                              return DropdownMenuItem(
                                                value: category,
                                                child: Text(category.name),
                                              );
                                            }).toList(),

                                        onChanged: (
                                          TemplateCategory? newValue,
                                        ) {
                                          setState(() {
                                            selectedCategory = newValue;
                                          });
                                          logSuccess(
                                            'Selected: ${newValue!.name}',
                                          );
                                          logSuccess(
                                            'Selected ID: ${newValue.id}',
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormContainer(
                          controller: descriptionController,
                          maxline: 4,
                          labelText: 'Description',
                        ),
                      ),
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
