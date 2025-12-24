import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  final bool showInTopMenu;
  final double height;
  final Color? iconColor;
  final VoidCallback? onLanguageChanged;

  const LanguageSelector({
    Key? key,
    this.showInTopMenu = false,
    this.height = 40,
    this.iconColor,
    this.onLanguageChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showInTopMenu) {
      return _buildTopMenuLanguageSelector(context);
    }
    return _buildPopupLanguageSelector(context);

  }

  Widget _buildTopMenuLanguageSelector(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<Locale>(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(
              context.locale.languageCode.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (Locale locale) {
          context.setLocale(locale);
          onLanguageChanged?.call(); // Added callback
        },
        itemBuilder: (BuildContext context) => _buildMenuItems(context),
      ),
    );
  }

  // Version for the Drawer: Displays Flag + Language Name
  Widget _buildPopupLanguageSelector(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final currentLocale = context.locale.languageCode;

    return PopupMenuButton<Locale>(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                Icons.language,
                color: iconColor ?? theme.primary
            ),
            const SizedBox(width: 10),
            Text(
              "${_getLanguageFlag(currentLocale)} ${_getLanguageName(currentLocale)}",
              style: TextStyle(
                color: iconColor ?? theme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      tooltip: 'language'.tr(),
      elevation: 4,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (Locale locale) {
        context.setLocale(locale);
        onLanguageChanged?.call(); // Added callback
      },
      itemBuilder: (BuildContext context) => _buildMenuItems(context),
    );
  }

  List<PopupMenuEntry<Locale>> _buildMenuItems(BuildContext context) {
    return context.supportedLocales.map((locale) {
      final isSelected = context.locale == locale;
      return PopupMenuItem<Locale>(
        value: locale,
        child: Row(
          children: [
            Text(
              _getLanguageFlag(locale.languageCode),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 12),
            Text(
              _getLanguageName(locale.languageCode),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 18),
            ],
          ],
        ),
      );
    }).toList();
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en': return '🇺🇸';
      case 'fr': return '🇫🇷';
      case 'ar': return '🇹🇳';
      case 'ru': return '🇷🇺';
      case 'ja': return '🇯🇵';
      case 'zh': return '🇨🇳';
      case 'ko': return '🇰🇷';
      default: return '🌍';
    }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en': return 'English';
      case 'fr': return 'Français';
      case 'ar': return 'العربية';
      case 'ru': return 'Русский';
      case 'ja': return '日本語';
      case 'zh': return '中文';
      case 'ko': return '한국어';
      default: return 'Unknown';
    }
  }
}