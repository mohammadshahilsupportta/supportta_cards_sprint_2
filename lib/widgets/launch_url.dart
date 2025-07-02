import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchWebsiteLink(String url, BuildContext context) async {
  if (url.isEmpty) return;

  final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
  }
}
