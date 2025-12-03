import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/models/hotel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailsScreen({
    super.key,
    required this.hotel
  });

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.hotel.video_link))
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
        _videoController.setVolume(0.0);
      }).catchError((e) {
        debugPrint("Error initializing network video: $e");
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  String _stripHtmlTags(String htmlText) {
    if (htmlText.isEmpty) return '';

    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true);
    String plainText = htmlText.replaceAll(exp, '');
    plainText = plainText
        .replaceAll(RegExp(r'&[a-z]+;'), ' ')
        .replaceAll('\r\n', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll(' ', ' ')
        .replaceAll(RegExp(r' {2,}'), ' ')
        .trim();

    return plainText;
  }


  String _buildStarRating(int rating) {
    int count = rating.round().clamp(1, 5);
    return List.generate(count, (_) => '★').join() +
        List.generate(5 - count, (_) => '☆').join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.45,
            color: Colors.black,
            child: (widget.hotel.video_link.isNotEmpty)
                ? (_videoController.value.isInitialized
                ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
                : const Center(child: CircularProgressIndicator(color: Colors.white)))
                : (widget.hotel.images != null && widget.hotel.images!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                widget.hotel.images!.first,
                width: double.infinity,
                height: size.height * 0.45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 40)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
              ),
            )
                : const SizedBox.shrink()),
          ),


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DetailActionButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.hotel.name,
                            style: TextStyle(
                              color: theme.text,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    Text(
                      _buildStarRating(widget.hotel.categoryCode  ?? 0),
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Destination
                    Row(
                      children: [
                        Icon(Icons.location_on, color: theme.text, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          widget.hotel.destinationName??"",
                          style: TextStyle(
                            color: theme.text,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Gallery Section
                    _GallerySection(theme: theme, galleryImages: widget.hotel.images ?? []),

                    const SizedBox(height: 30),

                    Text(
                      "Équipements",
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _FacilityItem(icon: Icons.wifi, label: "Wifi"),
                        _FacilityItem(icon: FontAwesomeIcons.bath, label: "Spa"),
                        _FacilityItem(icon: FontAwesomeIcons.utensils, label: "Restaurant"),
                        _FacilityItem(icon: Icons.pool, label: "Piscine"),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Description Section
                    Text(
                      "Description",
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _stripHtmlTags(widget.hotel.description??""),
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Contact Information
                    _ContactSection(theme: theme,hotel: widget.hotel),

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
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

class _FacilityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FacilityItem({required this.icon, required this.label});

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
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: theme.text, fontSize: 14),
        ),
      ],
    );
  }
}

class _GallerySection extends StatelessWidget {
  final AppTheme theme;
  final List<String> galleryImages;

  const _GallerySection({required this.theme, required this.galleryImages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Galerie Photos",
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
            itemCount: galleryImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: index < galleryImages.length - 1 ? 15 : 0),
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: galleryImages[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40),
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
  final Hotel hotel;
  const _ContactSection({required this.theme,required this.hotel});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact",
          style: TextStyle(
            color: theme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        // Mail
        _ContactDetailRow(theme: theme, icon: Icons.email_outlined, text: hotel.email??"", isLink: true),

        // Phone
        _ContactDetailRow(theme: theme, icon: Icons.phone_outlined, text: hotel.phone, isLink: true),

        // Address
        _ContactDetailRow(theme: theme, icon: Icons.location_on_outlined, text: hotel.address, isLink: false),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(icon, color: theme.primary, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isLink ? theme.primary : theme.text,
                fontSize: 16,
                fontWeight: isLink ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}