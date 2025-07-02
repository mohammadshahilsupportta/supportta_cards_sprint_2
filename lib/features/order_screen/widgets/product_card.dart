import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/product_screen/widgets/card_row.dart';
import 'package:taproot_admin/gen/assets.gen.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard({
    super.key,
    required this.orderEdit,
    required this.discountPrice,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.categoryName,
    required this.productName,
    required this.image,
    this.onDelete,
    this.onQuantityChanged,
     this.orderType,

  });
  final String? orderType;
  final double price;
  final String productName;
  final double discountPrice;
  final bool orderEdit;
  final String categoryName;
  int? quantity;
  final String image;

  final double totalPrice;
  final VoidCallback? onDelete;
  final Function(int)? onQuantityChanged;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String formatPrice(double price) {
    String priceStr = price.toString();
    if (priceStr.contains('.')) {
      List<String> parts = priceStr.split('.');
      if (parts[1].length > 2) {
        // More than 2 decimals: truncate to 2
        return '${parts[0]}.${parts[1].substring(0, 2)}';
      } else if (parts[1].length == 1) {
        // Only 1 decimal: add trailing zero
        return '${parts[0]}.${parts[1]}0';
      }
    }
    return priceStr;
  }

  void handleQuantityChange(bool increase) {
    if (increase) {
      setState(() {
        widget.quantity = (widget.quantity ?? 0) + 1;
        widget.onQuantityChanged?.call(widget.quantity!);
      });
    } else {
      if (widget.quantity! > 1) {
        setState(() {
          if (widget.quantity != null) {
            widget.quantity = widget.quantity! - 1;
          }
          widget.onQuantityChanged?.call(widget.quantity!);
        });
      } else if (widget.quantity == 1) {
        // Call delete when quantity would go below 1
        widget.onDelete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 250,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.productName, style: context.inter60020),
                Gap(CustomPadding.paddingLarge.v),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: CustomPadding.paddingXXL.v,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.hoverColor,

                    borderRadius: BorderRadius.circular(
                      CustomPadding.padding.v,
                    ),
                  ),
                  width: double.infinity,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      CustomPadding.padding.v,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      '$baseUrlImage/products/${widget.image}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Assets.png.supporttalogo.path,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(
                  //     CustomPadding.padding.v,
                  //   ),
                  //   child: Image.network(
                  //     '$baseUrlImage/products/${widget.image}',
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) {
                  //       return Image.asset(Assets.png.backgroundlog.path,
                  //          // You must have this in your assets
                  //         fit: BoxFit.cover,
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: CustomPadding.paddingLarge.v,
            ),
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardRow(
                  prefixText: 'Design Type',
                  suffixText:
                      widget.categoryName[0].toUpperCase() +
                      widget.categoryName.substring(1),
                  sufixstyle: context.inter50014,
                ),
                CardRow(
                  prefixText: 'Price',
                  suffixText: formatPrice(widget.price),
                ),
                CardRow(
                  prefixText: 'Discount',
                  suffixText: formatPrice(widget.discountPrice),
                ),
                Row(
                  children: [
                    Text('Qty'),
                    Spacer(),
                    widget.orderEdit&&widget.orderType != 'Portfolio'
                        ? Row(
                          children: [
                            InkWell(
                              onTap: () => handleQuantityChange(false),
                              borderRadius: BorderRadius.circular(20),
                              child: Chip(
                                label: Icon(
                                  widget.quantity == 1
                                      ? Icons.delete
                                      : Icons.remove,
                                ),
                              ),
                            ),
                            Gap(CustomPadding.paddingLarge.v),
                            Text(widget.quantity.toString()),
                            Gap(CustomPadding.paddingLarge.v),
                            InkWell(
                              onTap: () => handleQuantityChange(true),
                              borderRadius: BorderRadius.circular(20),
                              child: Chip(label: Icon(Icons.add)),
                            ),
                          ],
                        )
                        //  Row(
                        //   children: [
                        //     Chip(
                        //       label: GestureDetector(
                        //         onTap: () => handleQuantityChange(false),
                        //         child: Icon(
                        //           widget.quantity == 1
                        //               ? Icons.delete
                        //               : Icons.remove,
                        //         ),
                        //       ),
                        //     ),
                        //     Gap(CustomPadding.paddingLarge.v),
                        //     Text(widget.quantity.toString()),
                        //     Gap(CustomPadding.paddingLarge.v),
                        //     Chip(
                        //       label: GestureDetector(
                        //         onTap: () => handleQuantityChange(true),
                        //         child: Icon(Icons.add),
                        //       ),
                        //     ),
                        //   ],
                        // )
                        : Chip(label: Text(widget.quantity.toString())),
                  ],
                ),
                CardRow(
                  prefixText: 'Total Amount',
                  suffixText: formatPrice(widget.totalPrice),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
