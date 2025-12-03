import 'package:cached_network_image/cached_network_image.dart';
import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 👈 NEW: Import the carousel_slider package
import 'package:carousel_slider/carousel_slider.dart';

class DestinationDetailsScreen extends StatefulWidget {
  // ... (rest of the class remains the same)

  final String title;
  final String description;
  final List<String> gallery;

  const DestinationDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.gallery,
  });

  @override
  State<DestinationDetailsScreen> createState() =>
      _DestinationDetailsScreenState();
}

class _DestinationDetailsScreenState extends State<DestinationDetailsScreen> {
  bool _isDescriptionExpanded = false;
  static const int _maxDescriptionLength = 225;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final bool _isDescriptionTooLong =
        widget.description.length > _maxDescriptionLength;

    final String displayedDescription = _isDescriptionExpanded || !_isDescriptionTooLong
        ? widget.description
        : widget.description.substring(0, _maxDescriptionLength) + '...';

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.text),
        title: Text(
          widget.title,
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: widget.gallery.length,
              itemBuilder: (context, index, realIndex) {
                final imgUrl = widget.gallery[index];
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
            const SizedBox(height: 40),
            SectionTitleWidget(title: "Hôtels", theme: theme, showMore: false),
            Icon(Icons.map_outlined, color: theme.primary, size: 50),
            const SizedBox(height: 10),
            Text(
              "Carte et Guide bientôt disponibles",
              style: TextStyle(color: theme.primary),
            ),
          ],
        ),
      ),
    );
  }
}