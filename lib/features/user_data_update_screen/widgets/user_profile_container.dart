import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/gen/assets.gen.dart';

class UserProfileContainer extends StatefulWidget {
  final PortfolioDataModel? portfolio;
  final dynamic user;
  final bool isEdit;
  final ValueChanged<bool> onPremiumChanged;
  final String? imageUrl;
  final VoidCallback? onTapEdit;
  final Uint8List? previewImageBytes;

  const UserProfileContainer({
    super.key,
    this.isEdit = false,
    required this.user,
    this.portfolio,
    required this.onPremiumChanged,
    this.imageUrl,
    this.onTapEdit,
    this.previewImageBytes,
  });

  @override
  State<UserProfileContainer> createState() => _UserProfileContainerState();
}

class _UserProfileContainerState extends State<UserProfileContainer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final User user;
  bool isPremiumSelected = false;
  bool isUpdating = false;

  String userType = "";
  IconData userTypeIcon = Icons.check_circle;
  Color chipForeGroundColor = Colors.white;
  Color chipBackgroundColor = Colors.transparent;
  Color chipBorderColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    user = widget.user as User;
    setUserType();
    isPremiumSelected = user.isPremium;
    _tabController =
        TabController(length: 2, vsync: this)
          ..index = isPremiumSelected ? 1 : 0
          ..addListener(() {
            if (!_tabController.indexIsChanging) {
              final newVal = _tabController.index == 1;
              if (newVal != isPremiumSelected && !isUpdating) {
                _handlePremiumChange(newVal);
              }
            }
          });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _handlePremiumChange(bool newValue) async {
    if (isUpdating) return;

    setState(() {
      isUpdating = true;
    });

    try {
      final success = await PortfolioService.isUserPremium(userId: user.id);

      if (success) {
        if (mounted) {
          setState(() {
            isPremiumSelected = newValue;
            user.isPremium = newValue;
            widget.onPremiumChanged(newValue);
            setUserType();
          });
        }
      } else {
        _revertChanges(newValue);
        _showError('Failed to update premium status. Please try again.');
      }
    } catch (e) {
      _revertChanges(newValue);
      _showError('An error occurred while updating premium status');
      logError('Premium update error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  void _revertChanges(bool newValue) {
    if (mounted) {
      _tabController.animateTo(newValue ? 0 : 1);
      setState(() {
        isPremiumSelected = !newValue;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  void setUserType() {
    if (user.isPremium) {
      logSuccess("opted for premium");
      setState(() {
        userType = "Premium";
        chipForeGroundColor = Colors.white;
        chipBorderColor = Colors.transparent;
        chipBackgroundColor = CustomColors.buttonColor1;
        userTypeIcon = LucideIcons.crown;
      });
    } else {
      logError("opted for basic");
      setState(() {
        userType = 'Basic';
        chipForeGroundColor = CustomColors.buttonColor1;
        chipBorderColor = CustomColors.buttonColor1;
        chipBackgroundColor = Colors.transparent;
        userTypeIcon = LucideIcons.circleUserRound;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(CustomPadding.paddingLarge),
        ),
        // height: SizeUtils.height * 0.475,
        height: SizeUtils.height * .55,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 200.v,
                  height: 200.v,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      CustomPadding.paddingXXL,
                    ),
                    color: CustomColors.textColorLightGrey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      CustomPadding.paddingXXL,
                    ),
                    child:
                        widget.previewImageBytes != null
                            ? Image.memory(
                              widget.previewImageBytes!,
                              fit: BoxFit.cover,
                              cacheWidth: 300,
                              cacheHeight: 300,
                              gaplessPlayback: true,
                            )
                            : (widget.imageUrl != null &&
                                widget.imageUrl!.isNotEmpty)
                            ? CachedNetworkImage(
                              imageUrl: widget.imageUrl!,
                              fit: BoxFit.cover,
                              width: 300,
                              height: 300,
                              memCacheWidth: 300,
                              memCacheHeight: 300,
                              maxWidthDiskCache: 300,
                              maxHeightDiskCache: 300,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeInCurve: Curves.easeIn,
                              placeholder:
                                  (context, url) => Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 300,
                                      height: 300,
                                      color: Colors.white,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 40.v,
                                          color: CustomColors.textColorDarkGrey,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Failed to load image',
                                          style: TextStyle(
                                            color:
                                                CustomColors.textColorDarkGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            )
                            : Center(
                              child: Icon(
                                Icons.person,
                                size: 80.v,
                                color: CustomColors.textColorDarkGrey,
                              ),
                            ),
                  ),
                ),
                if (widget.isEdit)
                  Positioned(
                    top: 1,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(CustomPadding.padding),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .5),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: widget.onTapEdit,
                        child: Icon(
                          Icons.edit,
                          color: CustomColors.buttonColor1,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: CustomPadding.padding,
              ),
              child: Text(
                widget.user.userId,
                style: context.inter60020.copyWith(fontSize: 20.fSize),
              ),
            ),

            if (widget.isEdit)
              Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    CustomPadding.paddingXL.v,
                  ),
                  color: Colors.white,
                  border: Border.all(color: CustomColors.buttonColor1),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: CustomColors.borderGradient,
                    // color: CustomColors.buttonColor1,
                    borderRadius: BorderRadius.circular(
                      CustomPadding.paddingXL.v,
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: CustomColors.textColorDarkGrey,
                  tabs: [
                    Tab(text: 'Basic'),
                    Tab(
                      child: Row(
                        children: [
                          Text('Premium'),
                          Gap(CustomPadding.paddingSmall.v),
                          SvgPicture.asset(Assets.svg.premium),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomPadding.paddingXL.v,
                      ),
                      side: BorderSide(color: chipBorderColor, width: 1.0),
                    ),
                    backgroundColor: chipBackgroundColor,

                    label: Row(
                      children: [
                        Text(
                          userType,
                          style: context.inter40016.copyWith(
                            color: chipForeGroundColor,
                          ),
                        ),
                        CustomGap.gapSmall,
                        Icon(
                          userTypeIcon,
                          color: chipForeGroundColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
