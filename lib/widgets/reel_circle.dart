import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class ReelCircleWidget extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String imgUrl;

  const ReelCircleWidget({
    super.key,
    required this.theme,
    required this.title,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.primary,
              width: 2.5,
            ),
          ),
          child: ClipOval(child: Image.asset(imgUrl, fit: BoxFit.cover)),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: theme.text.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}