import 'package:carthagoguide/widgets/circuit_card_ver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/circuit_card.dart';

// Dummy data
final List<Map<String, String>> fullCircuitTours = [
  {
    "title": "Sahara Desert Expedition",
    "subtitle": "3 Days | Tozeur, Douz",
    "image": "assets/images/circuit1.jpg",
  },
  {
    "title": "Ancient Carthage Route",
    "subtitle": "1 Day | Tunis, Carthage, Sidi Bou Said",
    "image": "assets/images/circuit2.jpg",
  },
  {
    "title": "Oasis Discovery",
    "subtitle": "4 Days | Mountain Oases, Chott El Djerid",
    "image": "assets/images/circuit3.jpg",
  },
  {
    "title": "Northern Coastline Tour",
    "subtitle": "2 Days | Bizerte, Tabarka, Ain Draham",
    "image": "assets/images/bizerte.jpg",
  },
];

class CircuitScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const CircuitScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.text),
          onPressed: onMenuTap,
        ),
        title: Text(
          "Circuits",
          style: TextStyle(
            color: theme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Circuits en vedette",
              style: TextStyle(
                color: theme.text,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 175,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: fullCircuitTours.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final circuit = fullCircuitTours[index];
                  return SizedBox(
                    width: 250,
                    child: CircuitCard(
                      theme: theme,
                      title: circuit["title"]!,
                      subtitle: circuit["subtitle"]!,
                      imgUrl: circuit["image"]!,
                      fullWidth: true,
                      onTap: () {
                        // Navigate to details
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),

            Text(
              "Tous les circuits",
              style: TextStyle(
                color: theme.text,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fullCircuitTours.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final circuit = fullCircuitTours[index];
                return CircuitCard(
                  theme: theme,
                  title: circuit["title"]!,
                  subtitle: circuit["subtitle"]!,
                  imgUrl: circuit["image"]!,
                  fullWidth: true,
                  onTap: () {
                    // Navigate to details
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
