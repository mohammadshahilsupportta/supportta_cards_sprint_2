import 'package:flutter/material.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/add_portfolio_product.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/portfolio_product_page.dart';


class PorfolioProduct extends StatefulWidget {
  const PorfolioProduct({super.key});

  @override
  State<PorfolioProduct> createState() => _PorfolioProductState();
}

class _PorfolioProductState extends State<PorfolioProduct> {
  bool addProduct = false;
  bool viewProduct = false;
  // Product? selectedProduct;
  Template? selectedTemplate;

  void openAddProduct() {
    setState(() {
      addProduct = true;
    });
  }

  void openViewProduct(Template template) {
    setState(() {
      selectedTemplate = template;
      viewProduct = true;
    });
  }

  void closeCurrentView() {
    setState(() {
      addProduct = false;
      viewProduct = false;
      selectedTemplate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (addProduct) {
      return AddPortfolioProduct(onBack: closeCurrentView);
    }

    // if (viewProduct && selectedProduct != null) {
    //   return ViewPortfolioProduct(
    //     product: selectedProduct!,
    //     onBack: closeCurrentView,
    //     onEdit: () {},
    //   );
    // }

    return PortfolioProductPage(addTap: openAddProduct, viewTap: () {});
  }
}
