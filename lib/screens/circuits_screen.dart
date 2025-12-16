import 'package:CarthagoGuide/screens/circuitDetails_screen.dart';
import 'package:CarthagoGuide/screens/mainScreen_container.dart';
import 'package:CarthagoGuide/widgets/circuit_card_ver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/providers/voyage_provider.dart';
import 'package:CarthagoGuide/models/voyage.dart';

class CircuitScreen extends StatefulWidget {
  const CircuitScreen({super.key});

  @override
  State<CircuitScreen> createState() => _CircuitScreenState();
}

class _CircuitScreenState extends State<CircuitScreen> {
  // Cache for transformed voyage data
  final Map<String, Map<String, dynamic>> _cardDataCache = {};

  void _toggleDrawer() {
    final containerState = context.findAncestorStateOfType<MainScreenContainerState>();
    containerState?.toggleDrawer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoyageProvider>().fetchVoyages();
    });
  }

  Map<String, dynamic> _voyageToCardData(Voyage voyage, Locale locale) {
    // Use cache to avoid repeated transformations
    final cacheKey = '${voyage.id}_${locale.languageCode}';
    if (_cardDataCache.containsKey(cacheKey)) {
      return _cardDataCache[cacheKey]!;
    }

    final progress = ((voyage.id.hashCode % 100) / 100).clamp(0.4, 0.9);

    final duration = voyage.number.isNotEmpty
        ? '${voyage.number} ${locale.languageCode == 'fr' ? 'jours' : 'jours'}'
        : '3 jours';

    final name = voyage.name;
    String startDest = 'Tunis';
    String endDest = 'Various';

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

    final cardData = {
      'id': voyage.id,
      'title': name,
      'duration': duration,
      'startDestination': startDest,
      'endDestination': endDest,
      'image': voyage.images.isNotEmpty ? voyage.images.first : 'assets/images/circuit1.jpg',
      'progress': progress,
    };

    _cardDataCache[cacheKey] = cardData;
    return cardData;
  }

  void _navigateToDetails(BuildContext context, Voyage voyage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CircuitDetailsScreen(circuit: voyage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final voyageProvider = Provider.of<VoyageProvider>(context);
    final locale = Localizations.localeOf(context);
    final voyages = voyageProvider.voyages;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.text),
          onPressed: _toggleDrawer,
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
          : voyages.isEmpty
          ? Center(
        child: Text(
          'Aucun circuit disponible',
          style: TextStyle(color: theme.text, fontSize: 16),
        ),
      )
          : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Featured circuits section
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            sliver: SliverToBoxAdapter(
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
                ],
              ),
            ),
          ),

          // Horizontal featured list - optimized with builder
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: voyages.length > 3 ? 3 : voyages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                // Add cacheExtent for better performance
                cacheExtent: 500,
                itemBuilder: (context, index) {
                  final voyage = voyages[index];
                  final circuit = _voyageToCardData(voyage, locale);

                  return SizedBox(
                    width: 240,
                    child: CircuitCardWithGlass(
                      theme: theme,
                      title: circuit["title"]!,
                      duration: circuit["duration"]!,
                      startDestination: circuit["startDestination"]!,
                      endDestination: circuit["endDestination"]!,
                      imgUrl: circuit["image"]!,
                      progress: circuit["progress"] ?? 0.5,
                      onTap: () => _navigateToDetails(context, voyage),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Tous les circuits",
                style: TextStyle(
                  color: theme.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: voyages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final voyage = voyages[index];
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
                    onTap: () => _navigateToDetails(context, voyage),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cardDataCache.clear();
    super.dispose();
  }
}