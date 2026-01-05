import 'package:CarthagoGuide/providers/destination_provider.dart';
import 'package:CarthagoGuide/providers/hotel_provider.dart';
import 'package:CarthagoGuide/providers/guestHouse_provider.dart';
import 'package:CarthagoGuide/providers/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'custom_filter_dropdown.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';

enum FilterType { hotel, restaurant, guestHouse, basic }

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
    final bool isGuestHouse = type == FilterType.guestHouse;
    final locale = context.locale;


    if (isHotel) {
      return Consumer<HotelProvider>(
        builder: (context, provider, child) =>
            _buildFilterRow(context, provider, isHotel: true),
      );
    } else if (isGuestHouse) {
      return Consumer<GuestHouseProvider>(
        builder: (context, provider, child) =>
            _buildFilterRow(context, provider, isGuestHouse: true),
      );
    } else if (isRestaurant) {
      return Consumer<RestaurantProvider>(
        builder: (context, provider, child) =>
            _buildFilterRow(context, provider, isRestaurant: true),
      );
    } else {
      return _buildFilterRow(context, null);
    }
  }

  Map<String, dynamic> _getProviderFilters(dynamic provider) {
    if (provider is HotelProvider) {
      return {
        'stars': provider.selectedStars,
        'destination': provider.selectedDestination,
        'destinationId': provider.selectedDestinationId,
        'clear': provider.clearFilters
      };
    } else if (provider is GuestHouseProvider) {
      return {
        'stars': provider.selectedStars,
        'destination': provider.selectedDestination,
        'clear': provider.clearFilters
      };
    } else if (provider is RestaurantProvider) {
      return {
        'forks': provider.minRating != null ? provider.minRating!.toInt() : null,
        'destination': provider.currentState,
        'destinationId': provider.currentDestinationId,
        'clear': provider.clearFilters
      };
    }
    return {'stars': null, 'destination': null, 'clear': null};
  }

  void _setProviderStars(dynamic provider, int stars) {
    if (provider is HotelProvider) {
      provider.setStars(stars);
    } else if (provider is GuestHouseProvider) {
      provider.setStars(stars);
    } else if (provider is RestaurantProvider) {
      provider.setMinRating(stars.toDouble());
    }
  }

  void _setProviderDestination(dynamic provider, String destination) {
    if (provider is HotelProvider) {
      provider.setDestination(destination);
    } else if (provider is GuestHouseProvider) {
      provider.setDestination(destination);
    } else if (provider is RestaurantProvider) {
      provider.setStateFilter(destination);
    }
  }

  Widget _buildFilterRow(
      BuildContext context,
      dynamic provider, {
        bool isHotel = false,
        bool isRestaurant = false,
        bool isGuestHouse = false,
      }) {
    final destinationProvider =
    Provider.of<DestinationProvider>(context, listen: false);
    final destinations = destinationProvider.destinations;

    final filters = _getProviderFilters(provider);

    final currentStarsOrForks = provider is HotelProvider
        ? provider.selectedStars
        : provider is GuestHouseProvider
        ? provider.selectedStars
        : provider is RestaurantProvider
        ? provider.minRating?.toInt()
        : null;

    // Updated logic to handle both currentState and currentDestinationId
    String? currentDestination;
    if (provider is HotelProvider) {
      currentDestination = provider.selectedDestination ??
          destinations
              .firstWhereOrNull((d) => d.id == provider.selectedDestinationId)
              ?.getName(context.locale);
    } else if (provider is GuestHouseProvider) {
      currentDestination = provider.selectedDestination;
    } else if (provider is RestaurantProvider) {
      // Check if there's a destination ID filter active
      if (provider.currentDestinationId != null) {
        currentDestination = destinations
            .firstWhereOrNull((d) => d.id == provider.currentDestinationId)
            ?.getName(context.locale);
      } else {
        currentDestination = provider.currentState;
      }
    }

    final VoidCallback? clearFilters = filters['clear'] as VoidCallback?;

    final String primaryLabel = isHotel
        ? (currentStarsOrForks != null
        ? "$currentStarsOrForks ${currentStarsOrForks > 1 ? 'filters.stars'.tr() : 'filters.star'.tr()}"
        : 'filters.stars'.tr())
        : (isRestaurant
        ? (currentStarsOrForks != null
        ? "$currentStarsOrForks ${currentStarsOrForks > 1 ? 'filters.forks'.tr() : 'filters.fork'.tr()}"
        : 'filters.forks'.tr())
        : 'filters.filter'.tr());

    final IconData primaryDropdownIcon = isHotel
        ? Icons.star_border
        : (isRestaurant ? Icons.restaurant_menu : Icons.filter_list);
    final IconData visualRatingIcon =
    isHotel ? Icons.star : (isRestaurant ? Icons.restaurant_menu : Icons.filter_list);

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isHotel) ...[
          CustomFilterDropdown(
            theme: theme,
            label: primaryLabel,
            icon: primaryDropdownIcon,
            options: primaryOptions,
            onSelectedIndex: (index) {
              final value = ratingFilters[index];
              _setProviderStars(provider, value);
            },
          ),
          const SizedBox(width: 15),
        ],
        // Destination Filter
        CustomFilterDropdown(
          theme: theme,
          label: currentDestination ?? 'filters.destination'.tr(),
          icon: Icons.location_on_outlined,
          options: destinations
              .map((d) => Text(d.getName(context.locale), style: TextStyle(color: theme.text)))
              .toList(),
          onSelectedIndex: (index) {
            final selected = destinations[index].name;
            _setProviderDestination(provider, selected);
          },
        ),
        const SizedBox(width: 15),
        // Clear Filters
        if (clearFilters != null &&
            (currentStarsOrForks != null || currentDestination != null))
          GestureDetector(
            onTap: clearFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFA30000),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
            ),
          ),
      ],
    );
  }
}