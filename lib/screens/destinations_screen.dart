import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/screens/destinationDetails_screen.dart'; // Import the new details screen
import 'package:carthagoguide/widgets/destination_card.dart'; // Re-use DestinationCardWidget
import 'package:carthagoguide/widgets/hotels/hotel_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dummy data based on home_screen.dart destinations
final List<Map<String, String>> destinationsList = [
  {
    "name": "Sousse",
    "image": "assets/images/sousse.jpg",
    "description": "Sousse, la perle du Sahel, est célèbre pour sa Médina historique et ses plages animées.",
  },
  {
    "name": "Bizerte",
    "image": "assets/images/bizerte.jpg",
    "description": "Bizerte, la ville la plus septentrionale d'Afrique, offre un mélange de lacs, de forêts et de côtes.",
  },
  {
    "name": "Djerba",
    "image": "assets/images/djerba.jpg",
    "description": "Djerba, l'île aux rêves, est réputée pour ses plages de sable fin et son héritage culturel unique.",
  },
  {
    "name": "Sidi Bou Said",
    "image": "assets/images/sidibou.jpg",
    "description": "Sidi Bou Said est un village pittoresque aux couleurs bleu et blanc offrant des vues spectaculaires sur la Méditerranée.",
  },
  {
    "name": "Tozeur",
    "image": "assets/images/tozeur.jpg",
    "description": "Tozeur, l'oasis du désert, est la porte du Sahara avec ses palmeraies luxuriantes et son architecture en briques.",
  },
  {
    "name": "Carthage",
    "image": "assets/images/carthage.jpg",
    "description": "Carthage est un site archéologique historique, témoin de l'ancienne civilisation punique et romaine.",
  },
];

class DestinationScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const DestinationScreen({super.key, this.onMenuTap});

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
          "Destinations",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(theme: theme),
              const SizedBox(height: 25),

              Text(
                "Résultats (${destinationsList.length})",
                style: TextStyle(
                  color: theme.text.withOpacity(0.6),
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: destinationsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final destination = destinationsList[index];
                  return DestinationCardWidget(
                    theme: theme,
                    title: destination["name"]!,
                    imgUrl: destination["image"]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DestinationDetailsScreen(
                            title: destination["name"]!,
                            description: destination["description"]!,
                            imgUrl: destination["image"]!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}