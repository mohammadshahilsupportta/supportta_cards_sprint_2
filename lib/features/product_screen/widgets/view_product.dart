import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_service.dart';
import 'package:taproot_admin/features/product_screen/widgets/card_row.dart';
import 'package:taproot_admin/features/product_screen/widgets/edit_product.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_id_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/add_image_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class ViewProduct extends StatefulWidget {
  final Product product;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const ViewProduct({
    super.key,
    required this.product,
    required this.onBack,
    required this.onEdit,
  });

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  Product? currentProduct;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentProduct = widget.product;
  }

  Future<void> refreshProduct() async {
    try {
      setState(() => isLoading = true);
      final updated = await ProductService.getProductById(widget.product.id!);
      setState(() {
        currentProduct = updated;
        isLoading = false;
      });
    } catch (e) {
      logError('Refresh error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || currentProduct == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final product = currentProduct!;

    return Scaffold(
      body: Column(
        children: [
          Gap(CustomPadding.paddingXL.v),
          Row(
            children: [
              Gap(CustomPadding.paddingXL.v),
              GestureDetector(
                onTap: widget.onBack,
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
              Text(product.name ?? '', style: context.inter60016),
              const Spacer(),
              MiniLoadingButton(
                icon: Icons.edit,
                text: 'Edit',
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditProduct(
                            product: product,
                            onRefreshProduct: () {},
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
          Container(
            padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
            margin: EdgeInsets.symmetric(
              horizontal: CustomPadding.paddingLarge.v,
            ),
            decoration: BoxDecoration(
              color: CustomColors.secondaryColor,
              borderRadius: BorderRadius.circular(CustomPadding.paddingLarge.v),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductIdContainer(productId: product.code ?? ''),
                Gap(CustomPadding.paddingLarge.v),
                if (product.productImages?.isNotEmpty ?? false)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      product.productImages!.length,
                      (index) => SizedBox(
                        width: SizeUtils.width / 5,
                        child: AddImageContainer(
                          isImageView: true,
                          imageUrl:
                              '$baseUrlImage/products/${product.productImages![index].key}',
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
                        suffixText: product.name ?? '',
                      ),
                      CardRow(
                        prefixText: 'Price',
                        suffixText: "₹${product.actualPrice ?? ''}",
                      ),
                      CardRow(
                        prefixText: 'Discounted Price',
                        suffixText: "₹${product.salePrice ?? ''}",
                      ),
                      CardRow(
                        prefixText: 'Design Type',
                        suffixText: product.category?.name ?? '',
                      ),
                      CardRow(
                        prefixText: 'Description',
                        suffixText: product.description ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
