import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_category_models.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_service.dart';
import 'package:taproot_admin/features/product_screen/widgets/add_product.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_id_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class AddPortfolioProduct extends StatefulWidget {
  final VoidCallback onBack;
  final Future<void> Function()? onSave;

  const AddPortfolioProduct({super.key, required this.onBack, this.onSave});

  @override
  State<AddPortfolioProduct> createState() => _AddPortfolioProductState();
}

class _AddPortfolioProductState extends State<AddPortfolioProduct> {
  final TextEditingController _templateNameController = TextEditingController();

  // final TextEditingController _designTypeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String templateName = '';

  List<TemplateCategory> templateCategories = [];
  TemplateCategory? selectedCategory;

  File? _selectedImage;
  String? uploadedImageKey;

  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;

      setState(() {
        _selectedImage = File(pickedFile.path!);
      });

      final imageBytes = pickedFile.bytes;
      final filename = pickedFile.name;

      if (imageBytes != null) {
        final uploadResult = await TemplateService.uploadImageFile(
          imageBytes,
          filename,
        );
        setState(() {
          uploadedImageKey = uploadResult['key'];
        });

        logSuccess('name: ${uploadResult['name']}');
        logSuccess('key: ${uploadResult['key']}');
        logSuccess('size: ${uploadResult['size']}');
        logSuccess('mimetype: ${uploadResult['mimetype']}');
      }
    }
  }

  void removeImage() {
    setState(() {
      _selectedImage = null;
      uploadedImageKey = null;
    });
  }

  Future<void> addTemplates() async {
    try {
      // Upload image and create Thumbnail model
      Thumbnail? thumbnail;
      if (_selectedImage != null) {
        final uploadResult = await TemplateService.uploadImageFile(
          _selectedImage!.readAsBytesSync(),
          _selectedImage!.path.split('/').last,
        );

        thumbnail = Thumbnail(
          name: uploadResult['name'],
          key: uploadResult['key'],
          size: uploadResult['size'],
          mimetype: uploadResult['mimetype'],
        );
      }

      // Build Template model
      final templateData = Template(
        name: _templateNameController.text.trim(),
        thumbnail: thumbnail,
        category:
            selectedCategory != null
                ? Category(id: selectedCategory!.id)
                : null, // selectedCategory != null
        //     ? Category(
        //       id: selectedCategory!.id,
        //       name: selectedCategory!.name,
        //     )
        //     : null,
      );

      // Call service method
      final response = await TemplateService.addTemplate(
        template: templateData,
      );

      if (response.success) {
        SnackbarHelper.showSuccess(context, 'Template added successfully');
        logSuccess('Template created: ${response.result?.name}');
      } else {
        SnackbarHelper.showError(
          context,
          'Failed to add template: ${response.message}',
        );
      }
    } catch (e) {
      logError('Error adding template: $e ');

      SnackbarHelper.showError(context, 'Something went wrong');
    }
  }

  Future<void> fetchTemplateCategories() async {
    try {
      final response = await TemplateService.getTemplateCategory();
      setState(() {
        templateCategories = response;
        if (templateCategories.isNotEmpty) {
          selectedCategory = templateCategories[0];
        }
      });
    } catch (e) {
      logError('Error fetching product categories: $e');
    }
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showAddCategoryDialog(
                                  context,
                                  category: category,
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete, color: CustomColors.red),
                            ),
                          ],
                        ),
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

  void showAddCategoryDialog(
    BuildContext context, {
    TemplateCategory? category,
  }) {
    String newCategoryName = '';
    final TextEditingController _controller = TextEditingController(
      text: category?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomColors.secondaryColor,
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          //  Text('Category'),
          contentPadding: EdgeInsets.all(CustomPadding.paddingLarge.v),
          content: TextFormContainer(
            controller: _controller,
            labelText: 'Category name',
            onChanged: (value) => newCategoryName = value,
          ),
          actions: [
            MiniGradientBorderButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
            MiniLoadingButton(
              text: category == null ? 'Add' : 'Update',
              onPressed: () async {
                final name = _controller.text.trim();
                if (name.isEmpty) return;

                late final Map<String, dynamic> response;
                if (category == null) {
                  response = await TemplateService.addTemplateCategory(
                    categoryName: name,
                  );
                } else {
                  response = await TemplateService.updateTemplateCategory(
                    categoryId: category.id,
                    categoryName: name,
                  );
                }

                // final response = await TemplateService.addTemplateCategory(
                //   categoryName: newCategoryName,
                // );
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  fetchTemplateCategories();
                  _showCategoryDropdownList(context);
                  // Navigator.pop(context);
                  SnackbarHelper.showSuccess(
                    context,
                    response['message'] ??
                        (category == null
                            ? 'Category added successfully'
                            : 'Category updated successfully'),
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
  void initState() {
    fetchTemplateCategories();
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
                        await addTemplates();
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
                      children: [
                        AddImageContainer(
                          imageBasePath: 'templates',
                          height: 220.h,
                          selectedImage: _selectedImage,
                          pickImage: pickImage,
                          removeImage: removeImage,
                          imagekey: uploadedImageKey,
                        ),
                      ],
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
                        Expanded(child: SizedBox()),
                        // Expanded(
                        //   child: TextFormContainer(
                        //     inputFormatters: [
                        //       FilteringTextInputFormatter.allow(
                        //         RegExp(r'^\d*\.?\d{0,2}'),
                        //       ),
                        //       LengthLimitingTextInputFormatter(5),
                        //     ],
                        //     controller: _discountPriceController,
                        //     suffixText: '%',
                        //     initialValue: '',
                        //     labelText: 'Discount Percentage',
                        //     onChanged: (value) {
                        //       discountPrice = value;
                        //     },
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please enter a discount percentage';
                        //       }
                        //       final percentage = double.tryParse(value);
                        //       if (percentage == null ||
                        //           percentage < 1 ||
                        //           percentage > 99) {
                        //         return 'Please enter a percentage between 1 and 99';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // TextFormContainer(
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.digitsOnly,
                              //   ],
                              //   controller: _priceController,
                              //   initialValue: '',
                              //   labelText: 'Price',
                              //   onChanged: (value) {
                              //     price = value;
                              //   },
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Please enter a price';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              Row(
                                children: [
                                  Gap(CustomPadding.paddingLarge.v),
                                  Text('Design Type'),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap:
                                          () => _showCategoryDropdownList(
                                            context,
                                          ),
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

                                              style: context.inter50016
                                                  .copyWith(
                                                    color:
                                                        CustomColors.textColor,
                                                  ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: CustomColors.textColor,
                                            ),
                                          ],
                                        ),
                                        // child: DropdownButtonHideUnderline(
                                        //   child: DropdownButton<ProductCategory>(
                                        //     underline: null,
                                        //     icon: Icon(Icons.keyboard_arrow_down),
                                        //     isExpanded: true,
                                        //     borderRadius: BorderRadius.circular(
                                        //       CustomPadding.padding.v,
                                        //     ),
                                        //     value: selectedCategory,
                                        //     items:
                                        //         productCategories.map((category) {
                                        //           return DropdownMenuItem(
                                        //             value: category,
                                        //             child: Text(category.name),
                                        //           );
                                        //         }).toList(),

                                        //     onChanged: (
                                        //       ProductCategory? newValue,
                                        //     ) {
                                        //       setState(() {
                                        //         selectedCategory = newValue;
                                        //       });
                                        //       logSuccess(
                                        //         'Selected: ${newValue!.name}',
                                        //       );
                                        //       logSuccess(
                                        //         'Selected ID: ${newValue.id}',
                                        //       );
                                        //     },
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        // Expanded(
                        //   child: TextFormContainer(
                        //     controller: _descriptionController,
                        //     maxline: 4,
                        //     initialValue: '',
                        //     labelText: 'Description',
                        //     onChanged: (value) {
                        //       description = value;
                        //     },
                        //     validator: (value) {
                        //       if (value == null ||
                        //           value.isEmpty ||
                        //           value.split(' ').length < 5) {
                        //         return 'Please enter at least 5 words';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
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
