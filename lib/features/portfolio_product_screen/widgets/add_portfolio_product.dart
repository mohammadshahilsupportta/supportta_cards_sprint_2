import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/product_screen/data/product_category_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_service.dart';
import 'package:taproot_admin/features/product_screen/widgets/add_product.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_id_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class AddPortfolioProduct extends StatefulWidget {
  final VoidCallback onBack;
  final Future<void> Function()? onSave;

  const AddPortfolioProduct({super.key, required this.onBack, this.onSave});

  @override
  State<AddPortfolioProduct> createState() => _AddPortfolioProductState();
}

class _AddPortfolioProductState extends State<AddPortfolioProduct> {
  final TextEditingController _templateNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _designTypeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String templateName = '';
  String price = '';
  String discountPrice = '';
  String description = '';
  List<ProductCategory> productCategories = [];
  List<String> uploadedImageKeys = [];

  ProductCategory? selectedCategory;
  final List<File?> _selectedImages = [null, null, null, null];

  void pickImage(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;

      setState(() {
        _selectedImages[index] = File(pickedFile.path!);
      });

      final imageBytes = pickedFile.bytes;
      final filename = pickedFile.name;

      if (imageBytes != null) {
        final uploadResult = await ProductService.uploadImageFile(
          imageBytes,
          filename,
        );
        setState(() {
          // uploadedImageKeys.add(uploadResult['key']);
          if (index < uploadedImageKeys.length) {
            uploadedImageKeys[index] = uploadResult['key'];
          } else {
            uploadedImageKeys.add(uploadResult['key']);
          }
        });
        logSuccess('name: ${uploadResult['name']}');
        logSuccess('key: ${uploadResult['key']}');
        logSuccess('size: ${uploadResult['size']}');
        logSuccess('mimetype: ${uploadResult['mimetype']}');
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      _selectedImages[index] = null;

      for (int i = index + 1; i < _selectedImages.length; i++) {
        _selectedImages[i] = null;
      }
    });
  }

  Future<void> addProduct() async {
    try {
      List<ProductImage> productImages = [];
      for (var image in _selectedImages) {
        if (image != null) {
          final uploadResult = await ProductService.uploadImageFile(
            image.readAsBytesSync(),
            image.path.split('/').last,
          );
          productImages.add(
            ProductImage(
              name: uploadResult['name'],
              key: uploadResult['key'],
              size: uploadResult['size'],
              mimetype: uploadResult['mimetype'],
            ),
          );
        }
      }
      await ProductService.addProduct(
        name: _templateNameController.text,
        categoryId: selectedCategory!.id,
        description: _descriptionController.text,
        actualPrice: double.tryParse(_priceController.text) ?? 0.0,
        discountPrice: double.tryParse(_discountPriceController.text) ?? 0.0,
        discountPercentage:
            double.tryParse(_discountPriceController.text) ?? 0.0,
        productImages: productImages,
      );
      logSuccess('Product added successfully');
    } catch (e) {
      logError('Error: $e');
    }
  }

  Future<void> fetchProductCategories() async {
    try {
      final response = await ProductService.getProductCategory();
      setState(() {
        productCategories = response;
        if (productCategories.isNotEmpty) {
          selectedCategory = productCategories[0];
        }
      });
    } catch (e) {
      logError('Error fetching product categories: $e');
    }
  }

  @override
  void initState() {
    fetchProductCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gap(CustomPadding.paddingXL.v),
              Row(
                children: [
                  Gap(CustomPadding.paddingXL.v),
                  GestureDetector(
                    onTap: () {
                      widget.onBack();
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
                  Text('Add Product', style: context.inter60016),
                  Spacer(),
                  MiniGradientBorderButton(
                    text: 'Back',
                    icon: Icons.arrow_back,
                    onPressed: widget.onBack,
                    gradient: LinearGradient(
                      colors: CustomColors.borderGradient.colors,
                    ),
                  ),
                  Gap(CustomPadding.paddingLarge.v),
                  //TODO: image
                  MiniLoadingButton(
                    icon: LucideIcons.save,
                    text: 'Save',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await addProduct();
                        await widget.onSave!();

                        quitBack();
                      }
                    },
                    useGradient: true,
                    gradientColors: CustomColors.borderGradient.colors,
                  ),
                  Gap(CustomPadding.paddingXL.v),
                ],
              ),
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
                    ProductIdContainer(productId: 'Product ID'),
                    Gap(CustomPadding.paddingXL.v),
                    Row(
                      children: List.generate(4, (index) {
                        if (index == 0 || _selectedImages[index - 1] != null) {
                          return AddImageContainer(
                            height: 220.h,
                            selectedImage: _selectedImages[index],
                            pickImage: () => pickImage(index),
                            removeImage: () => removeImage(index),
                            imagekey:
                                uploadedImageKeys.isNotEmpty &&
                                        index < uploadedImageKeys.length
                                    ? uploadedImageKeys[index]
                                    : null,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ),

                    Gap(CustomPadding.paddingLarge.v),
                    Text(
                      'You can Choose a Maximum of 4 Photos. JPG, GIF, or PNG. Max size of 800K',
                      style: TextStyle(color: CustomColors.hintGrey),
                    ),
                    Gap(CustomPadding.paddingLarge.v),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormContainer(
                            controller: _templateNameController,
                            initialValue: '',
                            labelText: 'Template Name',
                            onChanged: (value) {
                              setState(() {
                                templateName = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a product name';
                              }
                              return null;
                            },
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
                            controller: _discountPriceController,
                            suffixText: '%',
                            initialValue: '',
                            labelText: 'Discount Percentage',
                            onChanged: (value) {
                              discountPrice = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a discount percentage';
                              }
                              final percentage = double.tryParse(value);
                              if (percentage == null ||
                                  percentage < 1 ||
                                  percentage > 99) {
                                return 'Please enter a percentage between 1 and 99';
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller: _priceController,
                                initialValue: '',
                                labelText: 'Price',
                                onChanged: (value) {
                                  price = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a price';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Gap(CustomPadding.paddingLarge.v),
                                  Text('Design Type'),
                                  Expanded(
                                    child: Container(
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
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<ProductCategory>(
                                          underline: null,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          isExpanded: true,
                                          borderRadius: BorderRadius.circular(
                                            CustomPadding.padding.v,
                                          ),
                                          value: selectedCategory,
                                          items:
                                              productCategories.map((category) {
                                                return DropdownMenuItem(
                                                  value: category,
                                                  child: Text(category.name),
                                                );
                                              }).toList(),

                                          onChanged: (
                                            ProductCategory? newValue,
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
                            controller: _descriptionController,
                            maxline: 4,
                            initialValue: '',
                            labelText: 'Description',
                            onChanged: (value) {
                              description = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.split(' ').length < 5) {
                                return 'Please enter at least 5 words';
                              }
                              return null;
                            },
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
      ),
    );
  }

  void quitBack() {
    Navigator.pop(context);
  }
}
