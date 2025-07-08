// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';

class AddBasicDetailContainer extends StatefulWidget {
  final TextEditingController namecontroller;
  final TextEditingController emailcontroller;
  final TextEditingController phonecontroller;
  final TextEditingController whatsappcontroller;
  final TextEditingController countryCodephoneController;
  final TextEditingController countryCodewhatsappController;

  const AddBasicDetailContainer({
    super.key,
    required this.namecontroller,
    required this.emailcontroller,
    required this.phonecontroller,
    required this.whatsappcontroller,
    required this.countryCodephoneController,
    required this.countryCodewhatsappController,
  });

  @override
  State<AddBasicDetailContainer> createState() =>
      _AddBasicDetailContainerState();
}

class _AddBasicDetailContainerState extends State<AddBasicDetailContainer> {
  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      height: SizeUtils.height * .55,
      title: 'Basic Details',
      children: [
        Gap(CustomPadding.paddingLarge.v),

        TextFormContainer(
          controller: widget.namecontroller,
          initialValue: '',
          labelText: 'Full Name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full Name is required';
            }
            return null;
          },
        ),
        TextFormContainer(
          controller: widget.emailcontroller,
          initialValue: '',
          labelText: 'Email',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }

            if (RegExp(r'^\d').hasMatch(value)) {
              return 'Email should not start with a number';
            }

            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Enter a valid email';
            }

            return null;
          },
        ),
        TextFormContainer(
          isNumberField: true,
          countryCodeWidget: CountryCodePicker(
            initialSelection: 'IN',
            onChanged: (value) {
              setState(() {
                widget.countryCodephoneController.text = value.dialCode!;
                // countryCode=value.dialCode!;
              });
              logInfo(value);
            },
            comparator: (a, b) => b.name!.compareTo(a.name!),
          ),
          initialValue: '',
          controller:
              widget
                  .phonecontroller, // Using the controller to handle the phone number input
          labelText: 'Phone Number',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            // if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
            //   return 'Enter a valid 10-digit phone number';
            // }
            return null;
          },
          inputFormatters: [
            // LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),

        TextFormContainer(
          isNumberField: true,
          countryCodeWidget: CountryCodePicker(
            initialSelection: 'IN',
            onChanged: (value) {
              setState(() {
                widget.countryCodewhatsappController.text = value.dialCode!;
                // countryCode=value.dialCode!;
              });
              logInfo(value);
            },
            comparator: (a, b) => b.name!.compareTo(a.name!),
          ),
          controller: widget.whatsappcontroller,
          initialValue: '',
          labelText: 'WhatsApp Number',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            // if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
            //   return 'Enter a valid 10-digit phone number';
            // }
            return null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }
}
