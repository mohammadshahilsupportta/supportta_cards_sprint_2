import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/exporter/exporter.dart';
import 'package:taproot_admin/gen/assets.gen.dart';
import 'package:taproot_admin/widgets/launch_url.dart';

class SocialMediaContainer extends StatelessWidget {
  final String svg;
  final String name;
  final String? link;
  const SocialMediaContainer({
    super.key,
    required this.svg,
    required this.name,
    this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(svg),
        Gap(CustomPadding.padding.v),
        Text(
          name,
          style: context.inter60016.copyWith(
            fontSize: 16.fSize,
            color: CustomColors.textColorDarkGrey,
          ),
        ),
        Gap(CustomPadding.padding.v),
        if (link != null && link!.isNotEmpty)
          GestureDetector(
            onTap: () => launchWebsiteLink(link!, context),
            child: SvgPicture.asset(Assets.svg.link),
          ),
      ],
    );
  }
}
