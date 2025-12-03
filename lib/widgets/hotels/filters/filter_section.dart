import 'package:carthagoguide/providers/destination_provider.dart';
import 'package:carthagoguide/providers/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carthagoguide/constants/theme.dart';
import 'custom_filter_dropdown.dart';

enum FilterType { hotel, restaurant, basic }

class FilterSection extends StatelessWidget {
  final AppTheme theme;
  final FilterType type;

  const FilterSection({
    super.key,
    required this.theme,
    required this.type,
  });

  static const List<int> ratingFilters = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    final bool isHotel = type == FilterType.hotel;
    final bool isRestaurant = type == FilterType.restaurant;

    final destinationProvider = Provider.of<DestinationProvider>(context);
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);

    final destinations = destinationProvider.destinations;

    final bool showPrimaryFilter = isHotel || isRestaurant;

    // Dynamic hotel/restaurant label
    final String primaryLabel = isHotel ? "Étoiles" : "Fourchette";
    final IconData primaryDropdownIcon =
    isHotel ? Icons.star_border : Icons.restaurant_menu;

    final IconData visualRatingIcon =
    isHotel ? Icons.star : Icons.local_dining;

    // Build star/fork rating icons
    final List<Widget> primaryOptions = ratingFilters.map((count) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
              (_) => Icon(
            visualRatingIcon,
            color: Colors.amber,
            size: 18,
          ),
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment:
      showPrimaryFilter ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        // ⭐ Star/Fork filter (only hotels or restaurants)
        if (showPrimaryFilter) ...[
          CustomFilterDropdown(
            theme: theme,
            label: primaryLabel,
            icon: primaryDropdownIcon,
            options: primaryOptions,
            onSelectedIndex: (index) {
              final value = ratingFilters[index];

              if (isHotel) {
                hotelProvider.setStars(value);
                print("FILTER → $value star(s)");
              } else if (isRestaurant) {
                print("FILTER → $value fork(s)");
                // TODO restaurant filter
              }
            },
          ),
          const SizedBox(width: 15),
        ],

        // 📍 REAL DESTINATIONS FROM API
        CustomFilterDropdown(
          theme: theme,
          label: "Destination",
          icon: Icons.location_on_outlined,
          options: destinations
              .map(
                (d) => Text(
              d.name,
              style: TextStyle(color: theme.text),
            ),
          )
              .toList(),
          onSelectedIndex: (index) {
            final selected = destinations[index].name;

            print("FILTER → Destination = $selected");

            if (isHotel) {
              hotelProvider.setDestination(selected);
            }

            // You can add restaurant destination logic later
          },
        ),
      ],
    );
  }
}
