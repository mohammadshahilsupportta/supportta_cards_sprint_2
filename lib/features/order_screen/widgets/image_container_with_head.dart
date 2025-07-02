import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/order_screen/data/order_details_model.dart'
    as order_details;
import 'package:taproot_admin/widgets/snakbar_helper.dart';

class ImageContainerWithHead extends StatefulWidget {
  const ImageContainerWithHead({
    super.key,
    required this.orderDetails,
    required this.heading,
    required this.imageKey,
    this.isOrderImage = false,
  });

  final order_details.OrderDetails? orderDetails;
  final String heading;
  final String imageKey;
  final bool isOrderImage;

  @override
  State<ImageContainerWithHead> createState() => _ImageContainerWithHeadState();
}

class _ImageContainerWithHeadState extends State<ImageContainerWithHead> {
  bool _isDownloading = false;

  Future<void> downloadImage(BuildContext context) async {
    final String imageUrl = '$baseUrlImage/portfolios/${widget.imageKey}';
    final String fileName =
        '${widget.heading.toLowerCase().replaceAll(' ', '_')}.jpg';

    try {
      setState(() {
        _isDownloading = true;
      });

      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: response.data,
        ext: 'jpg',
        mimeType: MimeType.jpeg,
      );

      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Image downloaded successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, 'Failed to download image: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.heading),
            // IconButton(
            //   onPressed: _isDownloading ? null : () => downloadImage(context),
            //   icon:
            //       _isDownloading
            //           ? const SizedBox(
            //             width: 24,
            //             height: 24,
            //             child: CircularProgressIndicator(strokeWidth: 2),
            //           )
            //           : const Icon(Icons.download),
            //   tooltip: 'Download Image',
            // ),
          ],
        ),
        Gap(CustomPadding.paddingLarge.v),
        Row(
          children: [
            Gap(CustomPadding.paddingXL.v),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      CustomPadding.paddingLarge.v,
                    ),
                  ),
                  width: 200,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      CustomPadding.paddingLarge.v,
                    ),
                    child: Image.network(
                      '$baseUrlImage/portfolios/${widget.imageKey}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: CustomColors.borderGradient,

                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(CustomPadding.paddingLarge.v),
                      ),
                    ),
                    width: 200,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Download',
                          style: context.inter50014.copyWith(
                            color: CustomColors.secondaryColor,
                          ),
                        ),
                        Gap(CustomPadding.padding.v),
                        IconButton(
                          constraints: const BoxConstraints(),
                          onPressed:
                              _isDownloading
                                  ? null
                                  : () => downloadImage(context),
                          icon:
                              _isDownloading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.download,
                                    color: CustomColors.secondaryColor,
                                  ),
                          tooltip: 'Download Image',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Gap(CustomPadding.paddingXL.v),
      ],
    );
  }
}

// class ImageContainerWithHead extends StatelessWidget {
//   const ImageContainerWithHead({
//     super.key,
//     required this.orderDetails,
//     required this.heading,
//     required this.imageKey,
//     this.isOrderImage = false,
//   });

//   final order_details.OrderDetails? orderDetails;
//   final String heading;
//   final String imageKey;
//   final bool isOrderImage;
//   Future<void> downloadImage(BuildContext context) async {
//     final String imageUrl = '$baseUrl/file?key=portfolios/$imageKey';
//     final String fileName = '${heading.toLowerCase().replaceAll(' ', '_')}.jpg';

//     try {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(child: CircularProgressIndicator());
//         },
//       );

//       // Download image
//       final response = await Dio().get(
//         imageUrl,
//         options: Options(responseType: ResponseType.bytes),
//       );

//       // Save file
//       await FileSaver.instance.saveFile(
//         name: fileName,
//         bytes: response.data,
//         ext: 'jpg',
//         mimeType: MimeType.jpeg,
//       );

//       // Hide loading indicator
//       if (context.mounted) {
//         Navigator.pop(context);
//         SnackbarHelper.showSuccess(context, 'Image downloaded successfully');
//       }
//     } catch (e) {
//       // Hide loading indicator
//       if (context.mounted) {
//         Navigator.pop(context);
//         SnackbarHelper.showError(context, 'Failed to download image: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final imagePath = isOrderImage ? 'orders' : 'portfolios';
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(heading),
//             IconButton(
//               onPressed: () => downloadImage(context),
//               icon: const Icon(Icons.download),
//               tooltip: 'Download Image',
//             ),
//           ],
//         ),
//         Gap(CustomPadding.paddingLarge.v),

//         Row(
//           children: [
//             Gap(CustomPadding.paddingXL.v),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(
//                   CustomPadding.paddingLarge.v,
//                 ),
//               ),
//               width: 200,
//               height: 150,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(
//                   CustomPadding.paddingLarge.v,
//                 ),
//                 child: Image.network('$baseUrl/file?key=portfolios/$imageKey'),
//               ),
//             ),
//           ],
//         ),
//         Gap(CustomPadding.paddingXL.v),
//       ],
//     );
//   }
// }
