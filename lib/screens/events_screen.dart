import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/screens/home_screen.dart';
import 'package:carthagoguide/widgets/event_card.dart';
import 'package:carthagoguide/widgets/hotels/filters/filter_section.dart';
import 'package:carthagoguide/widgets/hotels/hotel_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dummy data from home_screen.dart
final List<Map<String, String>> fullEventsList = [
  {
    "title": "Carthage International Festival",
    "location": "Amphitheater of Carthage",
    "date": "26 JULY 2024",
    "image": "assets/images/event1.jpg",
  },
  {
    "title": "Jazz à Carthage",
    "location": "Cité de la Culture, Tunis",
    "date": "17 MAR 2025",
    "image": "assets/images/event2.jpg",
  },
  {
    "title": "International Festival of Hammamet",
    "location": "Hammamet",
    "date": "05 AUG 2024",
    "image": "assets/images/event3.jpg",
  },
  {
    "title": "Festival de l'Oasis de Tozeur",
    "location": "Tozeur",
    "date": "21 DEC 2024",
    "image": "assets/images/tozeur.jpg",
  },
];

class EventsScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const EventsScreen({super.key, this.onMenuTap});

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
          "Évènements",
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
                    "Résultats (${events.length})",
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
                itemCount: fullEventsList.length,
                itemBuilder: (context, index) {
                  final event = fullEventsList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15), // small margin
                    child: SizedBox(
                      width: double.infinity, // full width card
                      child: EventCardWidget(
                        theme: theme,
                        title: event["title"]!,
                        location: event["location"]!,
                        imgUrl: event["image"]!,
                        date: event["date"]!,
                        onTap: () {},
                      ),
                    ),
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
