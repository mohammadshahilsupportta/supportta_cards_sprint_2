import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/services/pincode_helper.dart';
import 'package:taproot_admin/widgets/launch_url.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationContainer extends StatefulWidget {
  final TextEditingController? buildingNamecontroller;
  final TextEditingController? namecontroller;
  final TextEditingController? areaController;
  final TextEditingController? pincodeController;
  final TextEditingController? districtController;
  final TextEditingController? stateController;
  final TextEditingController? countryController;
  final TextEditingController? mapUrlController;

  final PortfolioDataModel? portfolio;
  final bool isEdit;
  const LocationContainer({
    super.key,
    this.user,
    this.isEdit = false,
    this.portfolio,
    this.buildingNamecontroller,
    this.namecontroller,
    this.areaController,
    this.pincodeController,
    this.districtController,
    this.stateController,
    this.countryController,
    this.mapUrlController,
  });
  final User? user;

  @override
  State<LocationContainer> createState() => LocationContainerState();
}

class LocationContainerState extends State<LocationContainer> {
  Timer? _debounce;
  String? mapUrlErrorText;
  String selectedCountry = 'India';

  @override
  void initState() {
    if (widget.pincodeController != null) {
      widget.pincodeController!.addListener(_onPincodeChanged);
    }
    // TODO: implement initState
    super.initState();
  }

