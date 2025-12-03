import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carthagoguide/constants/theme.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final AppTheme theme;
  final bool? showMore;


  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.theme,
    this.showMore
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
        if(showMore == true)
        Text(
          "Voir Tout",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}