import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class SearchBarWidget extends StatelessWidget {
  final AppTheme theme;
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    required this.theme,
    this.hint = "Rechercher...",
    this.onChanged,
    this.controller,
  });

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
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: theme.text.withOpacity(0.5),
            fontSize: 16,
          ),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: theme.primary),
        ),
        style: TextStyle(color: theme.text),
      ),
    );
  }
}
