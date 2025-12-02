import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';
import 'custom_filter_dropdown.dart';

// Defines the type of filtering context (Hotel, Restaurant, or Basic location filter)
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
  static const List<String> destinationFilters = [
    "Tunis",
    "Djerba",
    "Sousse",
    "Bizerte",
    "Gammarth",
  ];

  @override
  Widget build(BuildContext context) {
    final bool isHotel = type == FilterType.hotel;

    // Show Stars/Forks dropdown only in Hotel or Restaurant mode
    final bool showPrimaryFilter =
        type == FilterType.hotel || type == FilterType.restaurant;

    // --- Dynamic Filter Properties ---
    final String primaryLabel = isHotel ? "Étoiles" : "Fourchette";
    final IconData primaryDropdownIcon =
    isHotel ? Icons.star_border : Icons.restaurant_menu;

    // Visual icon for rating representation
    final IconData visualRatingIcon =
    isHotel ? Icons.star : Icons.local_dining;

    // Build the list of icon rows (1 to 5)
    final List<Widget> primaryOptions = ratingFilters.map((count) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
              (_) => Icon(visualRatingIcon, color: Colors.amber, size: 18),
        ),
      );
    }).toList();
    // ---------------------------------

    return Row(
      // If only destination is shown => center it
      mainAxisAlignment:
      showPrimaryFilter ? MainAxisAlignment.center : MainAxisAlignment.end,

      children: [
        // Primary Dropdown (Étoiles or Fourchette)
        if (showPrimaryFilter) ...[
          CustomFilterDropdown(
            theme: theme,
            label: primaryLabel,
            icon: primaryDropdownIcon,
            options: primaryOptions,
            onSelectedIndex: (index) {
              print("Selected ${ratingFilters[index]} ${isHotel ? 'stars' : 'forks'}");
            },
          ),
          const SizedBox(width: 15),
        ],

        // Destination Dropdown
        CustomFilterDropdown(
          theme: theme,
          label: "Destination",
          icon: Icons.location_on_outlined,
          options: destinationFilters
              .map((d) => Text(d, style: TextStyle(color: theme.text)))
              .toList(),
        ),
      ],
    );
  }
}
