import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class SearchBarWidget extends StatelessWidget {
  final AppTheme theme;

  const SearchBarWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Rechercher des lieux, hôtels…",
          hintStyle: TextStyle(color: theme.text.withOpacity(0.4)),
          prefixIcon: Icon(Icons.search, color: theme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}