import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(BuildContext context, double? lat, double? lng) async {
  if (lat == null || lng == null) return;

  final Uri url = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$lng,$lat',
  );

  await launchUrl(url, mode: LaunchMode.externalApplication);
}
