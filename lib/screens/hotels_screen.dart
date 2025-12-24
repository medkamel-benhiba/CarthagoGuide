import 'package:CarthagoGuide/screens/hotelDetails_screen.dart';
import 'package:CarthagoGuide/screens/mainScreen_container.dart';
import 'package:CarthagoGuide/widgets/hotels/filters/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_card.dart';
import 'package:CarthagoGuide/providers/hotel_provider.dart';
import 'package:CarthagoGuide/providers/destination_provider.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:CarthagoGuide/widgets/skeleton_box.dart';
import 'package:CarthagoGuide/widgets/dataFetch_status.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  int _currentPage = 1;
  late FixedExtentScrollController _scrollController;
  late ScrollController _paginationScrollController;
  bool _isFetchingMore = false;

  void _toggleDrawer() {
    final containerState =
    context.findAncestorStateOfType<MainScreenContainerState>();
    containerState?.toggleDrawer();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: 1);
    _paginationScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _continueLoadingPages();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _paginationScrollController.dispose();
    super.dispose();
  }

  Future<void> _continueLoadingPages() async {
    final provider = Provider.of<HotelProvider>(context, listen: false);

    if (!provider.hasStartedFetching) {
      await provider.fetchAllHotels();
    }

    if (!provider.hasMorePages) return;
    if (_isFetchingMore) return;

    if (mounted) setState(() => _isFetchingMore = true);

    await provider.continueLoadingAllPages();

    if (mounted) setState(() => _isFetchingMore = false);
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
          SkeletonBox(theme: theme, width: double.infinity, height: 20, radius: 4),
          const SizedBox(height: 8),
          SkeletonBox(theme: theme, width: 150, height: 16, radius: 4),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (_) => cardSkeleton),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final locale = context.locale;

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
          'hotels.title'.tr(),
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer2<HotelProvider, DestinationProvider>(
        builder: (context, hotelProvider, destinationProvider, _) {
          final hotelsList = hotelProvider.hotels;
          final int pageSize = hotelProvider.pageSize;
          final int totalFiltered = hotelProvider.currentlyFilteredHotels.length;
          final int totalPages = (totalFiltered / pageSize).ceil();
          final bool isLoadingInitial = hotelProvider.isLoading && hotelsList.isEmpty;
          final bool isLoadingMore = _isFetchingMore && hotelsList.isNotEmpty;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                SearchBarWidget(
                  theme: theme,
                  onChanged: hotelProvider.setSearchQuery,
                ),

                const SizedBox(height: 25),
                FilterSection(theme: theme, type: FilterType.hotel),
                const SizedBox(height: 25),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (isLoadingInitial)
                          _buildHotelsSkeletonList(theme),

                        if (!isLoadingInitial &&
                            hotelProvider.errorDetail == null &&
                            hotelsList.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'activities.results'.tr(namedArgs: {
                                  'count': totalFiltered.toString()
                                }),
                                style: TextStyle(
                                  color: theme.text.withOpacity(0.6),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                              ),
                              if (isLoadingMore)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        color: theme.primary,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: theme.primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
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
                                  String imageUrl = "assets/images/placeholder.jpg";

                                  if (hotel.vignette != null) {
                                    imageUrl = hotel.vignette!;
                                  }
                                  else if (hotel.cover != null ) {
                                    imageUrl = hotel.cover;
                                  }


                                  return HotelCardWidget(
                                    theme: theme,
                                    title: hotel.getName(locale),
                                    destination: hotel.getDestinationName(locale) ??
                                        'hotels.unknown_destination'.tr(),
                                    imgUrl: imageUrl,
                                    rating: hotel.categoryCode?.toDouble() ?? 4.0,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => HotelDetailsScreen(
                                            hotel: hotel,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                          // 🔹 PAGINATION
                          if (totalPages > 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: SingleChildScrollView(
                                controller: _paginationScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(totalPages, (index) {
                                    final page = index + 1;
                                    final isSelected = _currentPage == page;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isSelected
                                              ? theme.primary
                                              : theme.primary.withOpacity(0.3),
                                          minimumSize: const Size(40, 40),
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () =>
                                            _goToPage(page, hotelProvider),
                                        child: Text(
                                          page.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : theme.text,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                        ],

                        if (!isLoadingInitial &&
                            (hotelProvider.errorDetail != null || hotelsList.isEmpty))
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: Center(
                              child: hotelProvider.errorDetail != null
                                  ?
                              DataFetchStatusWidget(
                                theme: theme,
                                errorMessage: hotelProvider.errorDetail,
                                isLoading: false,
                                itemCount: 0,
                                onRetry: hotelProvider.fetchAllHotels,
                                emptyMessage: 'common.check_connection'.tr(),
                              )
                                  :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 80,
                                    color: theme.text.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'hotels.no_results'.tr(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: theme.text.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'hotels.try_different_search'.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: theme.text.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  if (hotelProvider.selectedStars != null ||
                                      hotelProvider.selectedDestination != null ||
                                      hotelProvider.searchQuery.isNotEmpty)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        hotelProvider.clearFilters();
                                      },
                                      icon: const Icon(Icons.clear_all),
                                      label: Text('common.clear_filters'.tr()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 10),
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