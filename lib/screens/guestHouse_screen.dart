import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/screens/guestHouseDetails_screen.dart';
import 'package:CarthagoGuide/widgets/hotels/filters/filter_section.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_card.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:CarthagoGuide/widgets/pagination_controls.dart';
import 'package:CarthagoGuide/widgets/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CarthagoGuide/providers/guestHouse_provider.dart';

class GuestHouseScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const GuestHouseScreen({super.key, this.onMenuTap});

  @override
  State<GuestHouseScreen> createState() => _GuestHouseScreenState();
}

class _GuestHouseScreenState extends State<GuestHouseScreen> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GuestHouseProvider>(context, listen: false).fetchMaisons();
    });
  }

  void _goToPage(int page, GuestHouseProvider provider) {
    setState(() => _currentPage = page);
    provider.loadPage(page);
  }

  // -------------------------------------------------------------
  // SKELETON LOADER
  // -------------------------------------------------------------
  Widget _buildSkeletonLoader(AppTheme theme) {
    Widget cardSkeleton = Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          SkeletonBox(
            theme: theme,
            width: double.infinity,
            height: 180,
            radius: 15,
          ),
          const SizedBox(height: 10),
          // Title Line
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
          onPressed: widget.onMenuTap,
        ),
        title: Text(
          "Maisons d'Hôte",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<GuestHouseProvider>(
        builder: (context, maisonProvider, child) {
          final guestHouses = maisonProvider.maisons;
          final isLoading = maisonProvider.isLoading;
          final errorMessage = maisonProvider.errorMessage;
          final totalCount = maisonProvider.totalMaisonsCount;

          if (errorMessage != null) {
            return Center(
                child: Text(errorMessage,
                    style: const TextStyle(color: Colors.red)));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    theme: theme,
                    onChanged: (query) {
                      maisonProvider.setSearchQuery(query);
                      setState(() => _currentPage = 1);
                    },
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Résultats ($totalCount)",
                        style: TextStyle(
                          color: theme.text.withOpacity(0.6),
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                      FilterSection(theme: theme, type: FilterType.guestHouse),
                    ],
                  ),

                  const SizedBox(height: 15),

                  if (isLoading) _buildSkeletonLoader(theme),

                  if (!isLoading && guestHouses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text("Aucune maison d'hôtes trouvée."),
                      ),
                    ),

                  if (!isLoading)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: guestHouses.length,
                      itemBuilder: (context, index) {
                        final guesthouse = guestHouses[index];
                        final rating =
                            double.tryParse(guesthouse.noteGoogle) ?? 0.0;

                        return HotelCardWidget(
                          theme: theme,
                          title: guesthouse.name,
                          destination: guesthouse.destination.name,
                          imgUrl: guesthouse.images.isNotEmpty
                              ? guesthouse.images.first
                              : "https://via.placeholder.com/300x200?text=No+Image",
                          rating: rating,
                          isHotel: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GuestHouseDetailsScreen(guestHouse: guesthouse,),
                              ),
                            );
                          },
                        );
                      },
                    ),

                  PaginationControls(
                    totalPages: maisonProvider.totalPages,
                    currentPage: maisonProvider.currentPage,
                    primaryColor: theme.primary,
                    textColor: theme.text,
                    isEmptyOrLoading: maisonProvider.isLoading || maisonProvider.maisons.isEmpty,
                    onPageChange: (page) => _goToPage(page, maisonProvider),
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
