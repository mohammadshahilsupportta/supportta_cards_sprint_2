import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/order_screen/data/invoice_download.dart';
import 'package:taproot_admin/features/order_screen/data/order_detail_add.model.dart'
    as add_model;
import 'package:taproot_admin/features/order_screen/data/order_details_model.dart'
    as order_details;
import 'package:taproot_admin/features/order_screen/data/order_model.dart';
import 'package:taproot_admin/features/order_screen/data/order_service.dart';
import 'package:taproot_admin/features/order_screen/data/order_user_model.dart';
import 'package:taproot_admin/features/order_screen/widgets/image_container_with_head.dart';
import 'package:taproot_admin/features/order_screen/widgets/image_row_container.dart';
import 'package:taproot_admin/features/order_screen/widgets/product_card.dart';
import 'package:taproot_admin/features/order_screen/widgets/refund_dialog.dart';
import 'package:taproot_admin/features/product_screen/widgets/card_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/views/user_data_update_screen.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/location_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart'
    as user_model;
import 'package:taproot_admin/gen/assets.gen.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class OrderDetailScreen extends StatefulWidget {
  final dynamic user;
  final Order order;

  final String orderId;
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.user,
    required this.order,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  TextEditingController buildingNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  File? selectedImageLoco;
  File? selectedImageBanner;
  bool isUpdating = false;
  bool isEdit = true;
  Map<String, int> editedQuantities = {};
  add_model.ImageSource? newCompanyLogo;
  add_model.ImageSource? newProfilePhoto;
  String selectedRefundType = 'full';
  order_details.OrderDetails? orderDetails;
  OrderResponseUser? orderUserDetail;
  late Order order;
  final TextEditingController percentageController = TextEditingController();
  double calculatedAmount = 0.0;
  double remainingAmount = 0.0;
  bool _isDownloading = false;

  user_model.User convertOrderUserToUser(OrderResponseUser orderUser) {
    return user_model.User(
      id: orderUser.result.user.id,
      fullName: orderUser.result.personalInfo.name,
      userId: orderUser.result.user.code,
      phone: orderUser.result.personalInfo.phoneNumber,
      whatsapp: orderUser.result.personalInfo.whatsappNumber,
      email: orderUser.result.personalInfo.email,
      website: '',
      isPremium: orderUser.result.user.isPremium,
    );
  }

  @override
  void initState() {
    order = widget.order;

    getOrderDetails().then((_) {
      if (orderDetails != null) {
        fetchExistingData();
        initializeQuantities();
        getUserData();
      }
    });

    super.initState();
  }

  void fetchExistingData() {
    buildingNameController.text = orderDetails!.address.address1;
    areaController.text = orderDetails!.address.address2;
    pincodeController.text = orderDetails!.address.pincode;
    stateController.text = orderDetails!.address.state;
    districtController.text = orderDetails!.address.district;
    customerNameController.text = orderDetails!.nfcDetails.customerName;
    designationController.text = orderDetails!.nfcDetails.designation;
  }

  void initializeQuantities() {
    for (var product in orderDetails!.products) {
      editedQuantities[product.product.id] = product.quantity.toInt();
    }
  }

  bool orderEdit = false;

  void editOrder() {
    setState(() {
      orderEdit = !orderEdit;

      if (orderEdit) {
        newCompanyLogo = add_model.ImageSource(
          image: add_model.ImageDetails(
            key: orderDetails!.nfcDetails.customerLogo.image.key,
            name: orderDetails!.nfcDetails.customerLogo.image.name,
            mimetype: orderDetails!.nfcDetails.customerLogo.image.mimetype,
            size: orderDetails!.nfcDetails.customerLogo.image.size,
          ),
          source: 'portfolio',
        );

        newProfilePhoto = add_model.ImageSource(
          image: add_model.ImageDetails(
            key: orderDetails!.nfcDetails.customerPhoto.image.key,
            name: orderDetails!.nfcDetails.customerPhoto.image.name,
            mimetype: orderDetails!.nfcDetails.customerPhoto.image.mimetype,
            size: orderDetails!.nfcDetails.customerPhoto.image.size,
          ),
          source: 'portfolio',
        );
      }
    });
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return CustomColors.green;
      case 'pending':
        return Colors.orangeAccent;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> getOrderDetails() async {
    try {
      final response = await OrderService.getOrderDetails(
        orderId: widget.order.id,
      );

      setState(() {
        orderDetails = response.result;
      });
    } catch (e, stackTrace) {
      logError('Failed to fetch order details: $e \nStack Trace: $stackTrace');
      if (mounted) {
        SnackbarHelper.showError(
          context,
          'Failed to fetch order details. Please try again.',
        );
      }
    }
  }

  bool isLoadingUser = false;

  Future<void> getUserData() async {
    try {
      setState(() => isLoadingUser = true);
      final response = await OrderService.getOrderedUser(
        orderId: widget.order.id,
      );

      if (response != null) {
        setState(() {
          orderUserDetail = response;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load user details')),
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while loading user details'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingUser = false);
      }
    }
  }

  Future<void> updateOrder() async {
    try {
      setState(() => isUpdating = true);

      final updateRequest = add_model.OrderPostModel(
        address: add_model.Address(
          name: orderDetails!.address.name,
          mobile: orderDetails!.address.mobile,
          address1: buildingNameController.text,
          address2: areaController.text,
          pincode: pincodeController.text,
          district: districtController.text,
          state: stateController.text,
          country: 'India',
        ),
        nfcDetails: add_model.NfcDetails(
          customerName: customerNameController.text,
          designation: designationController.text,
          customerLogo: add_model.ImageSource(
            image:
                newCompanyLogo?.image ??
                add_model.ImageDetails(
                  key: orderDetails!.nfcDetails.customerLogo.image.key,
                  name: orderDetails!.nfcDetails.customerLogo.image.name,
                  mimetype:
                      orderDetails!.nfcDetails.customerLogo.image.mimetype,
                  size: orderDetails!.nfcDetails.customerLogo.image.size,
                ),
            source: 'portfolio',
          ),
          customerPhoto: add_model.ImageSource(
            image:
                newProfilePhoto?.image ??
                add_model.ImageDetails(
                  key: orderDetails!.nfcDetails.customerPhoto.image.key,
                  name: orderDetails!.nfcDetails.customerPhoto.image.name,
                  mimetype:
                      orderDetails!.nfcDetails.customerPhoto.image.mimetype,
                  size: orderDetails!.nfcDetails.customerPhoto.image.size,
                ),
            source: 'portfolio',
          ),
        ),
        products:
            orderDetails!.paymentStatus.toLowerCase() == 'success'
                ? null
                : orderDetails!.products
                    .map(
                      (product) => add_model.ProductQuantity(
                        product:
                            product.product is String
                                ? product.product
                                : (product.product
                                        as order_details.ProductDetails)
                                    .id,
                        quantity:
                            editedQuantities[product.product is String
                                ? product.product
                                : (product.product
                                        as order_details.ProductDetails)
                                    .id] ??
                            product.quantity,
                      ),
                    )
                    .toList(),

        totalPrice: orderDetails!.totalPrice,
      );

      final editResponse = await OrderService.editOrder(
        orderId: widget.order.id,
        data: updateRequest.toJson(),
      );

      if (editResponse.success) {
        final freshDetails = await OrderService.getOrderDetails(
          orderId: widget.order.id,
        );

        setState(() {
          orderDetails = freshDetails.result;
          orderEdit = false;
          newCompanyLogo = null;
          newProfilePhoto = null;
          isUpdating = false;
        });

        if (mounted) {
          SnackbarHelper.showInfo(context, editResponse.message);
        }
      }
    } catch (e) {
      logError('Update failed: $e');
      if (mounted) {
        setState(() => isUpdating = false);
        SnackbarHelper.showInfo(context, 'Failed to update order: $e');
      }
    }
  }

  double calculateGrandTotal() {
    return orderDetails!.products.fold(0.0, (sum, product) {
      String productId =
          product.product is String
              ? product.product.toString()
              : (product.product as order_details.ProductDetails).id;

      int quantity = editedQuantities[productId] ?? product.quantity;
      return sum + (product.salePrice * quantity);
    });
  }

  Future<void> _handleDownload(BuildContext context) async {
    setState(() => _isDownloading = true);

    await downloadInvoicePdfWithoutPackage(context, orderDetails!.id);

    setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    String formatDateString(String dateString) {
      try {
        DateTime dateTime = DateTime.parse(dateString);
        return dateFormatter.format(dateTime);
      } catch (e) {
        return 'Invalid date';
      }
    }

    String formatTimeString(String dateString) {
      try {
        final dt = DateTime.parse(dateString);
        return DateFormat('hh:mm:ss a').format(dt.toLocal());
      } catch (_) {
        return 'Invalid date';
      }
    }

    return Scaffold(
      body:
          orderDetails == null
              ? CircularProgressIndicator()
              : SingleChildScrollView(
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
                              color: CustomColors.buttonColor1,
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
                        Text(
                          order.code,

                          style: context.inter60016.copyWith(
                            color: CustomColors.hintGrey,
                          ),
                        ),
                        Spacer(),
                        orderEdit
                            ? MiniGradientBorderButton(
                              text: 'Cancel',
                              onPressed: () {
                                editOrder();
                              },

                              gradient: LinearGradient(
                                colors: CustomColors.borderGradient.colors,
                              ),
                            )
                            : MiniLoadingButton(
                              icon: Icons.edit,
                              text: 'Edit',
                              onPressed: () {
                                editOrder();
                              },
                              useGradient: true,
                              gradientColors:
                                  CustomColors.borderGradient.colors,
                            ),
                        Gap(CustomPadding.paddingLarge.v),
                        orderEdit
                            ? MiniLoadingButton(
                              icon: LucideIcons.save,
                              text: 'Save',
                              onPressed: updateOrder,
                              useGradient: true,
                              gradientColors:
                                  CustomColors.borderGradient.colors,
                            )
                            : MiniGradientBorderButton(
                              text: 'Back',
                              icon: Icons.arrow_back,
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              gradient: LinearGradient(
                                colors: CustomColors.borderGradient.colors,
                              ),
                            ),
                        Gap(CustomPadding.paddingLarge.v),
                      ],
                    ),

                    Gap(CustomPadding.paddingLarge.v),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge.v,
                      ),
                      child: Row(
                        children: [
                          CommonUserContainer(
                            height: 260.v,
                            title: 'Order Details',
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            CustomPadding.paddingLarge.v,
                                      ),

                                      child: Column(
                                        spacing: CustomPadding.paddingLarge.v,
                                        children: [
                                          Gap(CustomPadding.padding.v),
                                          Row(
                                            children: [
                                              Text(
                                                'Full Name',
                                                style: context.inter50014
                                                    .copyWith(
                                                      color:
                                                          CustomColors.hintGrey,
                                                    ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  if (orderUserDetail != null) {
                                                    try {
                                                      final userForNavigation =
                                                          convertOrderUserToUser(
                                                            orderUserDetail!,
                                                          );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => UserDataUpdateScreen(
                                                                user:
                                                                    userForNavigation,
                                                              ),
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      logError(
                                                        'Navigation error: $e',
                                                      );
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Error navigating to user details: $e',
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                seconds: 3,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  orderUserDetail
                                                          ?.result
                                                          .personalInfo
                                                          .name ??
                                                      'N/A',
                                                  style: context.inter50014
                                                      .copyWith(
                                                        color:
                                                            CustomColors.green,
                                                      ),
                                                ),
                                              ),

                                              Gap(CustomPadding.padding.v),

                                              GestureDetector(
                                                onTap: () {
                                                  if (orderUserDetail != null) {
                                                    try {
                                                      final userForNavigation =
                                                          convertOrderUserToUser(
                                                            orderUserDetail!,
                                                          );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => UserDataUpdateScreen(
                                                                user:
                                                                    userForNavigation,
                                                              ),
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      logError(
                                                        'Navigation error: $e',
                                                      );
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Error navigating to user details: $e',
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                seconds: 3,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  Assets.svg.link,
                                                ),
                                              ),
                                            ],
                                          ),

                                          CardRow(
                                            prefixText: 'Email',
                                            suffixText:
                                                orderDetails?.user.email ??
                                                'N/A',
                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                          CardRow(
                                            prefixText: 'Phone Number',
                                            suffixText:
                                                orderUserDetail
                                                    ?.result
                                                    .personalInfo
                                                    .phoneNumber ??
                                                'N/A',

                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                          CardRow(
                                            prefixText: 'WhatsApp Number',
                                            suffixText:
                                                orderUserDetail
                                                    ?.result
                                                    .personalInfo
                                                    .whatsappNumber ??
                                                'N/A',

                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            CustomPadding.paddingLarge.v,
                                      ),

                                      child: Column(
                                        spacing: CustomPadding.paddingLarge.v,
                                        children: [
                                          Gap(CustomPadding.padding.v),

                                          CardRow(
                                            prefixText: 'Order ID',
                                            suffixText: widget.orderId,
                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                          CardRow(
                                            prefixText: 'Order Date',
                                            suffixText: formatDateString(
                                              orderDetails!.createdAt,
                                            ),

                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                          CardRow(
                                            prefixText: 'Order Status',
                                            suffixText:
                                                orderDetails!.orderStatus,
                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                          CardRow(
                                            prefixText: 'Order time',
                                            suffixText: formatTimeString(
                                              orderDetails!.createdAt,
                                            ),
                                            prefixstyle: context.inter50014
                                                .copyWith(
                                                  color: CustomColors.hintGrey,
                                                ),
                                            sufixstyle: context.inter50016
                                                .copyWith(
                                                  color: CustomColors.textColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingXL.v),
                    CommonProductContainer(
                      isAmountContainer: true,
                      title: 'Product Summary',
                      grandTotal: calculateGrandTotal(),

                      children: [
                        Column(
                          children: [
                            Gap(CustomPadding.paddingLarge.v),
                            ...List.generate(orderDetails!.products.length, (
                              index,
                            ) {
                              final product = orderDetails!.products[index];
                              final productDetails =
                                  product.product
                                          is order_details.ProductDetails
                                      ? product.product
                                          as order_details.ProductDetails
                                      : null;

                              return ProductCard(
                                orderType: orderDetails!.orderType,
                                image: productDetails?.firstImage?.key ?? '',
                                productName:
                                    productDetails?.name ??
                                    'Product Unavailable',
                                categoryName:
                                    productDetails?.category.name ?? 'N/A',
                                orderEdit: orderEdit,
                                price: product.salePrice,
                                discountPrice:
                                    productDetails?.discountedPrice ?? 0,
                                quantity:
                                    editedQuantities[productDetails?.id ??
                                        product.product.toString()] ??
                                    product.quantity,
                                totalPrice: product.totalPrice,
                                onQuantityChanged:
                                    orderEdit
                                        ? (newQuantity) {
                                          setState(() {
                                            String productId =
                                                productDetails?.id ??
                                                product.product.toString();
                                            editedQuantities[productId] =
                                                newQuantity;

                                            orderDetails!.products[index] =
                                                product.copyWith(
                                                  quantity: newQuantity,
                                                  totalPrice:
                                                      product.salePrice *
                                                      newQuantity,
                                                );
                                          });
                                        }
                                        : null,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                    orderDetails!.orderType == 'Portfolio'
                        ? SizedBox()
                        : Gap(CustomPadding.paddingXL.v),
                    orderDetails!.orderType == 'Portfolio'
                        ? SizedBox()
                        : CommonProductContainer(
                          title: 'NFC Card Details',
                          children: [
                            Gap(CustomPadding.paddingLarge.v),
                            TextFormContainer(
                              controller: customerNameController,
                              readonly: isEdit ? false : true,
                              labelText: 'Full Name',
                            ),
                            Gap(CustomPadding.paddingLarge.v),
                            TextFormContainer(
                              readonly: isEdit ? false : true,
                              labelText: 'Designation',
                              controller: designationController,
                            ),
                            Gap(CustomPadding.paddingXL.v),

                            if (orderEdit ||
                                orderDetails!
                                    .nfcDetails
                                    .customerLogo
                                    .image
                                    .key
                                    .isNotEmpty ||
                                orderDetails!
                                    .nfcDetails
                                    .customerPhoto
                                    .image
                                    .key
                                    .isNotEmpty)
                              Row(
                                children: [
                                  Gap(CustomPadding.paddingXL.v),
                                  if (orderEdit)
                                    ImageRowContainer(
                                      initialImage: newCompanyLogo,
                                      userCode: orderDetails!.user.id,
                                      title: 'Company Logo',
                                      imageType: 'companyLogo',
                                      onImageChanged: (imageSource) {
                                        setState(
                                          () => newCompanyLogo = imageSource,
                                        );
                                      },
                                    )
                                  else if (orderDetails!
                                      .nfcDetails
                                      .customerLogo
                                      .image
                                      .key
                                      .isNotEmpty)
                                    ImageContainerWithHead(
                                      heading: 'Company Logo',
                                      orderDetails: orderDetails,
                                      imageKey:
                                          orderDetails!
                                              .nfcDetails
                                              .customerLogo
                                              .image
                                              .key,
                                    ),
                                  Gap(CustomPadding.paddingXL.v),
                                  if (orderEdit)
                                    ImageRowContainer(
                                      initialImage: newProfilePhoto,
                                      userCode: orderDetails!.user.id,
                                      title: 'Profile Image',
                                      imageType: 'profilePicture',
                                      onImageChanged: (imageSource) {
                                        setState(
                                          () => newProfilePhoto = imageSource,
                                        );
                                      },
                                    )
                                  else if (orderDetails!
                                      .nfcDetails
                                      .customerPhoto
                                      .image
                                      .key
                                      .isNotEmpty)
                                    ImageContainerWithHead(
                                      heading: 'Profile Image',
                                      orderDetails: orderDetails,
                                      imageKey:
                                          orderDetails!
                                              .nfcDetails
                                              .customerPhoto
                                              .image
                                              .key,
                                    ),
                                ],
                              ),
                          ],
                        ),
                    orderDetails!.orderType == 'Portfolio'
                        ? SizedBox()
                        : Gap(CustomPadding.paddingXL.v),
                    orderDetails!.orderType == 'Portfolio'
                        ? SizedBox()
                        : orderEdit
                        ? Row(
                          children: [
                            Gap(CustomPadding.paddingLarge.v),

                            LocationContainer(
                              isEdit: true,
                              buildingNamecontroller: buildingNameController,
                              areaController: areaController,
                              districtController: districtController,
                              pincodeController: pincodeController,
                              stateController: stateController,
                            ),
                            Gap(CustomPadding.paddingLarge.v),
                          ],
                        )
                        : CommonProductContainer(
                          title: 'Shipping Address',
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: CustomPadding.paddingLarge.v,
                                    ),
                                    child: Column(
                                      spacing: CustomPadding.paddingLarge.v,
                                      children: [
                                        Gap(CustomPadding.padding.v),

                                        CardRow(
                                          prefixText: 'Building Name',
                                          suffixText:
                                              orderDetails!.address.address1,
                                        ),
                                        CardRow(
                                          prefixText: 'Area',
                                          suffixText:
                                              orderDetails!.address.address2,
                                        ),
                                        CardRow(
                                          prefixText: 'PinCode',
                                          suffixText:
                                              orderDetails!.address.pincode,
                                        ),
                                        Gap(CustomPadding.padding.v),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: CustomPadding.paddingLarge.v,
                                    ),
                                    child: Column(
                                      spacing: CustomPadding.paddingLarge.v,
                                      children: [
                                        Gap(CustomPadding.padding.v),

                                        CardRow(
                                          prefixText: 'District',
                                          suffixText:
                                              orderDetails!.address.district,
                                        ),
                                        CardRow(
                                          prefixText: 'State',
                                          suffixText:
                                              orderDetails!.address.state,
                                        ),
                                        CardRow(
                                          prefixText: 'Country',
                                          suffixText:
                                              orderDetails!.address.country,
                                        ),
                                        Gap(CustomPadding.padding.v),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    Gap(CustomPadding.paddingXL.v),

                    orderEdit
                        ? [
                              'pending',
                              'failed',
                              'cancelled',
                              'completed',
                            ].contains(orderDetails?.orderStatus.toLowerCase())
                            ? SizedBox()
                            : Center(
                              child: MiniLoadingButton(
                                needRow: false,
                                text: 'Cancel Order',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return RefundDialog(
                                        onRefresh: getOrderDetails,
                                        orderId: orderDetails!.id,
                                        totalAmount: calculateGrandTotal(),
                                      );
                                    },
                                  );
                                },

                                useGradient: true,
                                gradientColors:
                                    CustomColors.borderGradient.colors,
                              ),
                            )
                        : CommonProductContainer(
                          title: 'Payment Details',
                          children: [
                            Gap(CustomPadding.paddingLarge.v),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: CustomPadding.paddingLarge.v,
                                    ),
                                    child: Column(
                                      spacing: CustomPadding.paddingLarge,
                                      children: [
                                        CardRow(
                                          prefixText: 'Payment Status',
                                          suffixText:
                                              orderDetails!.paymentStatus,
                                          sufixstyle: context.inter50016
                                              .copyWith(
                                                color: _getPaymentStatusColor(
                                                  orderDetails!.paymentStatus,
                                                ),
                                              ),
                                        ),
                                        CardRow(
                                          prefixText: 'Payment Method',
                                          suffixText: orderDetails!.paymentMode,
                                          sufixstyle: context.inter50016,
                                        ),
                                        if (orderDetails!.paymentStatus
                                                .toLowerCase() ==
                                            'success')
                                          Row(
                                            children: [
                                              Text('Invoice'),
                                              Spacer(),

                                              TextButton(
                                                child: Text(
                                                  "Download",
                                                  style: context.inter50016
                                                      .copyWith(
                                                        color:
                                                            CustomColors
                                                                .buttonColor1,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                ),
                                                onPressed: () async {
                                                  _handleDownload(context);
                                                },
                                              ),
                                            ],
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
                                      spacing: CustomPadding.paddingLarge,
                                      children: [
                                        CardRow(
                                          prefixText: 'Transaction ID',
                                          suffixText:
                                              orderDetails?.razorpayPaymentId ??
                                              '',
                                          sufixstyle: context.inter50016,
                                        ),
                                        CardRow(
                                          prefixText: 'Total Amount',
                                          suffixText:
                                              ' ₹ ${orderDetails!.totalPrice}',
                                          sufixstyle: context.inter50016,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(CustomPadding.paddingLarge.v),
                          ],
                        ),
                    Gap(CustomPadding.paddingXXL.v),
                  ],
                ),
              ),
    );
  }
}
