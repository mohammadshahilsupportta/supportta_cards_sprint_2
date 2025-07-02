import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/services/pincode_helper.dart';

class LocationContainer extends StatefulWidget {
  final TextEditingController? buildingNamecontroller;
  final TextEditingController? namecontroller;
  final TextEditingController? areaController;
  final TextEditingController? pincodeController;
  final TextEditingController? districtController;
  final TextEditingController? stateController;

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
  });
  final User? user;

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  Timer? _debounce;

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
        PincodeHelper.fetchAndSetLocationData(
          pincode: text,
          districtController: widget.districtController!,
          stateController: widget.stateController!,
          logSuccess: logSuccess,
          logError: logError,
        );
      }
    });
  }

  @override
  void dispose() {
    widget.pincodeController?.removeListener(_onPincodeChanged);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      title: 'Location',
      children:
          widget.isEdit
              ? [
                Gap(CustomPadding.paddingLarge.v),
                TextFormContainer(
                  controller: widget.buildingNamecontroller,
                  // initialValue: portfolio!.addressInfo.buildingName,
                  labelText: 'Building Name',
                  user: widget.user,
                  maxline: 3,
                ),
                TextFormContainer(
                  controller: widget.areaController,
                  // initialValue: portfolio!.addressInfo.area,
                  labelText: 'Area',
                  user: widget.user,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormContainer(
                        // initialValue: portfolio!.addressInfo.pincode,
                        controller: widget.pincodeController,
                        labelText: 'Pin code',
                        user: widget.user,
                      ),
                    ),
                    Expanded(
                      child: TextFormContainer(
                        controller: widget.districtController,
                        // initialValue: portfolio!.addressInfo.district,
                        labelText: 'District',
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
                        labelText: 'State',
                        user: widget.user,
                      ),
                    ),
                    Expanded(
                      child: TextFormContainer(
                        readonly: true,
                        initialValue: 'India',
                        labelText: 'Country',
                        user: widget.user,
                      ),
                    ),
                  ],
                ),
              ]
              : [
                Gap(CustomPadding.paddingLarge.v),

                DetailRow(
                  label: 'Building Name',
                  value:
                      widget.portfolio?.addressInfo.buildingName ??
                      'Loading...',
                ),
                DetailRow(
                  label: 'Area',
                  value: widget.portfolio?.addressInfo.area ?? 'Loading...',
                ),
                DetailRow(
                  label: 'Pin code',
                  value: widget.portfolio?.addressInfo.pincode ?? 'Loading...',
                ),
                DetailRow(
                  label: 'District',
                  value: widget.portfolio?.addressInfo.district ?? 'Loading...',
                ),
                DetailRow(
                  label: 'State',
                  value: widget.portfolio?.addressInfo.state ?? 'Loading...',
                ),
                DetailRow(label: 'Country', value: 'India'),
              ],
    );
  }
}
