import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/order_screen/data/order_detail_add.model.dart';
import 'package:taproot_admin/features/order_screen/data/order_service.dart';
import 'package:taproot_admin/features/order_screen/widgets/image_row_container.dart';
import 'package:taproot_admin/features/order_screen/widgets/product_card.dart';
import 'package:taproot_admin/features/product_screen/data/product_model.dart';
import 'package:taproot_admin/features/product_screen/widgets/card_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/add_user_location.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/image_pick_upload_preview.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/padding_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';
import 'package:taproot_admin/widgets/gradient_border_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

typedef RefreshOrdersCallback = Future<void> Function();
Future<Map<String, dynamic>?> showPaymentMethodDialog(
  BuildContext context,
) async {
  String selectedMethod = 'Razorpay';
  String selectedOfflineOption = 'Card';
  final offlineOptions = ['Card', 'UPI', 'NetBanking', 'Cash'];
  final TextEditingController refController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                borderRadius: BorderRadius.circular(
                  CustomPadding.paddingLarge.v,
                ),
              ),
              width: 600.h,
              height: SizeUtils.height * .6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: CustomColors.buttonColor1,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(CustomPadding.paddingLarge.v),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Select Payment Method',
                        style: context.inter60022.copyWith(
                          color: CustomColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Gap(CustomPadding.paddingLarge.v),

                  RadioListTile(
                    value: 'Razorpay',
                    groupValue: selectedMethod,
                    title: Text('Razorpay'),
                    onChanged:
                        (value) => setState(() => selectedMethod = value!),
                  ),
                  RadioListTile(
                    value: 'Offline',
                    groupValue: selectedMethod,
                    title: Text('Offline'),
                    onChanged:
                        (value) => setState(() => selectedMethod = value!),
                  ),
                  Gap(CustomPadding.paddingLarge.v),
                  if (selectedMethod == 'Offline') ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: CustomPadding.paddingXL,
                      ),
                      child: SizedBox(
                        width: 250.h,
                        child: DropdownButtonFormField<String>(
                          value: selectedOfflineOption,
                          items:
                              offlineOptions
                                  .map(
                                    (method) => DropdownMenuItem(
                                      value: method,
                                      child: Text(method),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(
                                () => selectedOfflineOption = value!,
                              ),
                          decoration: InputDecoration(
                            labelText: 'Offline Method',
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: CustomPadding.paddingLarge,
                      ),
                      child: SizedBox(
                        width: 275.h,
                        child: TextFormContainer(
                          labelText: 'Reference ID (optional)',
                          controller: refController,
                        ),
                      ),
                    ),
                    // TextFormField(
                    //   controller: refController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Reference ID (optional)',
                    //   ),
                    // ),
                  ],
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MiniGradientBorderButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(null),
                      ),
                      Gap(CustomPadding.paddingLarge.v),
                      // TextButton(
                      //   onPressed: () => Navigator.of(context).pop(null),
                      //   child: Text('Cancel'),
                      // ),
                      MiniLoadingButton(
                        useGradient: true,
                        needRow: false,
                        text: 'Confirm',
                        onPressed: () {
                          final paymentData = {
                            "paymentServiceProvider":
                                selectedMethod == 'Razorpay'
                                    ? 'RAZORPAY'
                                    : 'OFFLINE',
                            if (selectedMethod == 'Offline')
                              "paymentMethod":
                                  selectedOfflineOption.toUpperCase(),
                            if (refController.text.trim().isNotEmpty)
                              "referenceId": refController.text.trim(),
                          };
                          Navigator.of(context).pop(paymentData);
                          // Navigator.pushNamed(context,);
                        },
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     final paymentData = {
                      //       "paymentServiceProvider":
                      //           selectedMethod == 'Razorpay'
                      //               ? 'RAZORPAY'
                      //               : 'OFFLINE',
                      //       if (selectedMethod == 'Offline')
                      //         "paymentMethod":
                      //             selectedOfflineOption.toUpperCase(),
                      //       if (refController.text.trim().isNotEmpty)
                      //         "referenceId": refController.text.trim(),
                      //     };
                      //     Navigator.of(context).pop(paymentData);
                      //   },
                      //   child: Text('Confirm'),
                      // ),
                    ],
                  ),
                  Gap(CustomPadding.paddingLarge.v),
                ],
              ),
            ),
            // title: Text('Select Payment Method'),
            // content: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [

            //     ],
            //   ],
            // ),
            // actions: [

            // ],
          );
        },
      );
    },
  );
}

