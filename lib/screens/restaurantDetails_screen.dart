import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Internal Imports
import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/models/restaurant.dart';
import 'package:CarthagoGuide/providers/restaurant_provider.dart';
import 'package:CarthagoGuide/utils/open_googlemaps.dart';
import 'package:CarthagoGuide/widgets/hotels/detail_action_button.dart';
import 'package:CarthagoGuide/widgets/hotels/gallery_section_details.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  VideoPlayerController? _videoController;
  PageController? _imagePageController;

  bool _isVideoInitialized = false;
  bool _showVideo = true;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _imagePageController = PageController();
  }

  void _initializeVideo() {
    final link = widget.restaurant.videoLink;
    if (link != null && link.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(link))
        ..initialize().then((_) {
          if (mounted) {
            setState(() => _isVideoInitialized = true);
            _videoController?.setLooping(true);
            _videoController?.setVolume(0.0);
            _videoController?.play();
          }
        }).catchError((e) => debugPrint("Video Init Error: $e"));
    } else {
      _showVideo = false;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _imagePageController?.dispose();
    super.dispose();
  }

  void _onGalleryImageTap(int index) {
    setState(() {
      _showVideo = false;
      _currentImageIndex = index;
      _videoController?.pause();
    });
    // Use animateToPage for a smoother transition if desired
    _imagePageController?.jumpToPage(index);
  }

  void _onPlayVideoTap() {
    setState(() => _showVideo = true);
    _videoController?.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          _buildMediaStack(size),

          _buildTopActions(restaurantProvider),

          _buildContentCard(size, theme),
        ],
      ),
    );
  }

  Widget _buildMediaStack(Size size) {
    return Container(
      height: size.height * 0.45,
      color: Colors.black,
      child: _showVideo ? _buildVideoPlayer() : _buildImageGallery(),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildImageGallery() {
    final images = widget.restaurant.images;
    if (images.isEmpty) return const Icon(Icons.image_not_supported, size: 60, color: Colors.white54);

    return Stack(
      children: [
        PageView.builder(
          controller: _imagePageController,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemCount: images.length,
          itemBuilder: (context, i) => CachedNetworkImage(
            imageUrl: images[i],
            fit: BoxFit.cover,
            placeholder: (_, __) => const Center(child: CircularProgressIndicator(color: Colors.white)),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
        if (images.length > 1) _buildImageCounter(images.length),
      ],
    );
  }

  Widget _buildImageCounter(int total) {
    return Positioned(
      bottom: 60,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          "${_currentImageIndex + 1} / $total",
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTopActions(RestaurantProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DetailActionButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () {
                provider.clearFilters();
                Navigator.pop(context);
              },
            ),
            if (!_showVideo && widget.restaurant.videoLink != null)
              DetailActionButton(icon: Icons.play_circle_outline, onTap: _onPlayVideoTap),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(Size size, AppTheme theme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height * 0.60,
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.restaurant.getName(context.locale),
                style: TextStyle(color: theme.text, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildLocationRow(theme),
              const SizedBox(height: 30),

              _buildSectionTitle('details.features'.tr(), theme),
              const SizedBox(height: 15),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _FeatureItem(icon: FontAwesomeIcons.utensils, label: 'Cuisine'),
                  _FeatureItem(icon: Icons.delivery_dining, label: 'Delivery'),
                  _FeatureItem(icon: Icons.outdoor_grill, label: 'Terrace'),
                  _FeatureItem(icon: FontAwesomeIcons.wineGlass, label: 'Bar'),
                ],
              ),
              const SizedBox(height: 30),

              if (widget.restaurant.openingHours != null) ...[
                _buildSectionTitle('details.opening_hours'.tr(), theme),
                const SizedBox(height: 12),
                _OpeningHoursWidget(theme: theme, openingHours: widget.restaurant.openingHours!),
                const SizedBox(height: 30),
              ],

              if (widget.restaurant.getDescription(context.locale)?.isNotEmpty ?? false) ...[
                _buildSectionTitle('details.about'.tr(), theme),
                const SizedBox(height: 10),
                Text(
                  widget.restaurant.getDescription(context.locale)!,
                  style: TextStyle(color: theme.text.withOpacity(0.8), fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 30),
              ],

              if (widget.restaurant.images.length > 1) ...[
                GallerySection(
                  theme: theme,
                  galleryImages: widget.restaurant.images,
                  onImageTap: _onGalleryImageTap,
                ),
                const SizedBox(height: 30),
              ],

              _ContactSection(theme: theme, restaurant: widget.restaurant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppTheme theme) {
    return Text(
      title,
      style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLocationRow(AppTheme theme) {
    return Column(
      children: [
        _infoRow(Icons.location_on_outlined, widget.restaurant.getDestinationName(context.locale), theme),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _infoRow(Icons.map_outlined, widget.restaurant.getAddress(context.locale) ?? 'N/A', theme)),
            if (widget.restaurant.lat != null)
              IconButton(
                icon: Icon(Icons.map, color: theme.primary),
                onPressed: () => openMap(context, double.tryParse(widget.restaurant.lng.toString()), double.tryParse(widget.restaurant.lat.toString())),
              ),
          ],
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text, AppTheme theme) {
    return Row(
      children: [
        Icon(icon, color: theme.primary, size: 20),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: TextStyle(color: theme.text.withOpacity(0.7), fontSize: 15))),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: theme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: theme.primary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: theme.text.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }
}

class _OpeningHoursWidget extends StatelessWidget {
  final AppTheme theme;
  final Map<String, dynamic> openingHours;
  const _OpeningHoursWidget({required this.theme, required this.openingHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.CardBG, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: openingHours.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e.key, style: TextStyle(color: theme.text.withOpacity(0.7), fontSize: 14)),
              Text(e.value.toString(), style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final AppTheme theme;
  final Restaurant restaurant;
  const _ContactSection({required this.theme, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('details.contact'.tr(), style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        if (restaurant.phone?.isNotEmpty ?? false) _contactRow(Icons.phone, restaurant.phone!, theme),
        if (restaurant.email?.isNotEmpty ?? false) _contactRow(Icons.email, restaurant.email!, theme),
        if (restaurant.website?.isNotEmpty ?? false) _contactRow(Icons.language, restaurant.website!, theme),
      ],
    );
  }

  Widget _contactRow(IconData icon, String text, AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.primary, size: 18),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: theme.text.withOpacity(0.8), fontSize: 14)),
        ],
      ),
    );
  }
}