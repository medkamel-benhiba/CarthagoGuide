import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/hotels/filters/filter_section.dart';
import 'package:carthagoguide/widgets/hotels/hotel_card.dart'; // Re-use HotelCardWidget style
import 'package:carthagoguide/widgets/hotels/hotel_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<Map<String, dynamic>> guestHouses = [
  {
    "title": "Dar Fatma",
    "destination": "Sidi Bou Said",
    "image": "assets/images/sidibou.jpg",
    "rating": 5.0,
    "price": 150,
  },
  {
    "title": "Villa Bleue",
    "destination": "Hammamet",
    "image": "assets/images/event3.jpg",
    "rating": 4.5,
    "price": 110,
  },
  {
    "title": "Diwan Djerba",
    "destination": "Djerba",
    "image": "assets/images/djerba.jpg",
    "rating": 4.0,
    "price": 90,
  },
];

class GuestHouseScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const GuestHouseScreen({super.key, this.onMenuTap});

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
          "Maisons D'Hôte",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Résultats (${guestHouses.length})",
                    style: TextStyle(
                      color: theme.text.withOpacity(0.6),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  FilterSection(theme: theme, type: FilterType.basic),

                ],
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: guestHouses.length,
                itemBuilder: (context, index) {
                  final house = guestHouses[index];
                  return HotelCardWidget(
                    theme: theme,
                    title: house["title"],
                    destination: house["destination"],
                    imgUrl: house["image"],
                    rating: house["rating"],
                    price: house["price"],
                    // Navigation will go to a placeholder details screen (e.g., GuestHouseDetailsScreen)
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => GuestHouseDetailsScreen(...)));
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