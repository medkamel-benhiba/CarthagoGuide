import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/screens/destinationDetails_screen.dart';
import 'package:carthagoguide/widgets/destination_card.dart';
import 'package:carthagoguide/widgets/hotels/hotel_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/destination_provider.dart';

class DestinationScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const DestinationScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final destinationProvider = Provider.of<DestinationProvider>(context);

    final destinations = destinationProvider.filteredDestinations;

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
          "Destinations",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: destinationProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : destinationProvider.error != null
          ? Center(
        child: Text(
          destinationProvider.error!,
          style: TextStyle(color: Color(0xFF6C0606)),
        ),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(
                theme: theme,
                hint: "Rechercher une destination...",
                onChanged: (value) {
                  destinationProvider.setSearchQuery(value);
                },
              ),
              const SizedBox(height: 25),

              Text(
                "Résultats (${destinations.length})",
                style: TextStyle(
                  color: theme.text.withOpacity(0.6),
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: destinations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final d = destinations[index];
                  return DestinationCardWidget(
                    theme: theme,
                    title: d.name,
                    imgUrl: d.gallery.first ?? "assets/images/placeholder.jpg",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DestinationDetailsScreen(
                            title: d.name,
                            description: d.descriptionMobile ?? "",
                            gallery: d.gallery,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}