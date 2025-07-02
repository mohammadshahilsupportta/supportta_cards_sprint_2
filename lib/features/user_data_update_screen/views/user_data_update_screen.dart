import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/core/api/error_exception_handler.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/product_porfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/views/add_user_portfolio.dart';
import 'package:taproot_admin/features/user_data_update_screen/views/edit_user_portfolio.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/about_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/basic_detail_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/location_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/portfolio_payment_widget.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/profile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/social_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/user_profile_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/widgets/common_product_container.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

import '../widgets/additional_container.dart';

class UserDataUpdateScreen extends StatefulWidget {
  final dynamic user;

  static const path = '/userDataUpdateScreen';
  const UserDataUpdateScreen({super.key, required this.user});

  @override
  State<UserDataUpdateScreen> createState() => _UserDataUpdateScreenState();
}

class _UserDataUpdateScreenState extends State<UserDataUpdateScreen> {
  final TextEditingController refController = TextEditingController();

  PortfolioDataModel? portfolio;
  late final User user;
  bool isLoading = false;
  bool? isPortfolioPaid;
  // late List<PortfolioProductModel> portfolioProductModel;
  List<PortfolioProductModel>? portfolioProductModel;

  @override
  void initState() {
    user = widget.user;
    fetchPortfolio();
    fetchPortfolioProducts();

    super.initState();
  }

  bool userEdit = false;
  void editUser() {
    setState(() {
      userEdit = !userEdit;
    });
  }

  Future<void> fetchPortfolioProducts() async {
    final result = await PortfolioService.getPortfolioProducts();
    setState(() {
      portfolioProductModel = result;
    });
  }

  // Future<void> fetchPortfolioProducts() async {
  //   portfolioProductModel = await PortfolioService.getPortfolioProducts();
  // }

  Future fetchPortfolio() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await PortfolioService.getPortfolio(userid: user.id);
      final paidStatus = await PortfolioService.isUserPaidPortfolio(
        userId: user.id,
      );
      if (result != null) {
        setState(() {
          portfolio = result;
          isPortfolioPaid = paidStatus;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        if (e is CustomException && e.statusCode == 404) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AddUserPortfolio(user: user)),
          );
        } else {
          logError(e.toString());

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  String? getServiceImageUrl() {
    logSuccess('Portfolio services: ${portfolio?.services}');
    if (portfolio?.services.isNotEmpty == true) {
      logSuccess('First service: ${portfolio!.services[0].toJson()}');
      logSuccess('Service image: ${portfolio!.services[0].image?.toJson()}');
    }

    if (portfolio?.services.isNotEmpty == true &&
        portfolio?.services[0].image?.key != null) {
      final imageUrl =
          '$baseUrlImage/portfolios/portfolio_services/${portfolio!.services[0].image!.key}';
      logSuccess('Generated image URL: $imageUrl');
      return imageUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(CustomPadding.paddingLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'User  >  User Details',
                            style: context.inter60016.copyWith(
                              color: CustomColors.buttonColor1,
                            ),
                          ),
                          Spacer(),
                          userEdit
                              ? MiniLoadingButton(
                                icon: Icons.save,
                                text: 'Save',
                                onPressed: () {},
                                useGradient: true,
                                gradientColors:
                                    CustomColors.borderGradient.colors,
                              )
                              : MiniLoadingButton(
                                icon: Icons.edit,
                                text: 'Edit',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EditUserPortfolio(
                                            user: widget.user,
                                            portfolio: portfolio,
                                            onCallFunction:
                                                () => fetchPortfolio(),
                                          ),
                                    ),
                                  );
                                },
                                useGradient: true,
                                gradientColors:
                                    CustomColors.borderGradient.colors,
                              ),
                          Gap(CustomPadding.paddingLarge.v),
                          MiniGradientBorderButton(
                            text: 'Back',
                            icon: Icons.arrow_back,
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            gradient: LinearGradient(
                              colors: CustomColors.borderGradient.colors,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingLarge.v),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge,
                      ),
                      child: Row(
                        children: [
                          UserProfileContainer(
                            imageUrl: portfolio?.personalInfo
                                .getProfilePictureUrl(baseUrl),
                            isEdit: userEdit,
                            user: user,
                            onPremiumChanged:
                                (value) => setState(() {
                                  user.isPremium = value;
                                }),
                          ),
                          Gap(CustomPadding.paddingXL.v),
                          BasicDetailContainer(
                            user: user,
                            isEdit: userEdit,
                            portfolio: portfolio,
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingXL.v),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge,
                      ),
                      child: Row(
                        children: [
                          ProfileContainer(
                            user: user,
                            isEdit: userEdit,
                            portfolio: portfolio,
                          ),
                          Gap(CustomPadding.paddingXL.v),

                          LocationContainer(
                            user: user,
                            isEdit: userEdit,
                            portfolio: portfolio,
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingXL.v),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge.v,
                      ),
                      child: Row(
                        children: [
                          AdditionalContainer(
                            logoImageUrl: portfolio?.workInfo.getCompanyLogoUrl(
                              baseUrl,
                            ),
                            bannerImageUrl: portfolio?.personalInfo
                                .getBannerImageUrl(baseUrl),
                            user: user,
                            isEdit: userEdit,
                            portfolio: portfolio,
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingXL.v),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge.v,
                      ),
                      child: Row(
                        children: [
                          SocialContainer(
                            onLinksChanged: (value) {},
                            isEdit: false,
                            user: user,
                            portfolio: portfolio,
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingXL.v),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.paddingLarge.v,
                      ),
                      child: Row(
                        children: [
                          AboutContainer(
                            user: user,
                            isEdit: userEdit,
                            portfolio: portfolio,
                          ),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingXL.v),

                    Visibility(
                      visible: !(portfolio?.services.isEmpty ?? true),
                      child: CommonProductContainer(
                        title: 'Your Services',
                        children: [
                          Gap(CustomPadding.paddingLarge.v),
                          Padding(
                            padding: EdgeInsets.only(
                              left: CustomPadding.paddingLarge.v,
                            ),
                            child: Text('Heading/Topic'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: CustomPadding.paddingLarge.v,
                            ),
                            child: Text(
                              portfolio?.serviceHeading.isNotEmpty == true
                                  ? portfolio!.serviceHeading
                                  : 'No heading available',
                              style: context.inter40016,
                            ),
                          ),
                          Gap(CustomPadding.paddingXL.v),
                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (portfolio?.services.length ?? 0)
                                  .clamp(0, 3),

                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        index == 0
                                            ? CustomPadding.paddingLarge.v
                                            : 0,
                                    right: CustomPadding.paddingLarge.v,
                                  ),
                                  child: ServiceCardWidget(
                                    baseUrl: baseUrl,
                                    service: portfolio!.services[index],
                                    portfolio: portfolio,
                                  ),
                                );
                              },
                            ),
                          ),
                          Gap(CustomPadding.paddingLarge),
                        ],
                      ),
                    ),
                    Gap(CustomPadding.paddingLarge),
                    // if (isPortfolioPaid == false)
                    if (isPortfolioPaid == false &&
                        portfolioProductModel != null)
                      PorfolioPaymentWidget(
                        portfolioProductModel: portfolioProductModel!,
                        user: user,
                        onProceed: () => fetchPortfolio(),
                      ),

