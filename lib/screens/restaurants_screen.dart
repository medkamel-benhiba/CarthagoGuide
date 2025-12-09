import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/providers/restaurant_provider.dart';
import 'package:CarthagoGuide/screens/restaurantDetails_screen.dart';
import 'package:CarthagoGuide/widgets/hotels/filters/filter_section.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:CarthagoGuide/widgets/pagination_controls.dart';
import 'package:CarthagoGuide/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/skeleton_box.dart';

class RestaurantScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const RestaurantScreen({super.key, this.onMenuTap});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurants();
    });
  }

  void _goToPage(int page, RestaurantProvider provider) {
    setState(() => _currentPage = page);
    provider.loadPage(page);
  }

  Widget _buildSkeletonLoader(AppTheme theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: theme.CardBG,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: theme.text.withOpacity(0.08),
                blurRadius: 13,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                theme: theme,
                height: 130,
                width: double.infinity,
                radius: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonBox(theme: theme, height: 18, width: 120, radius: 4),
                        SkeletonBox(theme: theme, height: 18, width: 40, radius: 4),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SkeletonBox(theme: theme, height: 16, width: 80, radius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
          "Restaurants",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          final restaurants = provider.restaurants;
          final isLoading = provider.isLoading;
          final totalCount = provider.totalRestaurantsCount;
          final errorMessage = provider.errorMessage;

          if (errorMessage != null) {
            return Center(
              child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
            );
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
                      provider.setSearchQuery(query);
                      setState(() => _currentPage = 1);
                    },
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Text(
                        "Résultats ($totalCount)",
                        style: TextStyle(
                          color: theme.text.withOpacity(0.6),
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      FilterSection(theme: theme, type: FilterType.restaurant),
                    ],
                  ),

                  const SizedBox(height: 15),

                  if (isLoading) _buildSkeletonLoader(theme),

                  if (!isLoading && restaurants.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: Text("Aucun restaurant trouvé.")),
                    ),

                  if (!isLoading)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final r = restaurants[index];

                        return RestaurantCardWidget(
                          title: r.getName(Localizations.localeOf(context)),
                          location: r.destinationName ?? "Inconnu",
                          imgUrl: r.images.isNotEmpty
                              ? r.images.first
                              : "assets/images/placeholder.jpg",
                          rating: (r.rate is num) ? r.rate.toDouble() : 4.0,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RestaurantDetailsScreen(restaurant: r),
                              ),
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  PaginationControls(
                    totalPages: provider.totalPages,
                    currentPage: provider.currentPage,
                    primaryColor: theme.primary,
                    textColor: theme.text,
                    isEmptyOrLoading: provider.isLoading || provider.restaurants.isEmpty,
                    onPageChange: (page) => _goToPage(page, provider),
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
