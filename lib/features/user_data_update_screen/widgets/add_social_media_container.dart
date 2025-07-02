import 'package:flutter/material.dart';
import 'package:taproot_admin/features/user_data_update_screen/data/portfolio_model.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/expand_tile_container.dart';
import 'package:taproot_admin/features/user_data_update_screen/widgets/link_container.dart';
import 'package:taproot_admin/features/users_screen/data/user_data_model.dart';
import 'package:taproot_admin/gen/assets.gen.dart';

class AddSocialMediaContainer extends StatefulWidget {
  const AddSocialMediaContainer({
    super.key,
    required this.user,
    required this.onLinksChanged,
  });

  final User user;
  final ValueChanged<List<SocialMedia>> onLinksChanged;

  @override
  State<AddSocialMediaContainer> createState() =>
      _AddSocialMediaContainerState();
}

class _AddSocialMediaContainerState extends State<AddSocialMediaContainer> {
  final Map<String, String> socialLinks = {};
  @override
  Widget build(BuildContext context) {
    return ExpandTileContainer(
      title: 'Social Media',
      children: [
        LinkContainer(
          source: socialLinks['Facebook'] ?? '',
          user: widget.user,
          name: 'Facebook',
          svg: Assets.svg.facebook,
          onChanged: (link) {
            socialLinks['Facebook'] = link;
            widget.onLinksChanged(
              _convertToSocialMediaList(socialLinks),
            ); // Convert map to list and pass it back
          },
        ),
        LinkContainer(
          source: socialLinks['Instagram'] ?? '',
          user: widget.user,
          name: 'Instagram',
          svg: Assets.svg.instagram,
          onChanged: (link) {
            socialLinks['Instagram'] = link;
            widget.onLinksChanged(_convertToSocialMediaList(socialLinks));
          },
        ),
        LinkContainer(
          source: socialLinks['Twitter'] ?? '',
          user: widget.user,
          name: 'Twitter',
          svg: Assets.svg.twitter,
          onChanged: (link) {
            socialLinks['Twitter'] = link;
            widget.onLinksChanged(_convertToSocialMediaList(socialLinks));
          },
        ),
        LinkContainer(
          source: socialLinks['Pinterest'] ?? '',
          user: widget.user,
          name: 'Pinterest',
          onChanged: (link) {
            socialLinks['Pinterest'] = link;
            widget.onLinksChanged(_convertToSocialMediaList(socialLinks));
          },
          svg: Assets.svg.pinterest,
        ),
        LinkContainer(
          source: socialLinks['LinkedIn'] ?? '',
          user: widget.user,
          name: 'LinkedIn',
          svg: Assets.svg.linkdin,
          onChanged: (link) {
            socialLinks['LinkedIn'] = link;
            widget.onLinksChanged(_convertToSocialMediaList(socialLinks));
          },
        ),
        LinkContainer(
          source: socialLinks['Behance'] ?? '',
          user: widget.user,
          name: 'Behance',
          svg: Assets.svg.behance,
          onChanged: (link) {
            socialLinks['Behance'] = link;
            widget.onLinksChanged(_convertToSocialMediaList(socialLinks));
          },
        ),
        LinkContainer(
          source: socialLinks['Github'] ?? '',
          user: widget.user,
          name: 'Youtube',
          svg: Assets.svg.youtube,
          onChanged: (link) {
            socialLinks['Youtube'] = link;
            widget.onLinksChanged(_convertToSocialMediaList(socialLinks));
          },
        ),
      ],
    );
  }

  List<SocialMedia> _convertToSocialMediaList(Map<String, String> socialLinks) {
    return socialLinks.entries
        .map(
          (entry) => SocialMedia(id: '', source: entry.key, link: entry.value),
        )
        .toList();
  }
}
