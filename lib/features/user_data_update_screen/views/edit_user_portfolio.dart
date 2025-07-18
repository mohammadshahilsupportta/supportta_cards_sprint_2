import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/views/add_user_portfolio.dart';
import 'package:taproot_admin/features/user_data_update_screen/views/user_data_update_screen.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/about_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/additional_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/basic_detail_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/expand_tile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/location_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/padding_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/profile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/social_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/user_profile_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/widgets/mini_gradient_border.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class EditUserPortfolio extends StatefulWidget {
  final PortfolioDataModel? portfolio;
  final VoidCallback onCallFunction;

  final User user;
  const EditUserPortfolio({
    super.key,
    required this.user,
    required this.portfolio,
    required this.onCallFunction,
  });

  @override
  State<EditUserPortfolio> createState() => _EditUserPortfolioState();
}

class _EditUserPortfolioState extends State<EditUserPortfolio> {
  final GlobalKey<LocationContainerState> locationKey =
      GlobalKey<LocationContainerState>();
  final GlobalKey<ProfileContainerState> profileKey =
      GlobalKey<ProfileContainerState>();

  PortfolioDataModel? theFetchedPortfolio;
  PlatformFile? pickedProfileImage;
  PlatformFile? pickedLogoImage;
  PlatformFile? pickedBannerImage;
  Uint8List? previewProfileBytes;
  Uint8List? previewLogoBytes;
  Uint8List? previewBannerBytes;
  ProductImage? pickedServiceImage;
  bool _showAddServiceUI = false;
  String? editingServiceId;
  List<SocialMedia> socialLinks = [];
  bool isLogoImageRemoved = false;
  bool isBannerImageRemoved = false;
  bool isProfileImageRemoved = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController whatsappNumberController =
      TextEditingController();
  final TextEditingController alternateNumberController =
      TextEditingController();
  final TextEditingController countryCodeAlternativeController =
      TextEditingController();