class CreateOrderDetails extends StatefulWidget {
  final Future<void> Function(String) fetchUser;
  final List<UserSearch> userSearchList;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String whatsAppNumber;
  final String userId;
  final String userIdCode;
  final RefreshOrdersCallback? refreshOrders;

  const CreateOrderDetails({
    super.key,
    required this.fetchUser,
    required this.email,
    required this.userSearchList,
    required this.fullName,
    required this.phoneNumber,
    required this.whatsAppNumber,
    required this.userId,
    required this.userIdCode,
    this.refreshOrders,
  });

  @override
  State<CreateOrderDetails> createState() => _CreateOrderDetailsState();
}

class _CreateOrderDetailsState extends State<CreateOrderDetails> {
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController productSearchController = TextEditingController();

  UserSearch? userSearchList;
  List<ProductSearch> productSearchList = [];
  List<ProductSearch> selectedProducts = [];
  Map<String?, int> productQuantities = {};

  String? orderId;
  bool shouldRebuildImageWidget = false;
  bool isLoading = false;
  bool isSearching = false;
  bool isLoadingProduct = false;
  bool isSearchingProduct = false;
  PickedImage? pickedImage;
  Uint8List? companyLogoPreviewBytes;
  String? companyLogoImageUrl;
  String companyLogoUploadState = 'Upload';

  Uint8List? profileImagePreviewBytes;
  String? profileImageImageUrl;
  String profileImageUploadState = 'Upload';

  bool isUploading = false;
  PortfolioDataModel? portfolio;
  Map<String, String> labelImageMap = {'company logo': ''};
  ImageSource? companyLogoSource;
  ImageSource? profileImageSource;

  // Add callback handlers
  void handleCompanyLogoChange(ImageSource imageSource) {
    setState(() {
      companyLogoSource = imageSource;
    });
  }

  void handleProfileImageChange(ImageSource imageSource) {
    setState(() {
      profileImageSource = imageSource;
    });
  }

  void removeImage({required bool isCompanyLogo}) {
    setState(() {
      if (isCompanyLogo) {
        companyLogoPreviewBytes = null;
        companyLogoImageUrl = null;

        companyLogoUploadState = 'Upload';
      } else {
        profileImagePreviewBytes = null;
        profileImageImageUrl = null;
        profileImageUploadState = 'Upload';
      }
      shouldRebuildImageWidget = true;
    });
  }

  @override
  void initState() {
    getOrderId();
    fetchPortfolio().then((value) => fetchPortfoliData());

    super.initState();
  }

  void fetchPortfoliData() {
    designationController.text = portfolio?.workInfo.designation ?? '';
    buildingController.text = portfolio?.addressInfo.buildingName ?? '';
    areaController.text = portfolio?.addressInfo.area ?? '';
    stateController.text = portfolio?.addressInfo.state ?? '';
    pincodeController.text = portfolio?.addressInfo.pincode ?? '';
    districtController.text = portfolio?.addressInfo.district ?? '';
    countryController.text=portfolio?.addressInfo.country??'';
    fullNameController.text = portfolio?.personalInfo.name ?? '';
  }

  Future<void> getOrderId() async {
    try {
      setState(() => isLoading = true);
      final result = await OrderService.getOrderId();
      setState(() {
        orderId = result;
        isLoading = false;
      });
      logSuccess("Order ID: $orderId");
    } catch (e) {
      setState(() => isLoading = false);
      logError('Error fetching order ID: $e');
    }
  }

  Future<void> fetchProducts(String searchQuery) async {
    try {
      setState(() {
        isLoadingProduct = true;
      });
      final response = await OrderService.fetchProduct(searchQuery);
      setState(() {
        productSearchList = response.productSearch;
        isLoadingProduct = false;
      });
    } catch (e) {
      setState(() {
        isLoadingProduct = false;
      });
      logError('Error searching product: $e');
    }
  }

  void onProductSelect(ProductSearch product) {
    setState(() {
      if (!selectedProducts.contains(product)) {
        selectedProducts.add(product);
        productQuantities[product.id] = 1;
      }
      productSearchController.clear();
      productSearchList.clear();
      isSearchingProduct = false;
    });
  }

