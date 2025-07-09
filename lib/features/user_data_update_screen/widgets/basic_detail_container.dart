import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/detail_row_copy.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/textform_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/gen/assets.gen.dart';
import 'package:taproot_admin/services/download_qr.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicDetailContainer extends StatefulWidget {
  final TextEditingController? namecontroller;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? whatsappController;
  final TextEditingController? countryCodephoneController;
  final TextEditingController? countryCodewhatsappController;
  final PortfolioDataModel? portfolio;
  final bool autofocus;
  final dynamic user;
  final bool isEdit;
  final String? initialValue;

  const BasicDetailContainer({
    super.key,
    required this.user,
    this.autofocus = false,
    this.isEdit = false,
    this.portfolio,
    this.initialValue,
    this.namecontroller,
    this.emailController,
    this.phoneController,
    this.whatsappController,
    this.countryCodephoneController,
    this.countryCodewhatsappController,
  });

  @override
  State<BasicDetailContainer> createState() => _BasicDetailContainerState();
}

class _BasicDetailContainerState extends State<BasicDetailContainer> {
  final GlobalKey qrKey = GlobalKey();
  late User user;

  @override
  void initState() {
    user = widget.user;
    _initializePhoneFields();

    // TODO: implement initState
    super.initState();
  }

  String getIsoCodeFromDialCode(String dialCode) {
    switch (dialCode) {
      case '+91':
        return 'IN';
      case '+1':
        return 'US';
      case '+44':
        return 'GB';
      case '+971':
        return 'AE';
      case '+61':
        return 'AU';
      case '+93':
        return 'AF';
      // Add more mappings as needed
      default:
        return 'IN'; // fallback default
    }
  }

  Map<String, String> splitPhoneNumber(String fullNumber) {
    final regExp = RegExp(
      r'^\+(\d{1,2})(\d{6,})$',
    ); // ensures at least 6 digits in number
    final match = regExp.firstMatch(fullNumber);
    if (match != null && match.groupCount == 2) {
      return {'countryCode': '+${match.group(1)}', 'number': match.group(2)!};
    }
    return {'countryCode': '+91', 'number': fullNumber};
  }

  void _initializePhoneFields() {
    final phone = widget.portfolio?.personalInfo.phoneNumber ?? '';
    final whatsapp = widget.portfolio?.personalInfo.whatsappNumber ?? '';

    final phoneSplit = splitPhoneNumber(phone);
    final whatsappSplit = splitPhoneNumber(whatsapp);

    widget.countryCodephoneController?.text = phoneSplit['countryCode']!;
    widget.phoneController?.text = phoneSplit['number']!;

    widget.countryCodewhatsappController?.text = whatsappSplit['countryCode']!;
    widget.whatsappController?.text = whatsappSplit['number']!;
  }

  String getPhone() {
    final phone = widget.portfolio?.personalInfo.phoneNumber;
    return (phone != null && phone.trim().isNotEmpty)
        ? phone
        : 'No Data Available';
  }

  String getWhatsapp() {
    final whatsapp = widget.portfolio?.personalInfo.whatsappNumber;
    return (whatsapp != null && whatsapp.trim().isNotEmpty)
        ? whatsapp
        : 'No Data Available';
  }

