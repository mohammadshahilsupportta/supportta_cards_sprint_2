import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_category_models.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_model.dart';
import 'package:taproot_admin/features/portfolio_product_screen/data/template_service.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/add_portfolio_product.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/portfolio_product_card.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/portfolio_product_container.dart';
import 'package:taproot_admin/features/portfolio_product_screen/widgets/view_portfolio_product.dart';
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

  // List<Product> _filteredProducts = [];
  List<Template> _filteredTemplates = [];

  // List<Map<String, Object>> products = [];
  List<Map<String, Object>> templates = [];
  // ProductResponse? product;
  TemplateResponse? template;
  // List<ProductCategory> productCategory = [];
  List<TemplateCategory> templateCategory = [];
  late TabController _tabController;
  void addProducts(Map<String, Object> product) {
    setState(() {
      templates.add(product);
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

    enabledList = List.generate(templates.length, (index) => true);

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _isLoadingMore = true;
      _currentPage++;
      fetchTemplate(page: _currentPage);
      // fetchProduct(page: _currentPage);
    }
  }

  Future<void> fetchInitialData() async {
    await fetchProductCategory();
    _tabController = TabController(
      length: templateCategory.length + 1,
      vsync: this,
    );
    logSuccess('TabController length: ${_tabController.length}');
    logSuccess(templateCategory.length + 1);

    for (int i = 1; i <= 5; i++) {
      await fetchTemplate(page: i);
      // await fetchProduct(page: i);
      if (!_hasMoreData) break;
    }
  }

  Future<void> fetchTemplate({int page = 1}) async {
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

      final response = await TemplateService.getTemplates(
        page: page,
        searchQuery: _currentSearchQuery,
        sort: _currentSort.apiParameter,
      );

      if (mounted) {
        setState(() {
          if (page == 1) {
            template = response;
            _filteredTemplates = response.results;

            enabledList =
                response.results.map((t) => t.status == "Active").toList();
          } else {
            template!.results.addAll(response.results);
            _filteredTemplates = template!.results;

            enabledList =
                template!.results.map((t) => t.status == "Active").toList();
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
      logError('Error fetching templates: $e');
    }
  }

  // Future<void> fetchProduct({int page = 1}) async {
  //   if (_isLoading) return;

  //   try {
  //     if (page == 1) {
  //       setState(() {
  //         _isLoading = true;
  //         _isLoadingMore = false;
  //         _hasMoreData = true;
  //         _currentPage = 1;
  //       });
  //     }

  //     final response = await ProductService.getProduct(
  //       page: page,
  //       searchQuery: _currentSearchQuery,
  //       sort: _currentSort.apiParameter,
  //     );

  //     if (mounted) {
  //       setState(() {
  //         if (page == 1) {
  //           product = response;
  //           _filteredProducts = response.results;

  //           enabledList =
  //               response.results.map((p) => p.status == "Active").toList();
  //         } else {
  //           product!.results.addAll(response.results);
  //           _filteredProducts = product!.results;

  //           enabledList =
  //               product!.results.map((p) => p.status == "Active").toList();
  //         }
  //         _hasMoreData = response.results.isNotEmpty;
  //         _isLoadingMore = false;
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //         _isLoadingMore = false;
  //       });
  //     }
  //     logError('Error fetching products: $e');
  //   }
  // }

  void _handleSort(SortOption sortOption) async {
    setState(() {
      _currentSort = sortOption;
      _currentPage = 1;
      _hasMoreData = true;
      template = null;
      _filteredTemplates = [];
      // _filteredProducts = [];
    });

    for (int i = 1; i <= 5; i++) {
      await fetchTemplate(page: i);
      // await fetchProduct(page: i);
      if (!_hasMoreData) break;
    }
  }

  Future<void> fetchProductCategory() async {
    try {
      final response = await TemplateService.getTemplateCategory();
      setState(() {
        templateCategory = response;
      });
    } catch (e) {
      logError('Error fetching product categories: $e');
    }
  }

  Future<void> refreshProducts() async {
    await fetchTemplate(page: 1);
    // await fetchProduct(page: 1);
  }

  void _handleSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _currentSearchQuery = query;
        _currentPage = 1;
        _hasMoreData = true;
      });
      fetchTemplate(page: 1);
      // fetchProduct(page: 1);
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
          template == null
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
                    PortfolioProductContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SearchWidget(
                                hintText: 'Search Template Name',

                                onChanged: _handleSearch,
                              ),
                              Spacer(),
                              // SortButton(
                              //   currentSort: _currentSort,
                              //   onSortChanged: _handleSort,
                              // ),
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
                              ...templateCategory.map(
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
                                buildProductGrid(_filteredTemplates),

                                // buildProductGrid(_filteredProducts),
                                ...templateCategory.map((category) {
                                  final categoryFilteredProducts =
                                      _filteredTemplates
                                          // _filteredProducts
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

  Widget buildProductGrid(List<Template> templates) {
    if (templates.isEmpty) {
      return NotFoundWidget();
    }

    return GridView.builder(
      controller: _scrollController,
      itemCount: templates.length + (_hasMoreData ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2,
        crossAxisCount: 2,
        mainAxisSpacing: CustomPadding.paddingXL.v,
        crossAxisSpacing: CustomPadding.paddingXL.v,
      ),
      itemBuilder: (context, index) {
        if (index == templates.length) {
          return _isLoadingMore
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink();
        }

        final productcard = templates[index];
        return GestureDetector(
          onTap: () async {
            final updated = await Navigator.of(context).push(
              // MaterialPageRoute(
              //   builder: (context) {
              //     return SizedBox();
              //   },
              // ),
              MaterialPageRoute(
                builder:
                    (context) => ViewPortfolioProduct(
                      template: productcard,
                      // product: productcard,
                      onBack: () => Navigator.pop(context),
                      onEdit: () => refreshProducts(),
                    ),
              ),
            );

            if (updated == true) {
              await refreshProducts();
            }
          },

          child: PortfolioProductCard(
            productCard: productcard,

            enabledList: enabledList,

            refreshCartItem: () async => await refreshProducts(),
            enabledIndex: index,
          ),
        );
      },
    );
  }
}
