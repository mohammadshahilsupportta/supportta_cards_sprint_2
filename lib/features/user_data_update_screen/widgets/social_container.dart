import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taproot_admin/constants/constants.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/common_user_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/expand_tile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/social_media_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/gen/assets.gen.dart';
import 'package:taproot_admin/services/size_utils.dart';

import 'link_container.dart';

class SocialContainer extends StatefulWidget {
  final ValueChanged<List<SocialMedia>>? onLinksChanged;
  final PortfolioDataModel? portfolio;
  final bool isEdit;
  final User user;

  const SocialContainer({
    super.key,
    this.isEdit = false,
    required this.user,
    this.portfolio,
    this.onLinksChanged,
  });

  @override
  State<SocialContainer> createState() => _SocialContainerState();
}

class _SocialContainerState extends State<SocialContainer> {
  final List<String> platforms = [
    'facebook',
    'instagram',
    'x',
    'pinterest',
    'linkedin',
    'behance',
    'youtube',
    'threads',
  ];

  late List<SocialMedia> socialLinks;

  @override
  void initState() {
    super.initState();
    socialLinks = widget.portfolio?.socialMedia ?? [];

    for (final platform in platforms) {
      if (!socialLinks.any((e) => e.source == platform)) {
        socialLinks.add(SocialMedia(source: platform, link: '', id: ''));
      }
    }
  }

  void _updateLink(SocialMedia updatedLink) {
    setState(() {
      final index = socialLinks.indexWhere(
        (e) => e.source == updatedLink.source,
      );
      if (index != -1) {
        socialLinks[index] = updatedLink;
      } else {
        socialLinks.add(updatedLink);
      }
    });

    widget.onLinksChanged?.call(socialLinks);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEdit) {
      final visibleLinks = socialLinks.where((e) => e.link.isNotEmpty).toList();
      if (visibleLinks.isEmpty) return const SizedBox();
      return CommonUserContainer(
        height: SizeUtils.height * 0.25,
        title: 'Social Media',
        children: [
          Gap(CustomPadding.paddingXL.v),
          Center(
            child: Wrap(
              spacing: 5,
              runSpacing: 28,
              alignment: WrapAlignment.start,
              children:
                  visibleLinks
                      .map(
                        (item) => Container(
                          constraints: const BoxConstraints(maxWidth: 250),
                          child: SocialMediaContainer(
                            svg: _getSvgForPlatform(item.source),
                            name: _capitalize(item.source),
                            link: item.link,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      );
    }

    return ExpandTileContainer(
      title: 'Social Media',
      children:
          socialLinks
              .map(
                (item) => LinkContainer(
                  user: widget.user,
                  name: _capitalize(item.source),
                  source: item.source,
                  svg: _getSvgForPlatform(item.source),
                  initaialValue: item.link,
                  onChanged: (newLink) {
                    _updateLink(
                      SocialMedia(
                        source: item.source,
                        link: newLink,
                        id: item.id,
                      ),
                    );
                  },
                ),
              )
              .toList(),
    );
  }
}

String _getSvgForPlatform(String platform) {
  switch (platform.toLowerCase()) {
    case 'facebook':
      return Assets.svg.facebook;
    case 'instagram':
      return Assets.svg.instagram;
    case 'x':
      return Assets.svg.twitter;
    case 'pinterest':
      return Assets.svg.pinterest;
    case 'linkedin':
      return Assets.svg.linkdin;
    case 'behance':
      return Assets.svg.behance;
    case 'youtube':
      return Assets.svg.youtube;
    case 'threads':
      return Assets.svg.threads;

    default:
      return Assets.svg.link;
  }
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