  // void onProductSelect(ProductSearch product) {
  //   setState(() {
  //     if (!selectedProducts.contains(product)) {
  //       selectedProducts.add(product);
  //       productQuantities[product.id] = 1;
  //     }
  //   });
  // }

  void updateQuantity(String? productId, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        productQuantities[productId] = newQuantity;
      });
    }
  }

  void removeProduct(ProductSearch product) {
    setState(() {
      selectedProducts.remove(product);
      productQuantities.remove(product.id);
    });
  }

  double calculateProductTotal(ProductSearch product) {
    int quantity = productQuantities[product.id] ?? 1;
    return (product.salePrice ?? 0) * quantity;
  }

  double get grandTotal {
    return selectedProducts.fold(0.0, (sum, product) {
      return sum + calculateProductTotal(product);
    });
  }

  Future fetchPortfolio() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await PortfolioService.getPortfolio(
        userid: widget.userIdCode,
      );

      if (result != null) {
        setState(() {
          portfolio = result;

          if (portfolio?.workInfo.companyLogo?.key != null) {
            companyLogoUploadState = 'Replace';
          }
          if (portfolio?.personalInfo.profilePicture?.key != null) {
            profileImageUploadState = 'Replace';
          }
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        if (e is CustomException && e.statusCode == 404) {
        } else {
          logError(e.toString());

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  String? getPortfolioImageUrl(String? key) {
    if (key == null) return null;
    return '$baseUrl/file?key=portfolios/$key';
  }

  bool _validateInputs() {
    // Validate NFC Details
    if (fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter full name for NFC card')),
      );
      return false;
    }

    // Validate Address
    if (buildingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter building/house name')),
      );
      return false;
    }

    if (pincodeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter pincode')));
      return false;
    }

    if (districtController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter district')));
      return false;
    }

    if (stateController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter state')));
      return false;
    }

    // Validate Products
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one product')),
      );
      return false;
    }

    for (var product in selectedProducts) {
      final quantity = productQuantities[product.id] ?? 0;
      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter valid quantity for ${product.name}'),
          ),
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _createOrder() async {
    if (!_validateInputs()) return;
    if (orderId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order ID not available')));
      return;
    }

    try {
      setState(() => isLoading = true);

      final nfcDetails = NfcDetails(
        customerName: fullNameController.text,
        designation:
            designationController.text.trim().isEmpty
                ? null
                : designationController.text,
        // customerLogo: ImageSource(image: null, source: 'none'),
        // customerPhoto: ImageSource(image: null, source: 'none'),
        customerLogo: companyLogoSource ?? ImageSource(source: 'none'),
        customerPhoto: profileImageSource ?? ImageSource(source: 'none'),
      );

      final address = Address(
        name: widget.fullName,
        mobile: widget.phoneNumber,
        address1: buildingController.text,
        address2: areaController.text,
        pincode: pincodeController.text,
        district: districtController.text,
        state: stateController.text,
        country: countryController.text
        // country: 'India',
      );

      final products =
          selectedProducts.map((product) {
            return ProductQuantity(
              product: product.id ?? '',
              quantity: productQuantities[product.id] ?? 1,
            );
          }).toList();

      final orderData = OrderPostModel(
        nfcDetails: nfcDetails,
        totalPrice: grandTotal,
        products: products,
        address: address,
      );

      await OrderService.createOrder(
        userId: portfolio!.user.id,
        orderData: orderData,
      );

      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Order created successfully!');
      }

      if (widget.refreshOrders != null) {
        await widget.refreshOrders!();
      }
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      logError(e);
      if (mounted) {
        SnackbarHelper.showError(context, 'Error creating order: $e');
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> createOrderWithPaymentDialog(BuildContext context) async {
    final paymentInfo = await showPaymentMethodDialog(context);
    if (paymentInfo == null) return;

    try {
      final orderData = OrderPostModel(
        nfcDetails: NfcDetails(
          customerName: fullNameController.text,
          designation:
              designationController.text.trim().isEmpty
                  ? null
                  : designationController.text,
          customerLogo: companyLogoSource ?? ImageSource(source: 'none'),
          customerPhoto: profileImageSource ?? ImageSource(source: 'none'),
        ),
        totalPrice: grandTotal,
        products:
            selectedProducts
                .map(
                  (product) => ProductQuantity(
                    product: product.id ?? '',
                    quantity: productQuantities[product.id] ?? 1,
                  ),
                )
                .toList(),
        address: Address(
          name: widget.fullName,
          mobile: widget.phoneNumber,
          address1: buildingController.text,
          address2: areaController.text,
          pincode: pincodeController.text,
          district: districtController.text,
          state: stateController.text,
          // country: 'India',
          country: countryController.text,
        ),
        paymentServiceProvider: paymentInfo['paymentServiceProvider'],
        paymentMethod: paymentInfo['paymentMethod'],
        referenceId: paymentInfo['referenceId'],
      );

      await OrderService.createOrder(
        userId: portfolio!.user.id,
        orderData: orderData,
      );

      if (context.mounted) {
        SnackbarHelper.showSuccess(context, 'Order created successfully!');
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      logError(e);
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Error creating order: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(CustomPadding.paddingXL.v),

            Row(
              children: [
                Gap(CustomPadding.paddingXL.v),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Order',
                    style: context.inter60016.copyWith(
                      color: CustomColors.greenDark,
                    ),
                  ),
                ),
                Gap(CustomPadding.padding.v),
                Text(
                  '>',
                  style: context.inter60016.copyWith(
                    color: CustomColors.hintGrey,
                  ),
                ),
                Gap(CustomPadding.padding.v),
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (orderId != null)
                  Text(
                    orderId!,
                    style: context.inter60016.copyWith(
                      color: CustomColors.hintGrey,
                    ),
                  )
                else
                  Text(
                    'No Order ID',
                    style: context.inter60016.copyWith(
                      color: CustomColors.hintGrey,
                    ),
                  ),
                Spacer(),
                MiniGradientBorderButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  gradient: LinearGradient(
                    colors: CustomColors.borderGradient.colors,
                  ),
                ),
                Gap(CustomPadding.paddingLarge.v),
                MiniLoadingButton(
                  icon: LucideIcons.save,
                  text: 'Save',
                  onPressed:
                      selectedProducts.isNotEmpty
                          ? () => createOrderWithPaymentDialog(context)
                          : () {},
                  // onPressed: () => createOrderWithPaymentDialog(context),
                  // onPressed: _createOrder,
                  useGradient: selectedProducts.isNotEmpty,
                  backgroundColor: CustomColors.hintGrey,
                ),
                Gap(CustomPadding.paddingLarge.v),
              ],
            ),
            Gap(CustomPadding.paddingLarge.v),

            CommonProductContainer(
              title: 'Order Details',
              children: [
                Gap(CustomPadding.paddingLarge.v),
                // GradientBorderField(
                //   hintText: 'Search User name, User ID',
                //   onChanged: (value) async {
                //     setState(() {
                //       isSearching = value.isNotEmpty;
                //     });
                //     await widget.fetchUser(value);
                //   },
                // ),
                Gap(CustomPadding.paddingLarge.v),
                if (isLoading)
                  CircularProgressIndicator()
                else if (isSearching && widget.userSearchList.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: CustomPadding.paddingLarge,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        CustomPadding.padding.v,
                      ),
                      border: Border.all(color: CustomColors.hintGrey),
                    ),
                    height: 300,
                    child: ListView.builder(
                      itemCount: widget.userSearchList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              title: Padding(
                                padding: EdgeInsets.only(
                                  bottom: CustomPadding.paddingLarge.v,
                                ),
                                child: Text(
                                  widget.userSearchList[index].fullName,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'Phone Number- ${widget.userSearchList[index].phone}',
                                  ),
                                  Gap(CustomPadding.paddingLarge.v),
                                  Text(
                                    'user ID-${widget.userSearchList[index].userId}',
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Gap(CustomPadding.paddingLarge.v),
                          ],
                        );
                      },
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: CustomPadding.paddingXL.v,
                        ),
                        child: Column(
                          children: [
                            CardRow(
                              prefixText: 'Order ID',
                              suffixText: '$orderId',
                            ),
                            CardRow(
                              prefixText: 'Full Name',
                              suffixText: widget.fullName,
                            ),
                            CardRow(
                              prefixText: 'Email',
                              suffixText: widget.email,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: CustomPadding.paddingLarge.v,
                        ),
                        child: Column(
                          children: [
                            CardRow(
                              prefixText: 'Phone Number',
                              suffixText: widget.phoneNumber,
                            ),
                            CardRow(
                              prefixText: 'Whatsapp Number',
                              suffixText: widget.whatsAppNumber,
                            ),
                            CardRow(prefixText: '', suffixText: ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(CustomPadding.paddingXL.v),

                CommonProductContainer(
                  title: 'Choose Product',
                  children: [
                    Gap(CustomPadding.paddingLarge.v),
                    GradientBorderField(
                      controller: productSearchController,
                      hintText: 'Add Product + ',
                      onChanged: (value) {
                        fetchProducts(value);
                        setState(() {
                          isSearchingProduct = value.isNotEmpty;
                        });
                      },
                    ),
                    if (isLoadingProduct)
                      CircularProgressIndicator()
                    else if (isSearchingProduct && productSearchList.isNotEmpty)
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: CustomPadding.paddingLarge,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            CustomPadding.padding.v,
                          ),
                          border: Border.all(color: CustomColors.hintGrey),
                        ),
                        height: 300,
                        child: ListView.builder(
                          itemCount: productSearchList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    onProductSelect(productSearchList[index]);
                                  },
                                  title: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: CustomPadding.paddingLarge.v,
                                    ),
                                    child: Text(
                                      productSearchList[index].name ?? '',
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '₹${productSearchList[index].salePrice?.toString() ?? "0"}',
                                        style: context.inter50014,
                                      ),
                                      Text('Price'),
                                    ],
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    Gap(CustomPadding.paddingLarge.v),
                  ],
                ),

                if (selectedProducts.isNotEmpty)
                  CommonProductContainer(
                    isOrderDetails: true,
                    isAmountContainer: true,
                    title: '',
                    grandTotal: grandTotal,
                    children: [
                      Column(
                        children: [
                          Gap(CustomPadding.paddingLarge.v),
                          ...List.generate(
                            selectedProducts.length,
                            (index) => ProductCard(
                              image:
                                  selectedProducts[index]
                                      .productImages
                                      ?.first
                                      .key ??
                                  '',
                              productName: selectedProducts[index].name ?? '',
                              categoryName:
                                  selectedProducts[index].category?.name ?? '',
                              orderEdit: true,
                              price: selectedProducts[index].salePrice ?? 0,
                              discountPrice:
                                  selectedProducts[index].discountedPrice ?? 0,
                              quantity:
                                  productQuantities[selectedProducts[index]
                                      .id] ??
                                  1,
                              totalPrice: calculateProductTotal(
                                selectedProducts[index],
                              ),
                              onDelete:
                                  () => removeProduct(selectedProducts[index]),
                              onQuantityChanged:
                                  (newQuantity) => updateQuantity(
                                    selectedProducts[index].id,
                                    newQuantity,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            Gap(CustomPadding.paddingXXL.v),
            CommonProductContainer(
              title: 'NFC Card Details',
              children: [
                Gap(CustomPadding.paddingLarge.v),

                TextFormContainer(
                  labelText: 'Full Name',
                  controller: fullNameController,
                ),
                Gap(CustomPadding.paddingLarge.v),
                TextFormContainer(
                  labelText: 'Designation',
                  controller: designationController,
                ),
                Gap(CustomPadding.paddingXL.v),

                Row(
                  children: [
                    Gap(CustomPadding.paddingXL.v),

                    ImageRowContainer(
                      userCode: widget.userIdCode,
                      title: 'Company Logo',
                      imageType: 'companyLogo',
                      onImageChanged: handleCompanyLogoChange,
                    ),
                    ImageRowContainer(
                      userCode: widget.userIdCode,
                      title: 'Profile Image',
                      imageType: 'profilePicture',
                      onImageChanged: handleProfileImageChange,
                    ),
                  ],
                ),
              ],
            ),
            Gap(CustomPadding.paddingLarge.v),
            PaddingRow(
              children: [
                AddUserLocation(
                  buildingcontroller: buildingController,
                  areacontroller: areaController,
                  pincodecontroller: pincodeController,
                  districtcontroller: districtController,
                  statecontroller: stateController,
                  countrycontroller: countryController ,
                ),
              ],
            ),

            Gap(CustomPadding.paddingXXL.v),
          ],
        ),
      ),
    );
  }
}
