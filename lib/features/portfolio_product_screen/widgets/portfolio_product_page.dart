import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/add_portfolio_product.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/view_portfolio_product.dart';
import 'package:taproot_admin/features/product_screen/data/product_category_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/product_screen/data/product_service.dart';
import 'package:taproot_admin/features/product_screen/widgets/product_detail_row.dart';
import 'package:taproot_admin/features/product_screen/widgets/search_widget.dart';
import 'package:taproot_admin/features/product_screen/widgets/sort_button.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/not_found_widget.dart';

class PortfolioProductPage extends StatefulWidget {
  final VoidCallback addTap;
  final VoidCallback? viewTap;
  const PortfolioProductPage({super.key, required this.addTap, this.viewTap});

  @override
  State<PortfolioProductPage> createState() => _PortfolioProductPageState();
}

class _PortfolioProductPageState extends State<PortfolioProductPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isLoading = false;
  Timer? _searchDebounce;
  String _currentSearchQuery = '';

  List<Product> _filteredProducts = [];

  List<Map<String, Object>> products = [];
  ProductResponse? product;
  List<ProductCategory> productCategory = [];
  late TabController _tabController;
  void addProducts(Map<String, Object> product) {
    setState(() {
      products.add(product);
      enabledList.add(true);
    });
  }

  bool addProduct = false;
  List<bool> enabledList = [];

  bool viewProduct = false;
  SortOption _currentSort = SortOption.newItem;
  @override
  void initState() {
    super.initState();
    fetchInitialData();

    enabledList = List.generate(products.length, (index) => true);

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _isLoadingMore = true;
      _currentPage++;
      fetchProduct(page: _currentPage);
    }
  }

  Future<void> fetchInitialData() async {
    await fetchProductCategory();
    _tabController = TabController(
      length: productCategory.length + 1,
      vsync: this,
    );
    logSuccess('TabController length: ${_tabController.length}');
    logSuccess(productCategory.length + 1);

    for (int i = 1; i <= 5; i++) {
      await fetchProduct(page: i);
      if (!_hasMoreData) break;
    }
  }

  Future<void> fetchProduct({int page = 1}) async {
    if (_isLoading) return;

    try {
      if (page == 1) {
        setState(() {
          _isLoading = true;
          _isLoadingMore = false;
          _hasMoreData = true;
          _currentPage = 1;
        });
      }

      final response = await ProductService.getProduct(
        page: page,
        searchQuery: _currentSearchQuery,
        sort: _currentSort.apiParameter,
      );

      if (mounted) {
        setState(() {
          if (page == 1) {
            product = response;
            _filteredProducts = response.results;

            enabledList =
                response.results.map((p) => p.status == "Active").toList();
          } else {
            product!.results.addAll(response.results);
            _filteredProducts = product!.results;

            enabledList =
                product!.results.map((p) => p.status == "Active").toList();
          }
          _hasMoreData = response.results.isNotEmpty;
          _isLoadingMore = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
      logError('Error fetching products: $e');
    }
  }

  void _handleSort(SortOption sortOption) async {
    setState(() {
      _currentSort = sortOption;
      _currentPage = 1;
      _hasMoreData = true;
      product = null;
      _filteredProducts = [];
    });

    for (int i = 1; i <= 5; i++) {
      await fetchProduct(page: i);
      if (!_hasMoreData) break;
    }
  }

  Future<void> fetchProductCategory() async {
    try {
      final response = await ProductService.getProductCategory();
      setState(() {
        productCategory = response;
      });
    } catch (e) {
      logError('Error fetching product categories: $e');
    }
  }

  Future<void> refreshProducts() async {
    await fetchProduct(page: 1);
  }

  void _handleSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _currentSearchQuery = query;
        _currentPage = 1;
        _hasMoreData = true;
      });
      fetchProduct(page: 1);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _tabController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          product == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(CustomPadding.paddingLarge.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MiniLoadingButton(
                          icon: Icons.add,
                          text: 'Add Product',
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => AddPortfolioProduct(
                                      onSave: () => fetchInitialData(),
                                      onBack: () => Navigator.pop(context),
                                    ),
                              ),
                            );
                          },
                          useGradient: true,
                          gradientColors: CustomColors.borderGradient.colors,
                        ),
                        Gap(CustomPadding.paddingXL.v),
                      ],
                    ),
                    Gap(CustomPadding.paddingLarge.v),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge.v,
                        vertical: CustomPadding.paddingLarge.v,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge.v,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: floatingShadowLarge,

                        color: CustomColors.secondaryColor,
                        borderRadius: BorderRadius.circular(
                          CustomPadding.paddingLarge * 2,
                        ),
                      ),
                      width: double.infinity,
                      height: SizeUtils.height,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SearchWidget(
                                hintText: 'Search Template Name',

                                onChanged: _handleSearch,
                              ),
                              Spacer(),
                              SortButton(
                                currentSort: _currentSort,
                                onSortChanged: _handleSort,
                              ),
                            ],
                          ),
                          Gap(CustomPadding.paddingLarge.v),
                          TabBar(
                            controller: _tabController,
                            unselectedLabelColor: CustomColors.hintGrey,

                            unselectedLabelStyle: context.inter50016,
                            labelColor: CustomColors.textColor,
                            labelStyle: context.inter50016,
                            isScrollable: true,
                            indicatorColor: CustomColors.greenDark,
                            indicatorWeight: 4,
                            dragStartBehavior: DragStartBehavior.start,

                            tabs: [
                              const Tab(text: 'All'),
                              ...productCategory.map(
                                (category) => Tab(
                                  text:
                                      category.name[0].toUpperCase() +
                                      category.name.substring(1),
                                ),
                              ),
                            ],
                          ),
                          Gap(CustomPadding.paddingXL.v),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                buildProductGrid(_filteredProducts),

                                ...productCategory.map((category) {
                                  final categoryFilteredProducts =
                                      _filteredProducts
                                          .where(
                                            (product) =>
                                                product.category?.id ==
                                                category.id,
                                          )
                                          .toList();
                                  return buildProductGrid(
                                    categoryFilteredProducts,
                                  );
                                }),
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

  Widget buildProductGrid(List<Product> products) {
    if (products.isEmpty) {
      return NotFoundWidget();
    }

    return GridView.builder(
      controller: _scrollController,
      itemCount: products.length + (_hasMoreData ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2,
        crossAxisCount: 2,
        mainAxisSpacing: CustomPadding.paddingXL.v,
        crossAxisSpacing: CustomPadding.paddingXL.v,
      ),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return _isLoadingMore
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink();
        }

        final productcard = products[index];
        return GestureDetector(
          onTap: () async {
            final updated = await Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => ViewPortfolioProduct(
                      product: productcard,
                      onBack: () => Navigator.pop(context),
                      onEdit: () => refreshProducts(),
                    ),
              ),
            );

            if (updated == true) {
              await refreshProducts();
            }
          },

          child: Card(
            color: Colors.white,
            elevation: 8,

            shadowColor: Colors.black.withValues(alpha: 0.6),

            child: Column(
              children: [
                Gap(CustomPadding.paddingLarge.v),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(CustomPadding.paddingLarge.v),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors.hoverColor,
                          borderRadius: BorderRadius.circular(
                            CustomPadding.padding.v,
                          ),
                        ),
                        height: 320.v,
                        width: 200.v,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            CustomPadding.padding.v,
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                '$baseUrlImage/products/${productcard.productImages!.first.key}',

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productcard.name.toString(),
                            style: context.inter50014,
                          ),
                          Gap(CustomPadding.paddingLarge.v),
                          ProductDetaileRow(
                            cardType: productcard.category!.name ?? '',
                            price: productcard.actualPrice.toString(),
                            offerPrice: productcard.salePrice.toString(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomGap.gapLarge,
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Switch(
                                      value: enabledList[index],
                                      onChanged: (value) async {
                                        if (!mounted) return;

                                        try {
                                          BuildContext? dialogContext;
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext ctx) {
                                              dialogContext = ctx;
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          );

                                          final success =
                                              await ProductService.isProductEnable(
                                                productId: productcard.id ?? '',
                                              );

                                          // if (dialogContext != null &&
                                          //     mounted) {
                                          //   Navigator.of(dialogContext!).pop();
                                          // }

                                          if (!mounted) return;

                                          if (success) {
                                            setState(() {
                                              enabledList[index] = value;
                                            });

                                            // ScaffoldMessenger.of(
                                            //   context,
                                            // ).showSnackBar(
                                            //   const SnackBar(
                                            //     content: Text(
                                            //       'Product status updated successfully',
                                            //     ),
                                            //     backgroundColor: Colors.green,
                                            //   ),
                                            // );

                                            await refreshProducts();
                                          } else {
                                            // ScaffoldMessenger.of(
                                            //   context,
                                            // ).showSnackBar(
                                            //   const SnackBar(
                                            //     content: Text(
                                            //       'Failed to update product status',
                                            //     ),
                                            //     backgroundColor: Colors.red,
                                            //   ),
                                            // );
                                          }
                                        } catch (e) {
                                          // if (mounted) {
                                          //   Navigator.of(context).pop();
                                          //   ScaffoldMessenger.of(
                                          //     context,
                                          //   ).showSnackBar(
                                          //     SnackBar(
                                          //       content: Text(
                                          //         'Error updating product status: $e',
                                          //       ),
                                          //       backgroundColor: Colors.red,
                                          //     ),
                                          //   );
                                          // }
                                        }
                                      },
                                    ),
                                    Gap(CustomPadding.padding.v),
                                    Text(
                                      enabledList[index]
                                          ? 'Enable'
                                          : 'Disabled',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingLarge.v),
                  ],
                ),
                Gap(CustomPadding.paddingLarge.v),
              ],
            ),
          ),
        );
      },
    );
  }
}