  final TextEditingController designationcontroller = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController workemailController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController buildingNamecontroller = TextEditingController();
  final TextEditingController primaryWebsiteController =
      TextEditingController();
  final TextEditingController secondaryWebsiteController =
      TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController headingcontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController serviceHeadController = TextEditingController();
  final TextEditingController mapUrlController = TextEditingController();
  final TextEditingController serviceHeadingController =
      TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();
  final TextEditingController countryCodePhoneController =
      TextEditingController();
  final TextEditingController countryCodeWhatsappController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchedTexfieldValue();
  }

  void fetchedTexfieldValue() {
    theFetchedPortfolio = widget.portfolio;
    gstinController.text = theFetchedPortfolio?.workInfo?.gstin ?? '';
    nameController.text = theFetchedPortfolio?.personalInfo.name ?? '';
    emailController.text = theFetchedPortfolio!.personalInfo.email;
    final fullPhone = theFetchedPortfolio?.personalInfo.phoneNumber ?? '';
    final phoneMatch = RegExp(r'^(\+\d{1,4})(\d+)$').firstMatch(fullPhone);
    if (phoneMatch != null) {
      countryCodePhoneController.text = phoneMatch.group(1)!;
      phoneNumberController.text = phoneMatch.group(2)!;
    } else if (fullPhone.startsWith('+')) {
      countryCodePhoneController.text = fullPhone.substring(0, 4);
      phoneNumberController.text = fullPhone.substring(4);
    } else {
      countryCodePhoneController.text = '';
      phoneNumberController.text = fullPhone;
    }

    final fullWhatsapp = theFetchedPortfolio?.personalInfo.whatsappNumber ?? '';
    final whatsappMatch = RegExp(
      r'^(\+\d{1,4})(\d+)$',
    ).firstMatch(fullWhatsapp);
    if (whatsappMatch != null) {
      countryCodeWhatsappController.text = whatsappMatch.group(1)!;
      whatsappNumberController.text = whatsappMatch.group(2)!;
    } else if (fullWhatsapp.startsWith('+')) {
      countryCodeWhatsappController.text = fullWhatsapp.substring(0, 4);
      whatsappNumberController.text = fullWhatsapp.substring(4);
    } else {
      countryCodeWhatsappController.text = '';
      whatsappNumberController.text = fullWhatsapp;
    }

    final fullAlternate =
        theFetchedPortfolio?.personalInfo.alternateNumber ?? '';
    final alternateMatch = RegExp(
      r'^(\+\d{1,4})(\d+)$',
    ).firstMatch(fullAlternate);
    if (alternateMatch != null) {
      countryCodeAlternativeController.text = alternateMatch.group(1)!;
      alternateNumberController.text = alternateMatch.group(2)!;
    } else if (fullAlternate.startsWith('+')) {
      countryCodeAlternativeController.text = fullAlternate.substring(0, 4);
      alternateNumberController.text = fullAlternate.substring(4);
    } else {
      countryCodeAlternativeController.text = '';
      alternateNumberController.text = fullAlternate;
    }

    companyNameController.text =
        theFetchedPortfolio!.workInfo?.companyName ?? "";
    designationcontroller.text =
        theFetchedPortfolio!.workInfo?.designation ?? "";
    workemailController.text = theFetchedPortfolio!.workInfo!.workEmail;
    areaController.text = theFetchedPortfolio!.addressInfo?.area ?? "";
    pincodeController.text = theFetchedPortfolio!.addressInfo?.pincode ?? '';
    districtController.text = theFetchedPortfolio!.addressInfo?.district ?? '';
    stateController.text = theFetchedPortfolio!.addressInfo?.state ?? "";
    countryController.text = theFetchedPortfolio!.addressInfo?.country ?? "";
    buildingNamecontroller.text =
        theFetchedPortfolio!.addressInfo?.buildingName ?? '';
    primaryWebsiteController.text =
        theFetchedPortfolio!.workInfo?.primaryWebsite ?? "";
    secondaryWebsiteController.text =
        theFetchedPortfolio!.workInfo?.secondaryWebsite ?? "";
    headingcontroller.text = theFetchedPortfolio!.about.heading;
    descriptioncontroller.text = theFetchedPortfolio!.about.description;
    mapUrlController.text = theFetchedPortfolio?.addressInfo?.mapUrl ?? '';
    if (theFetchedPortfolio!.services.isNotEmpty) {
      serviceHeadController.text = theFetchedPortfolio!.serviceHeading;
      serviceHeadingController.text = theFetchedPortfolio!.services[0].heading;
      serviceDescriptionController.text =
          theFetchedPortfolio!.services[0].description;
    } else {
      serviceHeadingController.text = '';
      serviceDescriptionController.text = '';
    }
  }

  Future<void> editPortfolio() async {
    try {
      final portfolio = widget.portfolio!;
      final Map<String, dynamic> updateData = {};

      try {
        final Map<String, dynamic> personalInfo = {};

        if (pickedProfileImage?.bytes != null) {
          try {
            final profileUploadResult = await PortfolioService.uploadImageFile(
              pickedProfileImage!.bytes!,
              pickedProfileImage!.name,
            );
            personalInfo['profilePicture'] = {
              'name': profileUploadResult['name'] ?? '',
              'key': profileUploadResult['key'] ?? '',
              'size': profileUploadResult['size'] ?? 0,
              'mimetype': profileUploadResult['mimetype'] ?? '',
            };
          } catch (e) {
            logError('Error uploading profile: $e');
          }
        }

        if (pickedBannerImage?.bytes != null) {
          try {
            final bannerUploadResult = await PortfolioService.uploadImageFile(
              pickedBannerImage!.bytes!,
              pickedBannerImage!.name,
            );
            personalInfo['bannerImage'] = {
              'name': bannerUploadResult['name'] ?? '',
              'key': bannerUploadResult['key'] ?? '',
              'size': bannerUploadResult['size'] ?? 0,
              'mimetype': bannerUploadResult['mimetype'] ?? '',
            };
          } catch (e) {
            logError('Error uploading banner: $e');
          }
        } else if (isBannerImageRemoved) {
          personalInfo['bannerImage'] = null;
        }

        if (nameController.text != portfolio.personalInfo.name) {
          personalInfo['name'] = nameController.text;
        }
        if (emailController.text != portfolio.personalInfo.email) {
          personalInfo['email'] = emailController.text;
        }
        final String phoneCountryCode = countryCodePhoneController.text.trim();
        final String phoneLocal = phoneNumberController.text.trim();
        if (phoneLocal.isNotEmpty && phoneCountryCode.isNotEmpty) {
          final fullPhone = '$phoneCountryCode$phoneLocal';
          if (fullPhone != portfolio.personalInfo.phoneNumber) {
            personalInfo['phoneNumber'] = fullPhone;
          }
        }

        final String whatsappCountryCode =
            countryCodeWhatsappController.text.trim();
        final String whatsappLocal = whatsappNumberController.text.trim();
        if (whatsappLocal.isNotEmpty && whatsappCountryCode.isNotEmpty) {
          final fullWhatsapp = '$whatsappCountryCode$whatsappLocal';
          if (fullWhatsapp != portfolio.personalInfo.whatsappNumber) {
            personalInfo['whatsappNumber'] = fullWhatsapp;
          }
        }

        final String alternateCountryCode =
            countryCodeAlternativeController.text.trim();
        final String alternateLocal = alternateNumberController.text.trim();
        if (alternateLocal.isNotEmpty && alternateCountryCode.isNotEmpty) {
          final fullAlternate = '$alternateCountryCode$alternateLocal';
          if (fullAlternate != portfolio.personalInfo.alternateNumber) {
            personalInfo['alternateNumber'] = fullAlternate;
          }
        }

        updateData['personalInfo'] = {
          ...personalInfo,
          if (isBannerImageRemoved && pickedBannerImage == null)
            'bannerImage': null,
          if (isProfileImageRemoved && pickedProfileImage == null)
            'profilePicture': null,
        };
      } catch (e) {
        logError('Error processing personalInfo: $e');
      }

      try {
        final Map<String, dynamic> workInfo = {};

        if (pickedLogoImage?.bytes != null) {
          try {
            final logoUploadResult = await PortfolioService.uploadImageFile(
              pickedLogoImage!.bytes!,
              pickedLogoImage!.name,
            );
            workInfo['companyLogo'] = {
              'name': logoUploadResult['name'] ?? '',
              'key': logoUploadResult['key'] ?? '',
              'size': logoUploadResult['size'] ?? 0,
              'mimetype': logoUploadResult['mimetype'] ?? '',
            };
          } catch (e) {
            logError('Error uploading logo: $e');
          }
        } else if (isLogoImageRemoved) {
          workInfo['companyLogo'] = null;
        }

        if (companyNameController.text != portfolio.workInfo?.companyName) {
          workInfo['companyName'] = companyNameController.text;
        }
        if (designationcontroller.text != portfolio.workInfo?.designation) {
          workInfo['designation'] = designationcontroller.text;
        }
        if (workemailController.text != portfolio.workInfo?.workEmail) {
          workInfo['workEmail'] = workemailController.text;
        }
        if (gstinController.text != portfolio.workInfo?.gstin) {
          workInfo['gstin'] = gstinController.text;
        }
        if (primaryWebsiteController.text !=
            portfolio.workInfo?.primaryWebsite) {
          workInfo['primaryWebsite'] = primaryWebsiteController.text;
        }
        if (secondaryWebsiteController.text !=
            portfolio.workInfo?.secondaryWebsite) {
          workInfo['secondaryWebsite'] = secondaryWebsiteController.text;
        }
        updateData['workInfo'] = {
          ...workInfo,
          if (isLogoImageRemoved && pickedLogoImage == null)
            'companyLogo': null,
        };
      } catch (e) {
        logError('Error processing workInfo: $e');
      }

      try {
        final Map<String, dynamic> addressInfo = {};
        if (buildingNamecontroller.text !=
            portfolio.addressInfo?.buildingName) {
          addressInfo['buildingName'] = buildingNamecontroller.text;
        }
        if (areaController.text != portfolio.addressInfo?.area) {
          addressInfo['area'] = areaController.text;
        }
        if (pincodeController.text != portfolio.addressInfo?.pincode) {
          addressInfo['pincode'] = pincodeController.text;
        }
        if (districtController.text != portfolio.addressInfo?.district) {
          addressInfo['district'] = districtController.text;
        }
        if (stateController.text != portfolio.addressInfo?.state) {
          addressInfo['state'] = stateController.text;
        }
        if (countryController.text != portfolio.addressInfo?.country) {
          addressInfo['country'] = countryController.text;
        }
        if (mapUrlController.text != portfolio.addressInfo?.mapUrl) {
          addressInfo['mapUrl'] = mapUrlController.text;
        }

        if (addressInfo.isNotEmpty) {
          updateData['addressInfo'] = addressInfo;
        }
      } catch (e) {
        logError('Error processing addressInfo: $e');
      }

      try {
        final Map<String, dynamic> about = {};
        if (headingcontroller.text != portfolio.about.heading) {
          about['heading'] = headingcontroller.text;
        }
        if (descriptioncontroller.text != portfolio.about.description) {
          about['description'] = descriptioncontroller.text;
        }

        if (about.isNotEmpty) {
          updateData['about'] = about;
        }
      } catch (e) {
        logError('Error processing about: $e');
      }

      try {
        if (serviceHeadController.text != portfolio.serviceHeading) {
          updateData['serviceHeading'] = serviceHeadController.text;
        }
      } catch (e) {
        logError('Error processing serviceHeading: $e');
      }

      try {
        if (theFetchedPortfolio?.socialMedia != null) {
          final socialMediaList =
              theFetchedPortfolio!.socialMedia
                  .map((social) => social.toJson())
                  .toList();

          if (socialMediaList.isNotEmpty) {
            updateData['socialMedia'] = socialMediaList;
          }
        }
      } catch (e) {
        logError('Error processing socialMedia: $e');
      }

      if (updateData.isNotEmpty) {
        logSuccess('Sending update with changed fields: $updateData');

        await PortfolioService.editPortfolio(
          userid: widget.user.id,
          portfolioEditedData: updateData,
        );

        if (mounted) {
          SnackbarHelper.showSuccess(context, 'Portfolio updated successfully');
        }
      } else {
        if (mounted) {
          SnackbarHelper.showInfo(context, 'No changes to update');
        }
      }
    } catch (e, stackTrace) {
      logError('Error editing portfolio: $e');
      logError('Stack trace: $stackTrace');
      if (mounted) {
        SnackbarHelper.showError(context, 'Failed to update portfolio: $e');
      }
    }
  }

  bool isLoading = false;

  Future<void> addServiceToPortfolio() async {
    setState(() {
      isLoading = true;
    });

    try {
      final portfolio = widget.portfolio;
      if (portfolio == null) return;

      if (serviceHeadingController.text.trim().isEmpty ||
          serviceDescriptionController.text.trim().isEmpty) {
        SnackbarHelper.showInfo(context, 'Please fill in both fields');

        return;
      }
      if (pickedServiceImage == null) {
        SnackbarHelper.showInfo(context, 'Please select an image');

        return;
      }

      logInfo('Adding service with data:');
      logInfo('Heading: ${serviceHeadingController.text}');
      logInfo('Description: ${serviceDescriptionController.text}');
      if (pickedServiceImage != null) {
        logInfo('Image key: ${pickedServiceImage!.key}');
      }

      final serviceData = {
        'heading': serviceHeadingController.text.trim(),
        'description': serviceDescriptionController.text.trim(),
        if (pickedServiceImage != null) 'image': pickedServiceImage!.toJson(),
      };

      final response = await PortfolioService.addService(
        userId: widget.user.id,
        portfolioId: portfolio.id,
        serviceData: serviceData,
      );
      setState(() {
        isLogoImageRemoved = false;
        isBannerImageRemoved = false;
      });

      setState(() {
        theFetchedPortfolio = response;
        _showAddServiceUI = false;
      });

      serviceHeadingController.clear();
      serviceDescriptionController.clear();
      setState(() {
        pickedServiceImage = null;
      });
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Service added successfully');
      }
    } catch (e) {
      logError('Error adding service to portfolio: $e');
      if (mounted) {
        SnackbarHelper.showError(context, 'Failed to add service');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void pickProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          pickedProfileImage = result.files.first;
          previewProfileBytes = pickedProfileImage!.bytes;
        });
      }
    } catch (e) {
      logError('Error picking or uploading profile image: $e');
      if (mounted) {
        SnackbarHelper.showError(context, 'Error uploading profile image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(CustomPadding.paddingLarge.v),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MiniLoadingButton(
                  icon: Icons.save,
                  text: 'Save',

                  onPressed: () async {
                    locationKey.currentState?.validateMapUrlField();
                    final hasErrorMapUrl =
                        locationKey.currentState?.mapUrlErrorText != null;
                    final isGstinValid =
                        profileKey.currentState?.validateGstinField() ?? true;
                    if (hasErrorMapUrl) {
                      SnackbarHelper.showError(
                        context,
                        'Please correct the map URL',
                      );
                      return;
                    }
                    if (!isGstinValid) {
                      SnackbarHelper.showError(
                        context,
                        'The GSTIN entered is not in a valid format. Please correct it before proceeding.',
                      );
                      return;
                    }
                    await editPortfolio();
                    if (!mounted) return;
                    widget.onCallFunction();
                    Navigator.pop(context);
                  },
                  useGradient: true,
                  gradientColors: CustomColors.borderGradient.colors,
                ),
                Gap(CustomPadding.paddingLarge.v),
                MiniGradientBorderButton(
                  text: 'Back',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pop(context, true);
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
              padding: const EdgeInsets.symmetric(
                horizontal: CustomPadding.paddingLarge,
              ),
              child: Row(
                children: [
                  UserProfileContainer(
                    previewImageBytes: previewProfileBytes,
                    onTapEdit: pickProfileImage,
                    imageUrl: widget.portfolio?.personalInfo
                        .getProfilePictureUrl(baseUrl),

                    isEdit: true,
                    user: widget.user,
                    onPremiumChanged: (value) => setState(() {}),
                  ),
                  Gap(CustomPadding.paddingXL.v),
                  BasicDetailContainer(
                    autofocus: false,
                    countryCodephoneController: countryCodePhoneController,
                    countryCodewhatsappController:
                        countryCodeWhatsappController,
                    namecontroller: nameController,
                    emailController: emailController,
                    whatsappController: whatsappNumberController,
                    phoneController: phoneNumberController,
                    alternateController: alternateNumberController,
                    countryCodeAlternateController:
                        countryCodeAlternativeController,

                    user: widget.user,
                    isEdit: true,
                    portfolio: widget.portfolio,
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
                    key: profileKey,
                    gstinController: gstinController,
                    designationController: designationcontroller,
                    companyController: companyNameController,
                    workEmailController: workemailController,
                    user: widget.user,
                    isEdit: true,
                    portfolio: widget.portfolio,
                  ),
                  Gap(CustomPadding.paddingXL.v),

                  LocationContainer(
                    key: locationKey,
                    buildingNamecontroller: buildingNamecontroller,
                    areaController: areaController,
                    pincodeController: pincodeController,
                    districtController: districtController,
                    stateController: stateController,
                    countryController: countryController,
                    user: widget.user,
                    isEdit: true,
                    portfolio: widget.portfolio,
                    mapUrlController: mapUrlController,
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
                    onLogoRemoved: () {
                      setState(() {
                        pickedLogoImage = null;
                        previewLogoBytes = null;
                        isLogoImageRemoved = true;
                      });
                    },
                    onBannerRemoved: () {
                      setState(() {
                        pickedBannerImage = null;
                        previewBannerBytes = null;
                        isBannerImageRemoved = true;
                      });
                    },
                    logoImageUrl: widget.portfolio?.workInfo?.getCompanyLogoUrl(
                      baseUrl,
                    ),
                    bannerImageUrl: widget.portfolio?.personalInfo
                        .getBannerImageUrl(baseUrl),
                    primaryWebsiteController: primaryWebsiteController,
                    secondaryWebsiteController: secondaryWebsiteController,
                    user: widget.user,
                    isEdit: true,
                    portfolio: widget.portfolio,
                    onLogoSelected: (file) {
                      setState(() {
                        pickedLogoImage = file;
                        previewLogoBytes = file.bytes;
                      });
                    },
                    onBannerSelected: (file) {
                      setState(() {
                        pickedBannerImage = file;
                        previewBannerBytes = file.bytes;
                      });
                    },
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
                    isEdit: true,
                    user: widget.user,
                    portfolio: widget.portfolio,
                    onLinksChanged: (updatedLinks) {
                      setState(() {
                        socialLinks =
                            updatedLinks
                                .map(
                                  (link) => SocialMedia(
                                    id: link.id,
                                    source: link.source,
                                    link: link.link,
                                  ),
                                )
                                .toList();
                      });
                    },
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
                    aboutHeadingController: headingcontroller,
                    aboutDescriptionController: descriptioncontroller,
                    user: widget.user,
                    isEdit: true,
                    portfolio: widget.portfolio,
                  ),
                ],
              ),
            ),

            Gap(CustomPadding.paddingXL.v),
            PaddingRow(
              children: [
                ExpandTileContainer(
                  title: 'Your Services',
                  children: [
                    TextFormContainer(
                      labelText: 'Heading/Topic',
                      controller: serviceHeadController,
                    ),
                    Gap(CustomPadding.paddingLarge.v),
                    Divider(endIndent: 20, indent: 20, thickness: 1),
                    Gap(CustomPadding.paddingLarge.v),
                    Row(
                      children: [
                        Gap(CustomPadding.paddingLarge.v),

                        Wrap(
                          spacing: CustomPadding.paddingLarge.v,
                          runSpacing: CustomPadding.paddingLarge.v,
                          children: [
                            ...theFetchedPortfolio?.services.map((service) {
                                  return ServiceCardWidget(
                                    portfolio: theFetchedPortfolio,
                                    baseUrl: baseUrl,
                                    service: service,
                                    isEditMode: true,
                                    onEdit: () async {
                                      logError(
                                        'Service image before edit: ${service.image?.key}',
                                      );
                                      setState(() {
                                        editingServiceId = service.id;
                                        _showAddServiceUI = true;

                                        serviceHeadingController.text =
                                            service.heading;
                                        serviceDescriptionController.text =
                                            service.description;
                                        if (service.image != null) {
                                          pickedServiceImage = ProductImage(
                                            key: service.image!.key,
                                            name: service.image!.name,
                                            size: service.image!.size,
                                            mimetype: service.image!.mimetype,
                                          );
                                          logError(
                                            'Picked image after set: ${pickedServiceImage?.key}',
                                          );
                                        } else {
                                          pickedServiceImage = null;
                                        }
                                      });
                                    },
                                    onDelete: () async {
                                      try {
                                        await PortfolioService.deleteService(
                                          serviceId: service.id!,
                                        );
                                        setState(() {
                                          theFetchedPortfolio?.services.remove(
                                            service,
                                          );
                                        });
                                        SnackbarHelper.showSuccess(
                                          context,
                                          'Service deleted successfully',
                                        );
                                      } catch (e) {
                                        SnackbarHelper.showError(
                                          context,
                                          'Failed to delete service',
                                        );
                                      }
                                    },
                                  );
                                }).toList() ??
                                [],

                            if ((theFetchedPortfolio?.services.length ?? 0) < 3)
                              SizedBox(
                                width: 350,
                                height: 400,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: CustomColors.lightGreen,
                                      size: 100,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editingServiceId = null;
                                        _showAddServiceUI = true;
                                        serviceHeadingController.clear();
                                        serviceDescriptionController.clear();
                                        pickedServiceImage = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    if (_showAddServiceUI) ...[
                      Divider(endIndent: 20, indent: 20, thickness: 1),
                      Gap(CustomPadding.paddingLarge.v),
                      Row(
                        children: [
                          Gap(CustomPadding.paddingLarge.v),
                          AddImageContainer(
                            baseUrlImage: baseUrlImage,
                            imageUrl:
                                pickedServiceImage?.key != null
                                    ? '$baseUrlImage/portfolios/portfolio-services/${pickedServiceImage!.key}'
                                    : null,
                            initialImage: pickedServiceImage,

                            onImageSelected: (ProductImage? image) {
                              setState(() {
                                pickedServiceImage = image;
                              });
                            },
                          ),
                        ],
                      ),
                      Gap(CustomPadding.paddingLarge.v),
                      TextFormContainer(
                        labelText: 'Heading/Topic',
                        controller: serviceHeadingController,
                      ),
                      TextFormContainer(
                        labelText: 'Description',
                        maxline: 7,
                        controller: serviceDescriptionController,
                      ),
                      Gap(CustomPadding.paddingLarge.v),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MiniLoadingButton(
                            icon: Icons.save,
                            text: 'Save',
                            onPressed: () async {
                              if (pickedServiceImage == null) {
                                SnackbarHelper.showInfo(
                                  context,
                                  'Please select an image',
                                );

                                return;
                              }

                              if (serviceHeadingController.text
                                      .trim()
                                      .isEmpty ||
                                  serviceDescriptionController.text
                                      .trim()
                                      .isEmpty) {
                                SnackbarHelper.showInfo(
                                  context,
                                  'Please fill in all fields',
                                );

                                return;
                              }

                              try {
                                if (editingServiceId != null) {
                                  final updatedPortfolio =
                                      await PortfolioService.editService(
                                        userId: widget.portfolio!.user.id,
                                        serviceId: editingServiceId!,
                                        editServiceData: {
                                          'heading':
                                              serviceHeadingController.text
                                                  .trim(),
                                          'description':
                                              serviceDescriptionController.text
                                                  .trim(),
                                          if (pickedServiceImage != null)
                                            'image':
                                                pickedServiceImage!.toJson(),
                                        },
                                      );

                                  setState(() {
                                    theFetchedPortfolio = updatedPortfolio;
                                    _showAddServiceUI = false;
                                    editingServiceId = null;
                                    serviceHeadingController.clear();
                                    serviceDescriptionController.clear();
                                    pickedServiceImage = null;
                                  });
                                  SnackbarHelper.showSuccess(
                                    context,
                                    'Service updated successfully',
                                  );
                                } else {
                                  await addServiceToPortfolio();
                                }
                              } catch (e) {
                                SnackbarHelper.showError(
                                  context,
                                  'Failed to save service: $e',
                                );
                              }
                            },

                            useGradient: true,
                            gradientColors: CustomColors.borderGradient.colors,
                          ),
                          Gap(CustomPadding.paddingLarge.v),
                          MiniGradientBorderButton(
                            text: 'Cancel',
                            icon: Icons.close,
                            onPressed: () {
                              setState(() {
                                editingServiceId = null;
                                _showAddServiceUI = false;
                                serviceHeadingController.clear();
                                serviceDescriptionController.clear();
                                pickedServiceImage = null;
                              });
                            },
                            gradient: LinearGradient(
                              colors: CustomColors.borderGradient.colors,
                            ),
                          ),
                          Gap(CustomPadding.paddingLarge.v),
                        ],
                      ),
                    ],
                    Gap(CustomPadding.paddingLarge.v),
                  ],
                ),
              ],
            ),
            Gap(CustomPadding.paddingXXL.v),
            Gap(CustomPadding.paddingXXL.v),

            Gap(CustomPadding.paddingXXL.v),
          ],
        ),
      ),
    );
  }
}
