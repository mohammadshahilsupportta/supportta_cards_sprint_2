import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_service.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/template_detail_row.dart';

import '../../../exporter/exporter.dart';

class PortfolioProductCard extends StatefulWidget {
  final VoidCallback refreshCartItem;
  final int enabledIndex;
  final List<bool> enabledList;
  final Template productCard;

  const PortfolioProductCard({
    super.key,
    required this.productCard,
    required this.enabledList,
    required this.enabledIndex,
    required this.refreshCartItem,
  });

  @override
  State<PortfolioProductCard> createState() => _PortfolioProductCardState();
}

class _PortfolioProductCardState extends State<PortfolioProductCard> {
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withAlpha(150),
      child:
      //  Column(
      //   children: [
      // Gap(CustomPadding.paddingLarge.v),
      Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(CustomPadding.paddingLarge.v),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.hoverColor,
                borderRadius: BorderRadius.circular(CustomPadding.padding.v),
              ),
              height: 320.v,
              width: 200.v,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CustomPadding.padding.v),
                child: CachedNetworkImage(
                  imageUrl:
                      '$baseUrlImage/templates/${widget.productCard.thumbnail!.key}',
                  // '$baseUrlImage/products/${widget.productCard.productImages!.first.key}',
                  fit: BoxFit.fill,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.grey),
                      ),
                  errorWidget:
                      (context, url, error) =>
                          Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
          Gap(CustomPadding.paddingLarge.v),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(CustomPadding.paddingXL.v),

                Text(
                  capitalize(widget.productCard.name.toString()),
                  style: context.inter50014,
                ),
                Gap(CustomPadding.paddingLarge.v),
                TemplateDetailRow(
                  cardType: capitalize(widget.productCard.category!.name!),
                  // price: widget.productCard.actualPrice.toString(),
                  // offerPrice: widget.productCard.salePrice.toString(),
                ),
                CustomGap.gapLarge,
                Spacer(),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Gap(CustomPadding.paddingLarge.v),
                      Switch(
                        value: widget.enabledList[widget.enabledIndex],
                        onChanged: (value) async {
                          if (!mounted) return;

                          try {
                            BuildContext dialogContext = context;
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext ctx) {
                                // setState(() {
                                dialogContext = ctx;
                                // });

                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            final success =
                                await TemplateService.isTemplateEnable(
                                  templateId: widget.productCard.id ?? '',
                                );

                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop();
                            }

                            if (!mounted) return;

                            if (success) {
                              setState(() {
                                widget.enabledList[widget.enabledIndex] = value;
                              });

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Template status updated successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }

                              widget.refreshCartItem;
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Failed to update template status',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error updating template status: $e',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      Gap(CustomPadding.padding.v),
                      Text(
                        widget.enabledList[widget.enabledIndex]
                            ? 'Enable'
                            : 'Disabled',
                      ),
                    ],
                  ),
                ),
                CustomGap.gapLarge,
              ],
            ),
          ),
          Gap(CustomPadding.paddingLarge.v),
        ],
      ),
      // Gap(CustomPadding.paddingLarge.v),
      //   ],
      // ),
    );
  }
}
