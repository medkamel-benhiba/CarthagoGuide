import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/screens/home_screen.dart';
import 'package:CarthagoGuide/widgets/gallery_section.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class CulturesScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const CulturesScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    final categories = [
      {"title": "Monuments", "image": "assets/images/monuments.png"},
      {"title": "Musées", "image": "assets/images/museums.png"},
      {"title": "Festival", "image": "assets/images/festival.png"},
      {"title": "Artisanat", "image": "assets/images/artisanat.png"},
    ];

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.text),
          onPressed: onMenuTap,
        ),
        title: Text(
          "Cultures",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Animation / Lottie Animation
            /*Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              child: Lottie.asset(
                'assets/animations/culture.json',
                height: 180,
                repeat: true,
              ),
            ),
*/
            const SizedBox(height: 16),

            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                height: 200,
                viewportFraction: 0.78,
              ),
              items: categories.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Découvrir la culture tunisienne",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 30),

            // Animated Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                GallerySectionWidget(
                  theme: theme,
                  galleryImages: galleryImages,
                ),
            ),
          ],
        ),
      ),
    );
  }
}
