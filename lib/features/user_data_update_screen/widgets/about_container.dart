import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/constants/constants.dart';
import 'package:taproot_admin/extensions/font_extension.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/expand_tile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/services/size_utils.dart';

class AboutContainer extends StatelessWidget {
  final TextEditingController? aboutHeadingController;
  final TextEditingController? aboutDescriptionController;
  final PortfolioDataModel? portfolio;
  final bool isEdit;
  const AboutContainer({
    this.isEdit = false,
    super.key,
    required this.user,
    this.portfolio,
    this.aboutHeadingController,
    this.aboutDescriptionController,
  });
  final User user;

  @override
  Widget build(BuildContext context) {
    if (!isEdit &&
        (portfolio?.about.heading.isEmpty ?? true) &&
        (portfolio?.about.description.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }
    return isEdit
        ? ExpandTileContainer(
          title: 'About',
          children: [
            TextFormContainer(
              controller: aboutHeadingController,
              initialValue: 'About me',
              labelText: 'Heading/topic',
              user: user,
            ),
            TextFormContainer(
              controller: aboutDescriptionController,
              maxline: 8,
              initialValue: loremIpsum,
              labelText: 'Description',
              user: user,
            ),
          ],
        )
        : CommonUserContainer(
          title: 'About',
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CustomPadding.paddingLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(CustomPadding.paddingLarge),
                  Text(portfolio!.about.heading, style: context.inter50016),
                  Gap(CustomPadding.paddingLarge),
                  SizedBox(
                    height: SizeUtils.height * .3,
                    // height: 280,
                    child: SingleChildScrollView(
                      child: Text(portfolio!.about.description),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
  }
}
