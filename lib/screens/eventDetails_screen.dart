import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _isDescriptionExpanded = false;

  String _stripHtml(String text) {
    if (text.isEmpty) return '';
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true);
    String plainText = text.replaceAll(exp, '');
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    /// COVER SELECTION
    final cover = widget.event.cover ??
        widget.event.image ??
        ""; // fallback empty

    /// PRICE
    final displayPrice = (widget.event.price == null ||
        widget.event.price == "0" ||
        widget.event.price == 0)
        ? "Gratuit"
        : "${widget.event.price} TND";

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          // TOP IMAGE
          Container(
            height: size.height * 0.45,
            color: Colors.black,
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: cover,
                fit: BoxFit.cover,
                width: double.infinity,
                height: size.height * 0.45,
                placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(color: Colors.white)),
                errorWidget: (_, __, ___) =>
                const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          ),

          // BACK BUTTON
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: _DetailActionButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),

          // BOTTOM SHEET
          _buildBottomSheet(theme, size, displayPrice),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(
      AppTheme theme, Size size, String displayPrice) {
    return Align(
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
              // Event Title
              _buildHeader(theme, displayPrice),
              const SizedBox(height: 10),

              // Price Chip (Moved here to be closer to the title, like the rating in HotelDetailsScreen)
              _buildPriceChip(theme, displayPrice),
              const SizedBox(height: 10),

              // Date and Time
              _buildDateTime(theme),
              const SizedBox(height: 10),

              // Location
              _buildLocation(theme),
              const SizedBox(height: 30),

              // Description Section
              _buildDescription(theme),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppTheme theme, String displayPrice) {
    return Text(
      widget.event.title,
      style: TextStyle(
        color: theme.text,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPriceChip(AppTheme theme, String displayPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayPrice,
        style: TextStyle(
          color: theme.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateTime(AppTheme theme) {
    return Row(
      children: [
        Icon(Icons.event, color: theme.text, size: 18),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            widget.event.startDate ?? "Date non disponible",
            style: TextStyle(color: theme.text, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(AppTheme theme) {
    return Row(
      children: [
        Icon(Icons.location_on, color: theme.text, size: 18),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            widget.event.address ?? "Lieu non disponible",
            style: TextStyle(color: theme.text, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(AppTheme theme) {
    final fullText = _stripHtml(widget.event.description ?? "");
    final truncatedText =
    fullText.length > 220 ? fullText.substring(0, 220) + "..." : fullText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
            color: theme.text,
            fontSize: 20,
            fontWeight: FontWeight.bold, // Same as hotel section titles
          ),
        ),
        const SizedBox(height: 10),

        Text(
          _isDescriptionExpanded ? fullText : truncatedText,
          style: TextStyle(
            color: theme.text,
            fontSize: 16,
            height: 1.5,
          ),
        ),

        if (fullText.length > 220)
          GestureDetector(
            onTap: () =>
                setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0), // Spacing like hotel description
              child: Text(
                _isDescriptionExpanded ? "Afficher moins" : "Afficher plus",
                style: TextStyle(
                    color: theme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

// Re-used from HotelDetailsScreen
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
