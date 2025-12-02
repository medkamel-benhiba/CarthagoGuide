import 'package:carthagoguide/constants/theme.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final AppTheme theme;

  const SearchBarWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Rechercher par nom...",
          hintStyle: TextStyle(color: theme.text.withOpacity(0.5), fontSize: 16),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: theme.primary),
        ),
        style: TextStyle(color: theme.text),
      ),
    );
  }
}