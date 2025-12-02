import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dummy data for Sponsors
final List<Map<String, String>> majorSponsors = [
  {"name": "Ministère du Tourisme", "logo": "assets/images/logo_min.png"},
  {"name": "Agil", "logo": "assets/images/agil.png"},
];

final List<Map<String, String>> partners = [
  {"name": "Hôtel Joya paradise and Spa", "logo": "assets/images/logo_hotelx.png"},
  {"name": "Agence TGT", "logo": "assets/images/logo_agency.png"},
  {"name": "Restaurant L'étoile Rouge ", "logo": "assets/images/logo_restoz.png"},
];

class SponsorLogoWidget extends StatelessWidget {
  final AppTheme theme;
  final String logoPath;
  final String name;

  const SponsorLogoWidget({
    super.key,
    required this.theme,
    required this.logoPath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.secondary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: theme.text.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name[0], // Use first letter as placeholder
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: theme.primary.withOpacity(0.6)),
            ),
          ),
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.text.withOpacity(0.8), fontSize: 14),
        ),
      ],
    );
  }
}

class SponsorScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const SponsorScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

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
          "Nos Sponsors",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Major Sponsors Section
              SectionTitleWidget(title: "Sponsors Officiels", theme: theme),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.3,
                ),
                itemCount: majorSponsors.length,
                itemBuilder: (context, index) {
                  final sponsor = majorSponsors[index];
                  return SponsorLogoWidget(
                    theme: theme,
                    name: sponsor["name"]!,
                    logoPath: sponsor["logo"]!,
                  );
                },
              ),
              const SizedBox(height: 40),

              // Partners Section
              SectionTitleWidget(title: "Partenaires Locaux", theme: theme),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.6,
                ),
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  final partner = partners[index];
                  return SponsorLogoWidget(
                    theme: theme,
                    name: partner["name"]!,
                    logoPath: partner["logo"]!,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}