import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';

class ProfileContainer extends StatelessWidget {
  final TextEditingController? designationController;
  final TextEditingController? companyController;
  final TextEditingController? workEmailController;

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
  });

  final User user;
  String getDesignation() {
    final designation = portfolio?.workInfo?.designation;
    return (designation != null && designation.trim().isNotEmpty)
        ? designation
        : 'No Data Available';
  }

  String getCompanyName() {
    final companyName = portfolio?.workInfo?.companyName;
    return (companyName != null && companyName.trim().isNotEmpty)
        ? companyName
        : 'No Data Available';
  }

  String getWorkEmail() {
    final workEmail = portfolio?.workInfo?.workEmail;
    return (workEmail != null && workEmail.trim().isNotEmpty)
        ? workEmail
        : 'No Data Available';
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      height: SizeUtils.height * .57,

      title: 'Profile',
      children: [
        Gap(CustomPadding.paddingLarge.v),
        isEdit
            ? TextFormContainer(
              controller: designationController,
              // initialValue: portfolio!.workInfo. designation,
              labelText: 'Designation',
              user: user,
            )
            : DetailRow(
              label: 'Designation',
              value: getDesignation(),

              // value: portfolio?.workInfo?.designation ?? 'No Data Available',
            ),
        isEdit
            ? TextFormContainer(
              controller: companyController,
              // readonly: true,
              initialValue: portfolio!.workInfo?.companyName,
              labelText: 'Company Name',
              user: user,
            )
            : DetailRow(
              label: 'Company Name',
              value: getCompanyName(),
              // value: portfolio?.workInfo?.companyName ?? 'No Data Available',
            ),
        isEdit
            ? TextFormContainer(
              controller: workEmailController,
              user: user,
              initialValue: portfolio!.workInfo?.workEmail,
              labelText: 'Email',
            )
            : DetailRow(
              label: 'Email',
              value: getWorkEmail(),
              // value: portfolio?.workInfo?.workEmail ?? ' No Data Available',
            ),
      ],
    );
  }
}
