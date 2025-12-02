import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carthagoguide/constants/theme.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final AppTheme theme;

  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.text,
          ),
        ),
        Text(
          "Voir Tout",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}