import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_service.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';

class AddUserLocation extends StatefulWidget {
  final TextEditingController buildingcontroller;
  final TextEditingController areacontroller;
  final TextEditingController pincodecontroller;
  final TextEditingController districtcontroller;
  final TextEditingController statecontroller;
  final TextEditingController countrycontroller;
  const AddUserLocation({
    super.key,
    this.user,
    required this.buildingcontroller,
    required this.areacontroller,
    required this.pincodecontroller,
    required this.districtcontroller,
    required this.statecontroller,
    required this.countrycontroller,
  });

  final User? user;

  @override
  State<AddUserLocation> createState() => _AddUserLocationState();
}

class _AddUserLocationState extends State<AddUserLocation> {
  Timer? _debounce;

  @override
  void initState() {
    widget.pincodecontroller.addListener(_onPincodeChanged);

    // TODO: implement initState
    super.initState();
  }

  void _onPincodeChanged() {
    final text = widget.pincodecontroller.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.length == 6 && RegExp(r'^[1-9][0-9]{5}$').hasMatch(text)) {
        getPincodeData(text);
      }
    });
  }

  Future<void> getPincodeData(String pincode) async {
    try {
      final response = await PortfolioService.getDatafromPincode(
        pinCode: int.parse(pincode),
      );

      // Accessing the first PostOffice object in the list
      final postOffice = response['PostOffice']?.first;

      if (postOffice != null) {
        final district = postOffice['District'];
        final state = postOffice['State'];
        final country = postOffice['Country'];

        logSuccess(response);

        setState(() {
          widget.districtcontroller.text = district ?? '';
          widget.statecontroller.text = state ?? '';
          widget.countrycontroller.text = country ?? '';
        });
      } else {
        logError('PostOffice data is empty.');
      }
    } catch (e) {
      logError("Failed to fetch pincode data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      title: 'Location',
      children: [
        Gap(CustomPadding.paddingLarge.v),
        TextFormContainer(
          controller: widget.buildingcontroller,
          initialValue: '',
          labelText: 'Building Name',
          user: widget.user,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Building Name is required';
            }
            return null;
          },
        ),
        TextFormContainer(
          controller: widget.areacontroller,
          initialValue: '',
          labelText: 'Area',
          user: widget.user,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Area is required';
            }
            return null;
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextFormContainer(
                controller: widget.pincodecontroller,
                initialValue: '',
                labelText: 'Pin code',
                user: widget.user,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pincode is required';
                  }
                  if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(value.trim())) {
                    return 'Enter a valid 6-digit pincode';
                  }
                  return null;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Expanded(
              child: TextFormContainer(
                controller: widget.districtcontroller,
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
                controller: widget.statecontroller,

                labelText: 'State',
                user: widget.user,
              ),
            ),
            Expanded(
              child: TextFormContainer(
                controller: widget.countrycontroller,
                readonly: true,
                // initialValue: 'India',
                labelText: 'Country',
                user: widget.user,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
