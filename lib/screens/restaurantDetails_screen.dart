import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/models/restaurant.dart';
import 'package:CarthagoGuide/utils/open_googlemaps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.restaurant.videoLink != null && widget.restaurant.videoLink!.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.restaurant.videoLink!),
      )..initialize().then((_) {
        if (mounted) {
          setState(() => _isVideoInitialized = true);
          _videoController?.play();
          _videoController?.setLooping(true);
          _videoController?.setVolume(0.0);
        }
      }).catchError((e) {
        debugPrint("Error initializing video: $e");
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final rating = (widget.restaurant.rate is num)
        ? widget.restaurant.rate.toDouble()
        : 4.0;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.45,
            color: Colors.black,
            child: _buildMediaHeader(size),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _DetailActionButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),

          // Content Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.60,
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.restaurant.getName(Localizations.localeOf(context)),
                            style: TextStyle(
                              color: theme.text,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: theme.primary, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.restaurant.getDestinationName(context.locale),
                            style: TextStyle(
                              color: theme.text.withOpacity(0.7),
                              fontSize: 15,
                            ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.map_outlined, color: theme.primary, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.restaurant.getAddress(context.locale) ?? 'details.location_unavailable'.tr(),
                            style: TextStyle(
                              color: theme.text.withOpacity(0.7),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (widget.restaurant.lat != null && widget.restaurant.lng != null)
                          IconButton(
                            icon: Icon(Icons.map, color: theme.primary),
                            onPressed: () {
                              double? lng = double.tryParse(widget.restaurant.lng.toString());
                              double? lat = double.tryParse(widget.restaurant.lat.toString());
                              openMap(context, lng, lat);
                            },
                          ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Cuisine Features
                    Text(
                      'details.features'.tr(),
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _FeatureItem(icon: FontAwesomeIcons.utensils, label: 'details.cuisine'.tr()),
                        _FeatureItem(icon: Icons.delivery_dining, label: 'details.delivery'.tr()),
                        _FeatureItem(icon: Icons.outdoor_grill, label: 'details.terrace'.tr()),
                        _FeatureItem(icon: FontAwesomeIcons.wineGlass, label: 'details.bar'.tr()),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Opening Hours Section
                    if (widget.restaurant.openingHours != null &&
                        widget.restaurant.openingHours!.isNotEmpty) ...[
                      Text(
                        'details.opening_hours'.tr(),
                        style: TextStyle(
                          color: theme.text,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _OpeningHoursWidget(
                        theme: theme,
                        openingHours: widget.restaurant.openingHours!,
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Description
                    if (widget.restaurant.getDescription(context.locale) != null &&
                        widget.restaurant.getDescription(context.locale)!.isNotEmpty) ...[
                      Text(
                        'details.about'.tr(),
                        style: TextStyle(
                          color: theme.text,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.restaurant.getDescription(context.locale)!,
                        style: TextStyle(
                          color: theme.text.withOpacity(0.8),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Gallery Section
                    if (widget.restaurant.images.length > 1) ...[
                      _GallerySection(
                        theme: theme,
                        images: widget.restaurant.images,
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Contact Section
                    _ContactSection(theme: theme, restaurant: widget.restaurant),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaHeader(Size size) {
    if (_videoController != null && _isVideoInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    } else if (widget.restaurant.images.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.restaurant.images.first,
        width: double.infinity,
        height: size.height * 0.45,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.restaurant, size: 80, color: Colors.white54),
        ),
      );
    } else {
      return const Center(
        child: Icon(Icons.restaurant, size: 80, color: Colors.white54),
      );
    }
  }
}

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DetailActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
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
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: theme.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: theme.text.withOpacity(0.8),
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OpeningHoursWidget extends StatelessWidget {
  final AppTheme theme;
  final Map<String, dynamic> openingHours;

  const _OpeningHoursWidget({
    required this.theme,
    required this.openingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.CardBG,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.text.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: openingHours.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    color: theme.text.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: TextStyle(
                    color: theme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  final AppTheme theme;
  final List<String> images;

  const _GallerySection({
    required this.theme,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'details.gallery'.tr(),
          style: TextStyle(
            color: theme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: index < images.length - 1 ? 15 : 0),
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 40,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  final AppTheme theme;
  final Restaurant restaurant;

  const _ContactSection({
    required this.theme,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'details.contact'.tr(),
          style: TextStyle(
            color: theme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // Phone
        if (restaurant.phone != null && restaurant.phone!.isNotEmpty)
          _ContactDetailRow(
            theme: theme,
            icon: Icons.phone_outlined,
            text: restaurant.phone!,
            isLink: true,
          ),

        // Email
        if (restaurant.email != null && restaurant.email!.isNotEmpty)
          _ContactDetailRow(
            theme: theme,
            icon: Icons.email_outlined,
            text: restaurant.email!,
            isLink: true,
          ),

        // Address
        if (restaurant.address != null && restaurant.address!.isNotEmpty)
          _ContactDetailRow(
            theme: theme,
            icon: Icons.location_on_outlined,
            text: restaurant.getAddress(context.locale)!,
            isLink: false,
          ),

        // Website
        if (restaurant.website != null && restaurant.website!.isNotEmpty)
          _ContactDetailRow(
            theme: theme,
            icon: Icons.language,
            text: restaurant.website!,
            isLink: true,
          ),
      ],
    );
  }
}

class _ContactDetailRow extends StatelessWidget {
  final AppTheme theme;
  final IconData icon;
  final String text;
  final bool isLink;

  const _ContactDetailRow({
    required this.theme,
    required this.icon,
    required this.text,
    required this.isLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, color: theme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isLink ? theme.primary : theme.text.withOpacity(0.8),
                fontSize: 15,
                fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}