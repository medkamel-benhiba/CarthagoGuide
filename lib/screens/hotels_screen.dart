import 'package:CarthagoGuide/screens/hotelDetails_screen.dart';
import 'package:CarthagoGuide/screens/mainScreen_container.dart';
import 'package:CarthagoGuide/widgets/hotels/filters/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_card.dart';
import 'package:CarthagoGuide/providers/hotel_provider.dart';
import 'package:CarthagoGuide/providers/destination_provider.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:CarthagoGuide/widgets/skeleton_box.dart';


class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  void _toggleDrawer() {
    final containerState = context.findAncestorStateOfType<MainScreenContainerState>();
    containerState?.toggleDrawer();
  }

  int _currentPage = 1;
  late FixedExtentScrollController _scrollController;


  @override
  void initState() {
    super.initState();

    _scrollController = FixedExtentScrollController(initialItem: 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToPage(int page, HotelProvider hotelProvider) {
    setState(() => _currentPage = page);
    hotelProvider.loadPage(page);
    if (_scrollController.hasClients) {
      _scrollController.jumpToItem(1);
    }
  }

  Widget _buildHotelsSkeletonList(AppTheme theme) {
    Widget cardSkeleton = Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            theme: theme,
            width: double.infinity,
            height: 180,
            radius: 15,
          ),
          const SizedBox(height: 10),
          SkeletonBox(
            theme: theme,
            width: double.infinity,
            height: 20,
            radius: 4,
          ),
          const SizedBox(height: 8),
          SkeletonBox(
            theme: theme,
            width: 150,
            height: 16,
            radius: 4,
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SkeletonBox(theme: theme, width: 120, height: 16, radius: 4),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) => cardSkeleton,
        ),
      ],
    );
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
          onPressed: _toggleDrawer,
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

          final int pageSize = hotelProvider.pageSize;
          final int totalPages =
          (hotelProvider.currentlyFilteredHotels.length / pageSize).ceil();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SearchBarWidget(theme: theme, onChanged: (value) {
                  hotelProvider.setSearchQuery(value);
                }),
                const SizedBox(height: 25),

                FilterSection(theme: theme, type: FilterType.hotel),

                const SizedBox(height: 25),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hotelProvider.isLoading && hotelsList.isEmpty)
                          _buildHotelsSkeletonList(theme)
                        else if (hotelsList.isEmpty && !hotelProvider.isLoading)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Text(
                                "Aucun hôtel trouvé.",
                                style: TextStyle(color: theme.text.withOpacity(0.7)),
                              ),
                            ),
                          )
                        else ...[
                            Text(
                              "Résultats (${hotelProvider.currentlyFilteredHotels.length})",
                              style: TextStyle(
                                color: theme.text.withOpacity(0.6),
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 15),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListWheelScrollView.useDelegate(
                                controller: _scrollController,
                                itemExtent: 220,
                                perspective: 0.003,
                                clipBehavior: Clip.none,

                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: hotelsList.length,
                                  builder: (context, index) {
                                    final hotel = hotelsList[index];

                                    return HotelCardWidget(
                                      theme: theme,
                                      title: hotel.name,
                                      destination:
                                      hotel.destinationName ?? "Destination inconnue",
                                      imgUrl: hotel.images?.first ??
                                          hotel.cover ??
                                          "assets/images/placeholder.jpg",
                                      rating: hotel.categoryCode?.toDouble() ?? 4.0,
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
                              ),
                            ),

                            // 🔵 PAGINATION
                            if (totalPages > 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(totalPages, (index) {
                                      final page = index + 1;
                                      final isSelected =
                                          hotelProvider.hotels.isNotEmpty && _currentPage == page;

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
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}