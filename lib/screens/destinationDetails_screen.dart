import 'package:CarthagoGuide/models/hotel.dart';
import 'package:CarthagoGuide/models/restaurant.dart';
import 'package:CarthagoGuide/providers/restaurant_provider.dart';
import 'package:CarthagoGuide/screens/hotelDetails_screen.dart';
import 'package:CarthagoGuide/screens/hotels_screen.dart';
import 'package:CarthagoGuide/screens/restaurantDetails_screen.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_card.dart';
import 'package:CarthagoGuide/widgets/restaurant_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/widgets/section_title.dart';
import 'package:CarthagoGuide/providers/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DestinationDetailsScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final List<String>? gallery;
  final String? destinationId;
  final VoidCallback? onNavigateToHotels;
  final VoidCallback? onNavigateToRestaurants;


  const DestinationDetailsScreen({
    super.key,
    this.title,
     this.description,
     this.gallery,
     this.destinationId,
    this.onNavigateToHotels,
    this.onNavigateToRestaurants,
  });

  @override
  State<DestinationDetailsScreen> createState() =>
      _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen> {
  bool _isDescriptionExpanded = false;
  static const int _maxDescriptionLength = 225;
  List<Hotel> _destinationHotels = [];
  List<Restaurant> _destinationRestaurants = [];


  @override
  void initState() {
    super.initState();
    // Filter hotels by destination from all hotels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
      setState(() {
        // Filter hotels where destinationId matches
        _destinationHotels = hotelProvider.allHotels
            .where((hotel) => hotel.destinationId == widget.destinationId)
            .toList();

        print("Filtering hotels for destination: ${widget.destinationId}");
        print("Found ${_destinationHotels.length} hotels");

        final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);

        _destinationRestaurants = restaurantProvider.allRestaurants
            .where((resto) => resto.destinationId == widget.destinationId)
            .toList();

        print("Filtering restaurants for destination: ${widget.destinationId}");
        print("Found ${_destinationRestaurants.length} restaurants");

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    final bool _isDescriptionTooLong =
        (widget.description?.length ?? 0) > _maxDescriptionLength;

    final String displayedDescription = _isDescriptionExpanded || !_isDescriptionTooLong
        ? (widget.description ?? '')
        : (widget.description?.substring(0, _maxDescriptionLength) ?? '') + '...';


    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.text),
        title: Text(
          widget.title?? "",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery Carousel
            CarouselSlider.builder(
              itemCount: widget.gallery?.length ?? 0,
              itemBuilder: (context, index, realIndex) {
                final imgUrl = widget.gallery?[index] ?? '';
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                );
              },
              options: CarouselOptions(
                height: 250.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            const SizedBox(height: 20),

            // Description Section
            Text(
              "Détails de la Destination:",
              style: TextStyle(
                color: theme.text,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              displayedDescription,
              style: TextStyle(
                color: theme.text.withOpacity(0.7),
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            if (_isDescriptionTooLong)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                child: Text(
                  _isDescriptionExpanded ? "Afficher moins" : "Afficher plus",
                  style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Hotels Section
            SectionTitleWidget(
              title: "Hôtels",
              theme: theme,
              showMore: true,
              onTap: () {
                final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
                hotelProvider.filterByDestination(widget.destinationId!);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            if (_destinationHotels.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        color: theme.primary.withOpacity(0.5),
                        size: 60,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Aucun hôtel disponible pour cette destination",
                        style: TextStyle(
                          color: theme.text.withOpacity(0.6),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _destinationHotels.take(5).length,
                  itemBuilder: (context, index) {
                    final hotel = _destinationHotels.take(5).toList()[index];
                    return Container(
                      width: 240,
                      margin: const EdgeInsets.only(right: 15),
                      child: HotelCardWidget(
                        theme: theme,
                        title: hotel.name,
                        destination: hotel.destinationName ?? 'Unknown',
                        imgUrl: hotel.images!.first ?? hotel.cover,
                        rating: hotel.categoryCode?.toDouble() ?? 4.0,
                        isHotel: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HotelDetailsScreen(hotel: hotel),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

// Restaurants Section
            SectionTitleWidget(
              title: "Restaurants",
              theme: theme,
              showMore: true,
              onTap: () {
                // Navigator.push...
              },
            ),
            const SizedBox(height: 15),

            if (_destinationRestaurants.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: theme.primary.withOpacity(0.5),
                        size: 60,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Aucun restaurant disponible pour cette destination",
                        style: TextStyle(
                          color: theme.text.withOpacity(0.6),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _destinationRestaurants.take(5).length,
                  itemBuilder: (context, index) {
                    final resto = _destinationRestaurants.take(5).toList()[index];
                    return Container(
                      width: 240,
                      margin: const EdgeInsets.only(right: 15),
                      child: RestaurantCardWidget(
                        title: resto.name,
                        location: resto.destinationName ?? 'Unknown',
                        imgUrl: resto.images!.first,
                        rating: resto.rate?.toDouble() ?? 4.0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RestaurantDetailsScreen(restaurant: resto),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

          ],
        ),
      ),
    );
  }
}
