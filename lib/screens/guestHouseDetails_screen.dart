import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/models/guestHouse.dart';
import 'package:CarthagoGuide/widgets/contact_section.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestHouseDetailsScreen extends StatefulWidget {
  final GuestHouse guestHouse;

  const GuestHouseDetailsScreen({
    super.key,
    required this.guestHouse,
  });

  @override
  State<GuestHouseDetailsScreen> createState() => _GuestHouseDetailsScreenState();
}

class _GuestHouseDetailsScreenState extends State<GuestHouseDetailsScreen> {
  int _selectedImageIndex = 0;

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
    final rating = double.tryParse(widget.guestHouse.noteGoogle) ?? 0.0;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          // Main Image Gallery Section
          Container(
            height: size.height * 0.45,
            color: Colors.black,
            child: widget.guestHouse.images.isNotEmpty
                ? Stack(
              children: [
                // Main Image
                PageView.builder(
                  itemCount: widget.guestHouse.images.length,
                  onPageChanged: (index) {
                    setState(() => _selectedImageIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.guestHouse.images[index],
                      width: double.infinity,
                      height: size.height * 0.45,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image, size: 60, color: Colors.white54),
                      ),
                    );
                  },
                ),
                // Image Counter
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_selectedImageIndex + 1}/${widget.guestHouse.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
                : const Center(
              child: Icon(Icons.home_outlined, size: 80, color: Colors.white54),
            ),
          ),

          // Back Button
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
                    // Title and Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.guestHouse.name,
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

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: theme.primary, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.guestHouse.destination.name,
                            style: TextStyle(
                              color: theme.text.withOpacity(0.7),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.map_outlined, color: theme.text.withOpacity(0.5), size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.guestHouse.address,
                            style: TextStyle(
                              color: theme.text.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Amenities Section
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
                        _AmenityItem(icon: Icons.wifi, label: "WiFi"),
                        _AmenityItem(icon: Icons.restaurant_outlined, label: "Petit-déj"),
                        _AmenityItem(icon: FontAwesomeIcons.snowflake, label: "Climatisation"),
                        _AmenityItem(icon: Icons.local_parking_outlined, label: "Parking"),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Description
                    if (widget.guestHouse.description.isNotEmpty) ...[
                      Text(
                        "À propos",
                        style: TextStyle(
                          color: theme.text,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.guestHouse.description,
                        style: TextStyle(
                          color: theme.text.withOpacity(0.8),
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Contact Section
                    _ContactSection(theme: theme, guestHouse: widget.guestHouse),
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

class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityItem({required this.icon, required this.label});

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

class _ContactSection extends StatelessWidget {
  final AppTheme theme;
  final GuestHouse guestHouse;

  const _ContactSection({required this.theme, required this.guestHouse});

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
        const SizedBox(height: 15),

        // Phone
        if (guestHouse.phone.isNotEmpty)
          ContactDetailRow(
            theme: theme,
            icon: Icons.phone_outlined,
            text: guestHouse.phone,
            isLink: true,
          ),

        // Email
        if (guestHouse.email.isNotEmpty)
          ContactDetailRow(
            theme: theme,
            icon: Icons.email_outlined,
            text: guestHouse.email,
            isLink: true,
          ),

        // Address
        ContactDetailRow(
          theme: theme,
          icon: Icons.location_on_outlined,
          text: guestHouse.address,
          isLink: false,
        ),
      ],
    );
  }
}

