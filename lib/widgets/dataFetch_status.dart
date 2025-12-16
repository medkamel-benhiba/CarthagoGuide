// /widgets/data_fetch_status_widget.dart

import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class DataFetchStatusWidget extends StatelessWidget {
  final AppTheme theme;
  final String? errorMessage;
  final bool isLoading;
  final int itemCount;
  final VoidCallback onRetry;
  final String emptyMessage;

  const DataFetchStatusWidget({
    super.key,
    required this.theme,
    required this.errorMessage,
    required this.isLoading,
    required this.itemCount,
    required this.onRetry,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const SizedBox.shrink();

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded,
                color: const Color(0xff8d0d0d), // Fixed error color
                size: 40),
            const SizedBox(height: 10),
            Text(
              "Erreur de Connexion",
              style: TextStyle(
                color: theme.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Veuillez vérifier votre connexion Internet et réessayer.",
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.text.withOpacity(0.7)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Réessayer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (itemCount == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          emptyMessage,
          style: TextStyle(color: theme.text.withOpacity(0.6)),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}