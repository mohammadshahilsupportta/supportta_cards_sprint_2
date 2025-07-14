import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_service.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/edit_template_product.dart';
import 'package:taproot_admin/features/product_screen/widgets/card_row.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_id_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

import '../../user_data_update_screen/widgets/add_image_container.dart';

class ViewPortfolioProduct extends StatefulWidget {
  // final Product product;
  final Template template;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  const ViewPortfolioProduct({
    super.key,
    required this.template,
    required this.onBack,
    required this.onEdit,
    // required this.product
  });

  @override
  State<ViewPortfolioProduct> createState() => _ViewPortfolioProductState();
}

class _ViewPortfolioProductState extends State<ViewPortfolioProduct> {
  Template? currentProduct;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentProduct = widget.template;
  }

  Future<void> refreshProduct() async {
    logSuccess('Refreshing product...');

    try {
      setState(() => isLoading = true);
      final updated = await TemplateService.getTemplateById(
        templateId: widget.template.id.toString(),
      );
      setState(() {
        currentProduct = updated;
        isLoading = false;
      });
      logSuccess('Product refreshed: ${updated.name}');
    } catch (e) {
      logError('Refresh error: $e');
      setState(() => isLoading = false);
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || currentProduct == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final template = currentProduct!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(CustomPadding.paddingXL.v),
            Row(
              children: [
                Gap(CustomPadding.paddingXL.v),
                GestureDetector(
                  onTap: widget.onBack,
                  child: Text(
                    'Template',
                    style: context.inter60016.copyWith(
                      color: CustomColors.greenDark,
                    ),
                  ),
                ),
                Gap(CustomPadding.padding.v),
                Text('>', style: context.inter60016),
                Gap(CustomPadding.padding.v),
                Text(template.name.toString(), style: context.inter60016),
                const Spacer(),
                MiniLoadingButton(
                  icon: Icons.edit,
                  text: 'Edit',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => SizedBox()),
                      MaterialPageRoute(
                        builder:
                            (_) => EditTemplateProduct(
                              template: template,
                              // product: template,
                              onRefreshProduct: refreshProduct,
                            ),
                      ),
                    );
                    if (result == true) {
                      await refreshProduct();
                      widget.onEdit();
                    }
                  },
                  useGradient: true,
                  gradientColors: CustomColors.borderGradient.colors,
                ),
                Gap(CustomPadding.paddingLarge.v),
                MiniGradientBorderButton(
                  text: 'Back',
                  icon: Icons.arrow_back,
                  onPressed: widget.onBack,
                  gradient: LinearGradient(
                    colors: CustomColors.borderGradient.colors,
                  ),
                ),
                Gap(CustomPadding.paddingLarge.v),
              ],
            ),
            Gap(CustomPadding.paddingXL.v),
            Container(
              padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
              margin: EdgeInsets.symmetric(
                horizontal: CustomPadding.paddingLarge.v,
              ),
              decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: BorderRadius.circular(
                  CustomPadding.paddingLarge.v,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductIdContainer(productId: template.code.toString()),
                  Gap(CustomPadding.paddingLarge.v),
                  // if (product.productImages?.isNotEmpty ?? false)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      1,
                      (index) => SizedBox(
                        width: SizeUtils.width / 7,
                        child: AddViewImageContainer(
                          height: 300,
                          isImageView: true,
                          imageUrl:
                              '$baseUrlImage/templates/${template.thumbnail!.key}',
                        ),
                      ),
                    ),
                  ),
                  Gap(CustomPadding.paddingLarge.v),
                  Container(
                    margin: EdgeInsets.only(left: CustomPadding.paddingXL.v),
                    width: SizeUtils.width / 2.5,
                    child: Column(
                      spacing: CustomPadding.paddingLarge.v,

                      children: [
                        CardRow(
                          prefixText: 'Template Name',
                          suffixText: capitalize(template.name.toString()),
                        ),
                        // CardRow(
                        //   prefixText: 'Price',
                        //   suffixText: "₹${product.actualPrice ?? ''}",
                        // ),
                        // CardRow(
                        //   prefixText: 'Discounted Price',
                        //   suffixText: "₹${product.salePrice ?? ''}",
                        // ),
                        CardRow(
                          prefixText: 'Category',
                          suffixText: capitalize(
                            template.category!.name.toString(),
                          ),
                        ),
                        CardRow(
                          prefixText: 'Template Id',
                          suffixText: template.id.toString(),
                        ),
                        // CardRow(
                        //   prefixText: 'Description',
                        //   suffixText: product.description ?? '',
                        // ),
                      ],
                    ),
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