                    Gap(CustomPadding.paddingXXL.v),
                  ],
                ),
              ),
    );
  }
}

class ServiceCardWidget extends StatelessWidget {
  final PortfolioDataModel? portfolio;
  final baseUrl;
  final Service service;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditMode;

  const ServiceCardWidget({
    super.key,
    required this.portfolio,
    required this.baseUrl,
    required this.service,
    this.onEdit,
    this.onDelete,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        '$baseUrlImage/portfolios/portfolio_services/${service.image!.key}';
    logSuccess('Full Image URL: $imageUrl');
    return Card(
      color: Colors.white,
      elevation: 8,
      surfaceTintColor: CustomColors.secondaryColor,

      shadowColor: Colors.black.withValues(alpha: 0.6),
      child: Container(
        padding: EdgeInsets.all(CustomPadding.paddingLarge.v),
        width: 350,
        height: 400,

        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.heading, style: context.inter50014),
                Gap(CustomPadding.paddingLarge.v),
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child:
                      service.image?.key != null
                          ? Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              logError('Image Error for $imageUrl: $error');
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: CustomColors.hintGrey,
                                ),
                              );
                            },
                          )
                          : const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: CustomColors.hintGrey,
                            ),
                          ),
                ),
                Gap(CustomPadding.paddingLarge.v),
                Text(
                  'Description',
                  style: TextStyle(color: CustomColors.textFieldBorderGrey),
                ),
                Gap(CustomPadding.paddingLarge.v),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(service.description),
                  ),
                ),
              ],
            ),
            if (isEditMode)
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      child: Text(
                        'Edit',
                        style: context.inter50016.copyWith(
                          color: CustomColors.green,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: onDelete,
                      child: Text(
                        'Delete',
                        style: context.inter50016.copyWith(
                          color: CustomColors.red,
                        ),
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
}
