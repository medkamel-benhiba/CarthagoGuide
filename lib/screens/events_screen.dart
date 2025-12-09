import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/providers/event_provider.dart';
import 'package:CarthagoGuide/screens/eventDetails_screen.dart';
import 'package:CarthagoGuide/widgets/event_card.dart';
import 'package:CarthagoGuide/widgets/hotels/filters/filter_section.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const EventsScreen({super.key, this.onMenuTap});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

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
          onPressed: widget.onMenuTap,
        ),
        title: Text(
          "Évènements",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Text(
                provider.errorMessage!,
                style: TextStyle(color: theme.text),
              ),
            );
          }

          if (provider.events.isEmpty) {
            return Center(
              child: Text(
                "Aucun événement disponible",
                style: TextStyle(color: theme.text),
              ),
            );
          }

          final events = provider.events;

          return SingleChildScrollView(
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
                      //FilterSection(theme: theme, type: FilterType.basic),
                    ],
                  ),
                  const SizedBox(height: 15),

                  /// EVENTS LIST VIEW
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: EventCardWidget(
                          theme: theme,
                          title: event.title,
                          location: event.address ?? "Lieu non spécifié",
                          imgUrl: event.cover ?? "",
                          date: event.startDate ?? "",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailsScreen(
                                        event: event,
                                      ),
                                )
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
        },
      ),
    );
  }
}
