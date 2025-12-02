import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/hotels/filters/filter_section.dart';
import 'package:carthagoguide/widgets/hotels/hotel_searchbar.dart';
import 'package:carthagoguide/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dummy data for Restaurants
final List<Map<String, dynamic>> restaurants = [
  {
    "title": "Dar Zarrouk",
    "location": "Sidi Bou Said",
    "image": "assets/images/sidibou.jpg",
    "rating": 4.5,
    "cuisine": "Tunisienne / Méditerranéenne",
  },
  {
    "title": "The Pearl",
    "location": "Lac 1, Tunis",
    "image": "assets/images/sousse.jpg", // Placeholder image
    "rating": 4.0,
    "cuisine": "Internationale / Fruits de Mer",
  },
  {
    "title": "Le Golf",
    "location": "Djerba",
    "image": "assets/images/djerba.jpg",
    "rating": 4.7,
    "cuisine": "Gastronomique",
  },
];

// Reusable Widget for Restaurant List Item (RestaurantCardWidget definition REMOVED)
// ...

class RestaurantScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const RestaurantScreen({super.key, this.onMenuTap});

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
          "Restaurants",
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
              // theme object is no longer required here
              SearchBarWidget(theme: theme),
              const SizedBox(height: 25),
              FilterSection(theme: theme, type: FilterType.restaurant),
              const SizedBox(height: 25),
              Text(
                "Résultats (${restaurants.length})",
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
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return RestaurantCardWidget(
                    title: restaurant["title"],
                    location: restaurant["location"],
                    imgUrl: restaurant["image"],
                    rating: restaurant["rating"],
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailsScreen(...)));
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