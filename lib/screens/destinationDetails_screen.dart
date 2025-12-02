import 'package:carthagoguide/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imgUrl;

  const DestinationDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.text),
        title: Text(
          title,
          style: TextStyle(color: theme.text, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imgUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Détails de la Destination: $title",
                style: TextStyle(
                  color: theme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  color: theme.text.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Placeholder for more complex detail widgets (Gallery, Map, etc.)
              Icon(Icons.map_outlined, color: theme.primary, size: 50),
              const SizedBox(height: 10),
              Text(
                "Carte et Guide bientôt disponibles",
                style: TextStyle(color: theme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}