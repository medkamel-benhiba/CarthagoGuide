import 'package:CarthagoGuide/screens/circuitDetails_screen.dart';
import 'package:CarthagoGuide/widgets/circuit_card.dart';
import 'package:CarthagoGuide/widgets/circuit_card_ver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/providers/voyage_provider.dart';
import 'package:CarthagoGuide/models/voyage.dart';

class CircuitScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const CircuitScreen({super.key, this.onMenuTap});

  @override
  State<CircuitScreen> createState() => _CircuitScreenState();
}

class _CircuitScreenState extends State<CircuitScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch voyages when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoyageProvider>().fetchVoyages();
    });
  }

  // Convert Voyage to circuit card data
  Map<String, dynamic> _voyageToCardData(Voyage voyage, Locale locale) {
    // Calculate a mock progress based on voyage id hash
    final progress = ((voyage.id.hashCode % 100) / 100).clamp(0.4, 0.9);

    // Get the duration from the number field (assuming it represents days)
    final duration = voyage.number.isNotEmpty
        ? '${voyage.number} ${locale.languageCode == 'fr' ? 'jours' : 'jours'}'
        : '3 jours';

    // Extract start and end destinations from the name or use defaults
    final name = voyage.name;
    String startDest = 'Tunis';
    String endDest = 'Various';

    // Try to extract destinations from voyage name
    if (name.contains(' - ')) {
      final parts = name.split(' - ');
      if (parts.length >= 2) {
        endDest = parts.last.split(':').first.trim();
      }
    } else if (name.toLowerCase().contains('djerba')) {
      endDest = 'Djerba';
    } else if (name.toLowerCase().contains('douz')) {
      endDest = 'Douz';
    } else if (name.toLowerCase().contains('tozeur')) {
      endDest = 'Tozeur';
    } else if (name.toLowerCase().contains('tabarka')) {
      endDest = 'Tabarka';
    }

    return {
      'id': voyage.id,
      'title': name,
      'duration': duration,
      'startDestination': startDest,
      'endDestination': endDest,
      'image': voyage.images.first ?? 'assets/images/circuit1.jpg',
      'progress': progress,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final voyageProvider = Provider.of<VoyageProvider>(context);
    final locale = Localizations.localeOf(context);


    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.text),
          onPressed: widget.onMenuTap,
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
      body: voyageProvider.isLoading
          ? Center(
        child: CircularProgressIndicator(color: theme.primary),
      )
          : voyageProvider.error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.text.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(color: theme.text, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => voyageProvider.fetchVoyages(),
              child: Text('Réessayer', style: TextStyle(color: theme.primary)),
            ),
          ],
        ),
      )
          : voyageProvider.voyages.isEmpty
          ? Center(
        child: Text(
          'Aucun circuit disponible',
          style: TextStyle(color: theme.text, fontSize: 16),
        ),
      )
          : SingleChildScrollView(
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
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: voyageProvider.voyages.length > 3 ? 3 : voyageProvider.voyages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final voyage = voyageProvider.voyages[index];
                  final circuit = _voyageToCardData(voyage, locale);

                  return SizedBox(
                    width: 240,
                    child: CircuitCard(
                      theme: theme,
                      title: circuit["title"]!,
                      duration: circuit["duration"]!,
                      startDestination: circuit["startDestination"]!,
                      endDestination: circuit["endDestination"]!,
                      imgUrl: circuit["image"]!,
                      progress: circuit["progress"] ?? 0.5,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CircuitDetailsScreen(
                              circuit: voyage,
                            ),
                          ),
                        );
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
              itemCount: voyageProvider.voyages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final voyage = voyageProvider.voyages[index];
                final circuit = _voyageToCardData(voyage, locale);

                return SizedBox(
                  height: 200,
                  child: CircuitCard(
                    theme: theme,
                    title: circuit["title"]!,
                    duration: circuit["duration"]!,
                    startDestination: circuit["startDestination"]!,
                    endDestination: circuit["endDestination"]!,
                    imgUrl: circuit["image"]!,
                    progress: circuit["progress"] ?? 0.5,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CircuitDetailsScreen(
                            circuit: voyage,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}