  @override
  Widget build(BuildContext context) {
    return CommonUserContainer(
      height: SizeUtils.height * .55,

      title: 'Basic Details',
      children: [
        Gap(CustomPadding.paddingLarge.v),
        widget.isEdit
            ? TextFormContainer(
              autofocus: widget.autofocus,
              controller: widget.namecontroller,
              // controller: widget.namecontroller,
              user: widget.user,
              // initialValue:widget.initialValue,
              labelText: 'Full Name',
            )
            : DetailRow(
              label: 'Full Name',
              value: widget.portfolio?.personalInfo.name ?? 'No Data Available',
            ),

        widget.isEdit
            ? TextFormContainer(
              controller: widget.emailController,
              user: widget.user,
              labelText: 'Email',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }

                if (RegExp(r'^\d').hasMatch(value)) {
                  return 'Email should not start with a number';
                }

                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Enter a valid email';
                }

                return null;
              },
            )
            : DetailRow(
              label: 'Email',
              value: widget.portfolio?.personalInfo.email ?? '',
            ),
        widget.isEdit
            ? TextFormContainer(
              isNumberField: true,
              controller: widget.phoneController,
              labelText: 'Phone Number',
              user: widget.user,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              countryCodeWidget: CountryCodePicker(
                initialSelection: getIsoCodeFromDialCode(
                  widget.countryCodephoneController?.text ?? '+91',
                ),
                onChanged: (value) {
                  widget.countryCodephoneController?.text = value.dialCode!;
                },
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            )
            // TextFormContainer(
            //   inputFormatters: [
            //     LengthLimitingTextInputFormatter(13),
            //     FilteringTextInputFormatter.allow(RegExp(r'^[0-9+]*$')),
            //     // FilteringTextInputFormatter.digitsOnly,
            //   ],
            //   user: widget.user,
            //   controller: widget.phoneController,
            //   labelText: 'Phone Number',
            // )
            : DetailRow(
              label: 'Phone Number',
              value: getPhone(),
              // value:
              //     widget.portfolio?.personalInfo.phoneNumber ??
              //     'No Data Available',
            ),
        widget.isEdit
            ? TextFormContainer(
              isNumberField: true,
              controller: widget.whatsappController,
              labelText: 'WhatsApp Number',
              user: widget.user,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              countryCodeWidget: CountryCodePicker(
                initialSelection: getIsoCodeFromDialCode(
                  widget.countryCodewhatsappController?.text ?? '+91',
                ),
                onChanged: (value) {
                  widget.countryCodewhatsappController?.text = value.dialCode!;
                },
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            )
            //  TextFormContainer(
            //   inputFormatters: [
            //     LengthLimitingTextInputFormatter(13),
            //     FilteringTextInputFormatter.allow(RegExp(r'^\+91[0-9]*$')),
            //   ],
            //   user: widget.user,
            //   controller: widget.whatsappController,
            //   labelText: 'WhatsApp Number',
            // )
            : DetailRow(
              label: 'WhatsApp Number',
              value: getWhatsapp(),
              // value:
              //     widget.portfolio?.personalInfo.whatsappNumber ??
              //     'No Data Available',
            ),
        widget.isEdit
            ? SizedBox()
            : DetailRowCopy(
              label: 'Portfolio Link',
              value:
                  'https://app.supporttacards.com/portfolio-view/\n${user.id}',
              icon: Icons.copy,
              onTap: () async {
                final Uri url = Uri.parse(
                  'https://app.supporttacards.com/portfolio-view/${user.id}',
                );
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
        Row(
          children: [
            Gap(CustomPadding.paddingLarge),
            Text(
              'QR Code',
              style: context.inter50014.copyWith(fontSize: 14.fSize),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context, // Must be valid Material context
                  builder:
                      (context) => AlertDialog(
                        title: Text('Download'),
                        content: SizedBox(
                          width: 300,
                          child: RepaintBoundary(
                            key: qrKey,
                            child: PrettyQrView.data(
                              data:
                                  'https://app.supporttacards.com/portfolio-view/${user.id}',
                              decoration: PrettyQrDecoration(
                                image: PrettyQrDecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage(Assets.png.supportta4.path),
                                ),
                                quietZone: PrettyQrQuietZone.zero,
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final username =
                                  widget.portfolio?.personalInfo.name ?? 'user';
                              await downloadQrCode(qrKey, context, username);
                            },
                            child: Text('Download'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Download',
                  style: context.inter50014.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: CustomColors.buttonColor1,
                    fontSize: 14.fSize,
                    color: CustomColors.buttonColor1,
                  ),
                ),
              ),
            ),

            Gap(CustomPadding.paddingLarge),
          ],
        ),
      ],
    );
  }
}
