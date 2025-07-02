import 'package:flutter/material.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/add_portfolio_product.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/portfolio_product_page.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/view_portfolio_product.dart';

import '../../product_screen/data/product_model.dart';

class PorfolioProduct extends StatefulWidget {
  const PorfolioProduct({super.key});

  @override
  State<PorfolioProduct> createState() => _PorfolioProductState();
}

class _PorfolioProductState extends State<PorfolioProduct> {
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
      return AddPortfolioProduct(onBack: closeCurrentView);
    }

    if (viewProduct && selectedProduct != null) {
      return ViewPortfolioProduct(
        product: selectedProduct!,
        onBack: closeCurrentView,
        onEdit: () {},
      );
    }

    return PortfolioProductPage(addTap: openAddProduct, viewTap: () {});
  }
}
