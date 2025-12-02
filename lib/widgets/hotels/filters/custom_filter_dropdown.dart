import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class CustomFilterDropdown extends StatelessWidget {
  final AppTheme theme;
  final String label;
  final IconData icon;
  final List<Widget> options;
  final void Function(int)? onSelectedIndex;

  const CustomFilterDropdown({
    super.key,
    required this.theme,
    required this.label,
    required this.icon,
    required this.options,
    this.onSelectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (index) {
        if (onSelectedIndex != null) onSelectedIndex!(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filtre sélectionné: ${index + 1}')),
        );
      },
      itemBuilder: (context) {
        return List.generate(
          options.length,
              (index) => PopupMenuItem<int>(
            value: index,
            child: options[index],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
