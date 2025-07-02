import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';

class AddUserProfile extends StatelessWidget {
  final TextEditingController designataioncontroller;
  final TextEditingController companycontroller;
  final TextEditingController workemailcontroller;
  const AddUserProfile({
    super.key,
    required this.designataioncontroller,
    required this.companycontroller,
    required this.workemailcontroller,
  });

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      title: 'Profile',
      children: [
        Gap(CustomPadding.paddingLarge.v),

        TextFormContainer(
          controller: designataioncontroller,
          initialValue: '',
          labelText: 'Designation',
        ),
        TextFormContainer(
          controller: companycontroller,
          initialValue: '',
          labelText: 'Company Name',
        ),
        TextFormContainer(
          controller: workemailcontroller,
          initialValue: '',
          labelText: 'Email',
        ),
      ],
    );
  }
}
