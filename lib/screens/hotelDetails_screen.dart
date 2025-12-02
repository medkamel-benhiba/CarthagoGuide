import 'package:carthagoguide/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

// Dummy data for the gallery section
const List<String> dummyGalleryImages = [
  "assets/images/joya1.jpg",
  "assets/images/joya2.jpg",
  "assets/images/joya3.jpg",
  "assets/images/joya4.jpg",
];

class HotelDetailsScreen extends StatefulWidget {
  final String title;
  final String destination;
  final String imgUrl; // Used here for the video path
  final double rating;
  final double price;

  const HotelDetailsScreen({
    super.key,
    required this.title,
    required this.destination,
    required this.imgUrl,
    required this.rating,
    required this.price,
  });

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  late VideoPlayerController _videoController;
  final String videoAssetPath = "assets/videos/joya.mp4";

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(videoAssetPath)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
        _videoController.setVolume(0.0);
      }).catchError((e) {
        print("Error initializing video: $e");
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  // Helper method to build the star rating string (e.g., ★★★☆☆)
  String _buildStarRating(double rating) {
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
          // --- 1. Background Video (Hero Section) ---
          Container(
            height: size.height * 0.45,
            color: Colors.black, // Background color while video loads
            child: _videoController.value.isInitialized
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
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),

          // --- 2. Floating Action Buttons and Back Button ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  _DetailActionButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  /*// Favorite Button
                  _DetailActionButton(
                    icon: Icons.favorite_border,
                    onTap: () {
                      // Handle favorite toggle
                    },
                  ),*/
                ],
              ),
            ),
          ),

          // --- 3. Hotel Details Card (Scrollable Content) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.65,
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Rating Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: theme.text,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Displaying Rating number
                        /*Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                            const SizedBox(width: 5),
                            Text(
                              widget.rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: theme.text,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Stars Rating (e.g., *****)
                    Text(
                      _buildStarRating(widget.rating),
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
                          widget.destination,
                          style: TextStyle(
                            color: theme.text,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Gallery Section
                    _GallerySection(theme: theme),

                    const SizedBox(height: 30),

                    // Facilities Section
                    Text(
                      "Équipements",
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Facilities List
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
                      "Le ${widget.title} offre une expérience de luxe inégalée. Situé à ${widget.destination}, il combine l'élégance moderne avec le charme local. Profitez de nos chambres spacieuses, d'un service exceptionnel et d'une vue imprenable. Idéal pour une escapade relaxante ou un voyage d'affaires.",
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Contact Information
                    _ContactSection(theme: theme),
                  ],
                ),
              ),
            ),
          ),

          /*// --- 4. Fixed Bottom Bar (Price and Booking) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: theme.background,
                border: Border(
                  top: BorderSide(color: theme.text.withOpacity(0.1), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "À partir de",
                        style: TextStyle(
                          color: theme.text.withOpacity(0.7), // Use reduced opacity for label
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${widget.price.toStringAsFixed(0)} TND / Nuit",
                        style: TextStyle(
                          color: theme.text,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Booking Button
                  /*ElevatedButton(
                    onPressed: () {
                      // Handle booking action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Réserver",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}

// --- REUSABLE WIDGETS ---

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
  final AppTheme theme; // Using AppTheme as per your code
  const _GallerySection({required this.theme});

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
            itemCount: dummyGalleryImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: index < dummyGalleryImages.length - 1 ? 15 : 0),
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    dummyGalleryImages[index],
                    fit: BoxFit.cover,
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
  const _ContactSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    // Dummy Contact Data
    const String mail = "resa.joya@topnet.tn";
    const String phone = "+216 75 730 352";
    const String address = "Zone Touristique BP 357 - 4116 Djerba Midoun";

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
        _ContactDetailRow(theme: theme, icon: Icons.email_outlined, text: mail, isLink: true),

        // Phone
        _ContactDetailRow(theme: theme, icon: Icons.phone_outlined, text: phone, isLink: true),

        // Address
        _ContactDetailRow(theme: theme, icon: Icons.location_on_outlined, text: address, isLink: false),
      ],
    );
  }
}

class _ContactDetailRow extends StatelessWidget {
  final AppTheme theme; // Using AppTheme as per your code
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