  void _onPincodeChanged() {
    final text = widget.pincodeController!.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.length == 6 && RegExp(r'^[1-9][0-9]{5}$').hasMatch(text)) {
        selectedCountry == 'India'
            ? PincodeHelper.fetchAndSetLocationData(
              pincode: text,
              districtController: widget.districtController!,
              stateController: widget.stateController!,
              countryController: widget.countryController!,
              logSuccess: logSuccess,
              logError: logError,
            )
            : null;
      }
    });
  }

  @override
  void dispose() {
    widget.pincodeController?.removeListener(_onPincodeChanged);
    _debounce?.cancel();
    super.dispose();
  }

  // String? validateGoogleMapsUrl(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return null;
  //   }

  //   final googleMapsRegex = RegExp(
  //     r'^https:\/\/((www\.)?google\.com\/maps|maps\.app\.goo\.gl)',
  //   );

  //   if (!googleMapsRegex.hasMatch(value)) {
  //     return 'Location must be a valid Google Maps URL';
  //   }

  //   return null; // means valid
  // }
  void validateMapUrlField() {
    final value = widget.mapUrlController?.text ?? '';
    final isValid = _isMapUrlValid(value.trim());

    setState(() {
      mapUrlErrorText = isValid ? null : 'Please enter a valid Google Maps URL';
    });
  }

  bool _isMapUrlValid(String value) {
    if (value.isEmpty) return true;
    final regex = RegExp(
      r'^https:\/\/((www\.)?google\.com\/maps|maps\.app\.goo\.gl)',
    );
    return regex.hasMatch(value);
  }

  bool get hasMapUrlError => mapUrlErrorText != null;
  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      height: widget.isEdit ? SizeUtils.height * .65 : SizeUtils.height * .5,

      title: 'Location',
      children:
          widget.isEdit
              ? [
                Gap(CustomPadding.paddingLarge.v),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.paddingLarge.v,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Country',
                        labelStyle: TextStyle(
                          color: CustomColors.textColorDarkGrey,
                        ),
                      ),

                      value: selectedCountry,
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value!;
                        });
                        logWarning('Selected value: $value');
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'India',
                          child: Text('India'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Others',
                          child: Text('Others'),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(CustomPadding.paddingLarge.v),

                TextFormContainer(
                  controller: widget.buildingNamecontroller,
                  // initialValue: portfolio!.addressInfo.buildingName,
                  labelText: 'Address Line 1',
                  user: widget.user,
                  maxline: 3,
                ),
                TextFormContainer(
                  controller: widget.areaController,
                  // initialValue: portfolio!.addressInfo.area,
                  labelText: 'Address Line 2',
                  user: widget.user,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormContainer(
                        // initialValue: portfolio!.addressInfo.pincode,
                        controller: widget.pincodeController,
                        labelText:
                            selectedCountry == 'India'
                                ? 'Pin code'
                                : 'Pincode (Optional)',
                        user: widget.user,
                      ),
                    ),
                    Expanded(
                      child: TextFormContainer(
                        controller: widget.districtController,
                        // initialValue: portfolio!.addressInfo.district,
                        labelText:
                            selectedCountry == 'India'
                                ? 'District'
                                : 'District/City (Optional)',
                        user: widget.user,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormContainer(
                        controller: widget.stateController,
                        // initialValue: portfolio!.addressInfo.state,
                        labelText:
                            selectedCountry == 'India'
                                ? 'State'
                                : 'State/Province (Optional)',
                        user: widget.user,
                      ),
                    ),
                    Expanded(
                      child: TextFormContainer(
                        controller: widget.countryController,
                        // readonly: true,
                        // initialValue: 'India',
                        labelText: 'Country',
                        user: widget.user,
                      ),
                    ),
                  ],
                ),
                TextFormContainer(
                  labelText: 'Map Url',
                  controller: widget.mapUrlController,
                  initialValue: '',
                  user: widget.user,
                  onChanged: (value) {
                    setState(() {
                      mapUrlErrorText =
                          _isMapUrlValid(value.trim())
                              ? null
                              : 'Please enter a valid Google Maps URL';
                    });
                  },
                  // validator: validateGoogleMapsUrl,
                ),
              ]
              : [
                Gap(CustomPadding.paddingLarge.v),

                DetailRow(
                  label: 'Address Line 1',
                  value:
                      (widget.portfolio?.addressInfo?.buildingName != null &&
                              widget
                                  .portfolio!
                                  .addressInfo!
                                  .buildingName!
                                  .isNotEmpty)
                          ? widget.portfolio!.addressInfo!.buildingName!
                          : 'No Data Available',
                  // value:
                  //     widget.portfolio?.addressInfo?.buildingName ??
                  //     'No Data Available',
                ),
                DetailRow(
                  label: 'Address Line 2',
                  value:
                      (widget.portfolio?.addressInfo?.area != null &&
                              widget.portfolio!.addressInfo!.area!.isNotEmpty)
                          ? widget.portfolio!.addressInfo!.area!
                          : 'No Data Available',

                  // value:
                  //     widget.portfolio?.addressInfo?.area ??
                  //     'No Data Available',
                ),
                DetailRow(
                  label: 'Pin code',
                  value:
                      (widget.portfolio?.addressInfo?.pincode != null &&
                              widget
                                  .portfolio!
                                  .addressInfo!
                                  .pincode!
                                  .isNotEmpty)
                          ? widget.portfolio!.addressInfo!.pincode!
                          : 'No Data Available',
                  // value:
                  //     widget.portfolio?.addressInfo?.pincode ??
                  //     'No Data Available',
                ),
                DetailRow(
                  label: 'District',
                  value:
                      (widget.portfolio?.addressInfo?.district != null &&
                              widget
                                  .portfolio!
                                  .addressInfo!
                                  .district!
                                  .isNotEmpty)
                          ? widget.portfolio!.addressInfo!.district!
                          : 'No Data Available',
                  // value:
                  //     widget.portfolio?.addressInfo?.district ??
                  //     'No Data Available',
                ),
                DetailRow(
                  label: 'State',
                  value:
                      (widget.portfolio?.addressInfo?.country != null &&
                              widget.portfolio!.addressInfo!.state!.isNotEmpty)
                          ? widget.portfolio!.addressInfo!.state!
                          : 'No Data Available',
                  // value:
                  //     widget.portfolio?.addressInfo?.state ??
                  //     'No Data Available',
                ),
                DetailRow(
                  label: 'Country',
                  value:
                      (widget.portfolio?.addressInfo?.country != null &&
                              widget
                                  .portfolio!
                                  .addressInfo!
                                  .country!
                                  .isNotEmpty)
                          ? widget.portfolio!.addressInfo!.country!
                          : 'No Data Available',
                ),
                // DetailRow(
                //   label: 'Map',
                //   value:
                //       widget.portfolio?.addressInfo?.mapUrl ??
                //       'No Data Available',
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: CustomPadding.paddingLarge.v,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Map Url',
                        style: context.inter50014.copyWith(fontSize: 14.fSize),
                      ),
                      Spacer(),
                      widget.portfolio?.addressInfo?.mapUrl != null &&
                              widget.portfolio!.addressInfo!.mapUrl!.isNotEmpty
                          ? GestureDetector(
                            onTap:
                                () => launchWebsiteLink(
                                  widget.portfolio!.addressInfo!.mapUrl!,
                                  context,
                                ),
                            child: Text(
                              widget.portfolio!.addressInfo!.mapUrl!,
                              style: context.inter50014.copyWith(
                                fontSize: 14.fSize,
                                color: CustomColors.green,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                          : Text(
                            'No Map URL Available',
                            style: context.inter50014.copyWith(
                              fontSize: 14.fSize,
                              color: CustomColors.textColorGrey,
                            ),
                          ),
                      IconButton(
                        onPressed: () async {
                          final mapUrl = widget.portfolio?.addressInfo?.mapUrl;
                          if (mapUrl != null && mapUrl.isNotEmpty) {
                            final Uri url = Uri.parse(mapUrl);
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          } else {
                            logError('Map URL is not available');
                          }
                        },
                        icon: Icon(Icons.location_pin, color: CustomColors.red),
                      ),
                      // Icon(Icons.location_pin, color: CustomColors.red),
                    ],
                  ),
                ),
              ],
    );
  }
}

// style: context.inter50014.copyWith(fontSize: 14.fSize),
