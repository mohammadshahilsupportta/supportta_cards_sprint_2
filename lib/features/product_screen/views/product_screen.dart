import 'package:flutter/material.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/product_screen/widgets/add_product.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_page.dart';
import 'package:taproot_admin/features/product_screen/widgets/view_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  static const path = '/productScreen';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool addProduct = false;
  bool viewProduct = false;

  Product? selectedProduct;

  void openAddProduct() {
    setState(() {
      addProduct = true;
    });
  }

  void openViewProduct(Product product) {
    setState(() {
      selectedProduct = product;
      viewProduct = true;
    });
  }

  void closeCurrentView() {
    setState(() {
      addProduct = false;
      viewProduct = false;
      selectedProduct = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (addProduct) {
      return AddProduct(onBack: closeCurrentView);
    }

    if (viewProduct && selectedProduct != null) {
      return ViewProduct(
        product: selectedProduct!,
        onBack: closeCurrentView,
        onEdit: () {},
      );
    }

    return ProductPage(addTap: openAddProduct, viewTap: () {});
  }
}
