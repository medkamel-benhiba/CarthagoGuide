import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final AppTheme theme;
  final bool showMore;
  final VoidCallback? onTap;

  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.theme,
    this.showMore = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showMore)
          GestureDetector(
            onTap: onTap,
            child: Text(
              'common.see_more'.tr(),
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
