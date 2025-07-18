import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';

class ProfileContainer extends StatefulWidget {
  final TextEditingController? designationController;
  final TextEditingController? companyController;
  final TextEditingController? workEmailController;
  final TextEditingController? gstinController;

  final PortfolioDataModel? portfolio;

  final bool isEdit;
  const ProfileContainer({
    super.key,
    required this.user,
    this.isEdit = false,
    this.portfolio,
    this.companyController,
    this.workEmailController,
    this.designationController,
    this.gstinController,
  });

  final User user;

  @override
  State<ProfileContainer> createState() => ProfileContainerState();
}

class ProfileContainerState extends State<ProfileContainer> {
  String? gstinErrorText;
  bool validateGstinField() {
    final gstin = widget.gstinController?.text.trim() ?? '';

    if (gstin.isEmpty) {
      setState(() {
        gstinErrorText = null;
      });
      return true;
    }

    final regex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
    );
    final isValid = regex.hasMatch(gstin);

    setState(() {
      gstinErrorText = isValid ? null : 'Invalid GSTIN format';
    });

    return isValid;
  }

  String getDesignation() {
    final designation = widget.portfolio?.workInfo?.designation;
    return (designation != null && designation.trim().isNotEmpty)
        ? designation
        : 'No Data Available';
  }

  String getCompanyName() {
    final companyName = widget.portfolio?.workInfo?.companyName;
    return (companyName != null && companyName.trim().isNotEmpty)
        ? companyName
        : 'No Data Available';
  }

  String getWorkEmail() {
    final workEmail = widget.portfolio?.workInfo?.workEmail;
    return (workEmail != null && workEmail.trim().isNotEmpty)
        ? workEmail
        : 'No Data Available';
  }

  String getGstin() {
    final gstin = widget.portfolio?.workInfo?.gstin;
    return (gstin != null && gstin.trim().isNotEmpty)
        ? gstin
        : 'No Data Available';
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      height: widget.isEdit ? SizeUtils.height * .65 : SizeUtils.height * .5,

      title: 'Profile',
      children: [
        Gap(CustomPadding.paddingLarge.v),
        widget.isEdit
            ? TextFormContainer(
              controller: widget.designationController,
              // initialValue: portfolio!.workInfo. designation,
              labelText: 'Designation',
              user: widget.user,
            )
            : DetailRow(
              label: 'Designation',
              value: getDesignation(),

              // value: portfolio?.workInfo?.designation ?? 'No Data Available',
            ),
        widget.isEdit
            ? TextFormContainer(
              controller: widget.companyController,
              // readonly: true,
              initialValue: widget.portfolio!.workInfo?.companyName,
              labelText: 'Company Name',
              user: widget.user,
            )
            : DetailRow(
              label: 'Company Name',
              value: getCompanyName(),
              // value: portfolio?.workInfo?.companyName ?? 'No Data Available',
            ),
        widget.isEdit
            ? TextFormContainer(
              controller: widget.workEmailController,
              user: widget.user,
              initialValue: widget.portfolio!.workInfo?.workEmail,
              labelText: 'Email',
            )
            : DetailRow(
              label: 'Email',
              value: getWorkEmail(),
              // value: portfolio?.workInfo?.workEmail ?? ' No Data Available',
            ),
        widget.isEdit
            ? TextFormContainer(
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                // UpperCaseTextFormatter(),
              ],
              onChanged: (value) {
                final upperValue = value.toUpperCase();

                if (value != upperValue) {
                  final cursorPos = upperValue.length;
                  widget.gstinController?.value = TextEditingValue(
                    text: upperValue,
                    selection: TextSelection.collapsed(offset: cursorPos),
                  );
                }

                setState(() {
                  gstinErrorText = null;
                });
              },

              controller: widget.gstinController,
              user: widget.user,
              initialValue: widget.portfolio!.workInfo?.gstin,
              labelText: 'GST IN',
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                if (!RegExp(
                  r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                ).hasMatch(value.trim().toUpperCase())) {
                  return 'Invalid GSTIN format';
                }
                return null;
              },
            )
            : DetailRow(
              label: 'GST IN',
              value: getGstin(),
              // value: portfolio?.workInfo?.workEmail ?? ' No Data Available',
            ),
      ],
    );
  }
}
