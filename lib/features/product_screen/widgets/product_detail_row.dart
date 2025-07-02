import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class ProductDetaileRow extends StatelessWidget {
  final String cardType;
  final String price;
  final String offerPrice;
  const ProductDetaileRow({
    super.key,
    required this.cardType,
    required this.price,
    required this.offerPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [Text('Design Type'), Spacer(), Text(cardType)]),
        Gap(CustomPadding.padding.v),
        Row(children: [Text('Price'), Spacer(), Text('₹$price')]),
        Gap(CustomPadding.padding.v),
        Row(children: [Text('Discounted Price'), Spacer(), Text('₹$offerPrice')]),
      ],
    );
  }
}
