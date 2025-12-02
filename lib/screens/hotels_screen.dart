import 'package:carthagoguide/screens/hotelDetails_screen.dart';
import 'package:carthagoguide/widgets/hotels/filters/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/hotels/hotel_card.dart';

import '../widgets/hotels/hotel_searchbar.dart';

final List<Map<String, dynamic>> hotels = [
  {
    "title": "Hôtel Joya Paradise & SPA Djerba",
    "destination": "Djerba",
    "image": "assets/images/joya1.jpg",
    "rating": 4.0,
    "price": 180,
  },
  {
    "title": "Desert Dreams Resort",
    "destination": "Tozeur",
    "image": "assets/images/circuit3.jpg",
    "rating": 4.0,
    "price": 120,
  },
  {
    "title": "Sidi Bou Said Boutique Stay",
    "destination": "Sidi Bou Said",
    "image": "assets/images/sidibou.jpg",
    "rating": 5.0,
    "price": 250,
  },
  {
    "title": "Bizerte Sea View Hotel",
    "destination": "Bizerte",
    "image": "assets/images/bizerte.jpg",
    "rating": 4.0,
    "price": 95,
  },
];

class HotelsScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const HotelsScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        // iconTheme: IconThemeData(color: theme.text), // Remove this line as we're overriding 'leading'
        leading: IconButton( // Add this leading button
          icon: Icon(Icons.menu_rounded, color: theme.text),
          onPressed: onMenuTap, // Use the callback
        ),
        title: Text(
          "Hôtels",
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
              FilterSection(theme: theme, type: FilterType.hotel),
              const SizedBox(height: 25),
              Text(
                "Résultats (${hotels.length})",
                style: TextStyle(
                  color: theme.text.withOpacity(0.6),
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];
                  return HotelCardWidget(
                    theme: theme,
                    title: hotel["title"],
                    destination: hotel["destination"],
                    imgUrl: hotel["image"],
                    rating: hotel["rating"],
                    price: hotel["price"],
                    // ⭐️ NEW: Pass the navigation logic to the card's onTap
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelDetailsScreen(
                            title: hotel["title"],
                            destination: hotel["destination"],
                            imgUrl: hotel["image"],
                            rating: hotel["rating"],
                            price: hotel["price"].toDouble(), // Ensure price is double for details screen
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Afficher plus d'hôtels",
                    style: TextStyle(color: theme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
