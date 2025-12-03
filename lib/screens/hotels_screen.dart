import 'package:carthagoguide/screens/hotelDetails_screen.dart';
import 'package:carthagoguide/widgets/hotels/filters/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/hotels/hotel_card.dart';
import 'package:carthagoguide/providers/hotel_provider.dart';
import 'package:carthagoguide/providers/destination_provider.dart';
import '../widgets/hotels/hotel_searchbar.dart';

class HotelsScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const HotelsScreen({super.key, this.onMenuTap});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Fetch hotels once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HotelProvider>(context, listen: false).fetchAllHotels();
      Provider.of<DestinationProvider>(context, listen: false)
          .fetchDestinations();
    });
  }

  void _goToPage(int page, HotelProvider hotelProvider) {
    setState(() => _currentPage = page);
    hotelProvider.loadPage(page);
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
          "Hôtels",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer2<HotelProvider, DestinationProvider>(
        builder: (context, hotelProvider, destinationProvider, child) {
          final hotelsList = hotelProvider.hotels;

          // If you still want pagination:
          final int pageSize = hotelProvider.pageSize; // must exist in provider
          final int totalPages =
          (hotelProvider.allHotels.length / pageSize).ceil();

          if (hotelProvider.isLoading && hotelsList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: theme.primary),
            );
          }

          if (hotelsList.isEmpty && !hotelProvider.isLoading) {
            return Center(
              child: Text(
                "Aucun hôtel trouvé.",
                style: TextStyle(color: theme.text.withOpacity(0.7)),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(theme: theme, onChanged: (value) {
                    hotelProvider.setSearchQuery(value);
                  }),
                  const SizedBox(height: 25),

                  FilterSection(theme: theme, type: FilterType.hotel),

                  const SizedBox(height: 25),

                  Text(
                    "Résultats (${hotelsList.length})",
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
                    itemCount: hotelsList.length,
                    itemBuilder: (context, index) {
                      final hotel = hotelsList[index];

                      return HotelCardWidget(
                        theme: theme,
                        title: hotel.name,
                        destination:
                        hotel.destinationName ?? "Destination inconnue",
                        imgUrl: hotel.images?.first ??
                            hotel.cover ??
                            "assets/images/placeholder.jpg",
                        rating: hotel.categoryCode?.toDouble() ?? 3.0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HotelDetailsScreen(hotel: hotel),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // 🔵 PAGINATION (only if you want it)
                  if (totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(totalPages, (index) {
                            final page = index + 1;
                            final isSelected = _currentPage == page;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? theme.primary
                                      : theme.primary.withOpacity(0.3),
                                  minimumSize: const Size(40, 40),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () => _goToPage(page, hotelProvider),
                                child: Text(
                                  page.toString(),
                                  style: TextStyle(
                                    color:
                                    isSelected ? Colors.white : theme.text,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
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
