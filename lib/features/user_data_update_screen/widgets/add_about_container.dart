import 'package:flutter/material.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/expand_tile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';

class AddAboutContainer extends StatelessWidget {
  final TextEditingController headingcontroller;
  final TextEditingController descriptioncontroller;
  const AddAboutContainer({
    super.key,
    required this.user,
    required this.headingcontroller,
    required this.descriptioncontroller,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return ExpandTileContainer(
      title: 'About',
      children: [
        TextFormContainer(
          controller: headingcontroller,
          initialValue: '',
          labelText: 'Heading/topic',
          user: user,
        ),
        TextFormContainer(
          controller: descriptioncontroller,
          maxline: 20,

          initialValue: '',
          labelText: 'Description',
          user: user,
        ),
      ],
    );
  }
}
