import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/add_image_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/service_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/widgets/mini_loading_button.dart';

class ServiceEdit extends StatefulWidget {
  final TextEditingController? serviceHeadingController;
  final TextEditingController? serviceDescriptionController;
  final VoidCallback saveButton;
  final Service service;
  final ServiceContainer widget;
  final PlatformFile? pickedImage;
  final Uint8List? previewBytes;
  final Function(PlatformFile)? onImagePicked;

  const ServiceEdit({
    super.key,
    required this.widget,
    this.serviceHeadingController,
    this.serviceDescriptionController,
    required this.service,
    required this.saveButton,
    this.pickedImage,
    this.previewBytes,
    this.onImagePicked,
  });

  @override
  State<ServiceEdit> createState() => _ServiceEditState();
}

class _ServiceEditState extends State<ServiceEdit> {
  void pickServiceImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        widget.onImagePicked?.call(result.files.first);
      }
    } catch (e) {
      logError('Error picking service image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting service image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(CustomPadding.paddingLarge),
      decoration: BoxDecoration(
        color: CustomColors.secondaryColor,
        borderRadius: BorderRadius.circular(CustomPadding.padding),
        border: Border.all(color: CustomColors.textColorLightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddImageContainer(
            previewBytes: widget.previewBytes,
            onTapEdit: pickServiceImage,
            imageUrl:
                widget.service.image?.key != null
                    ? '$baseUrl/file?key=portfolios/portfolio_services/${widget.service.image!.key}'
                    : null,
          ),
          Gap(CustomPadding.paddingLarge.v),
          TextFormContainer(
            labelText: 'Heading/topic',
            user: widget.widget.user,
            controller: widget.serviceHeadingController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a heading';
              }
              return null;
            },
          ),
          Gap(CustomPadding.paddingLarge.v),
          TextFormContainer(
            maxline: 4,
            labelText: 'Description',
            user: widget.widget.user,
            controller: widget.serviceDescriptionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          Gap(CustomPadding.paddingLarge.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MiniLoadingButton(
                icon: LucideIcons.save,
                text: 'Save',
                onPressed: widget.saveButton,
                useGradient: true,
                gradientColors: [Color(0xff005624), Color(0xff27AE60)],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:taproot_admin/exporter/exporter.dart';
// import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
// import 'package:taproot_admin/features/user_data_update_screen/widgets/add_image_container.dart';
// import 'package:taproot_admin/features/user_data_update_screen/widgets/service_container.dart';
// import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
// import 'package:taproot_admin/widgets/mini_loading_button.dart';

// class ServiceEdit extends StatelessWidget {
//   final TextEditingController? serviceHeadingController;
//   final TextEditingController? serviceDescriptionController;
//   final VoidCallback saveButton;
//   final Service service;

//   const ServiceEdit({
//     super.key,
//     required this.widget,
//     this.serviceHeadingController,
//     this.serviceDescriptionController,
//     required this.service,
//     required this.saveButton,
//   });

//   final ServiceContainer widget;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AddImageContainer(),
//         Gap(CustomPadding.paddingLarge.v),
//         TextFormContainer(
//           labelText: 'Heading/topic',
//           user: widget.user,
//           controller: serviceHeadingController,
//         ),
//         Gap(CustomPadding.paddingLarge.v),
//         TextFormContainer(
//           maxline: 4,
//           labelText: 'Description',
//           user: widget.user,
//           controller: serviceDescriptionController,
//         ),
//         Gap(CustomPadding.paddingLarge.v),
//         Padding(
//           padding: EdgeInsets.only(right: CustomPadding.paddingLarge),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               MiniLoadingButton(
//                 icon: LucideIcons.save,
//                 text: 'Save',
//                 onPressed: saveButton,
//                 useGradient: true,
//                 gradientColors: [Color(0xff005624), Color(0xff27AE60)],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
