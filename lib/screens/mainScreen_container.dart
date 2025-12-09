import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/providers/destination_provider.dart';
import 'package:CarthagoGuide/providers/guestHouse_provider.dart';
import 'package:CarthagoGuide/providers/hotel_provider.dart';
import 'package:CarthagoGuide/providers/restaurant_provider.dart';
import 'package:CarthagoGuide/screens/activities_screen.dart';
import 'package:CarthagoGuide/screens/circuits_screen.dart';
import 'package:CarthagoGuide/screens/cultures_screen.dart';
import 'package:CarthagoGuide/screens/destinations_screen.dart';
import 'package:CarthagoGuide/screens/events_screen.dart';
import 'package:CarthagoGuide/screens/guestHouse_screen.dart';
import 'package:CarthagoGuide/screens/home_screen.dart';
import 'package:CarthagoGuide/screens/hotels_screen.dart';
import 'package:CarthagoGuide/screens/restaurants_screen.dart';
import 'package:CarthagoGuide/screens/sponsor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class MainScreenContainer extends StatefulWidget {
  const MainScreenContainer({super.key});

  @override
  State<MainScreenContainer> createState() => _MainScreenContainerState();
}

class _MainScreenContainerState extends State<MainScreenContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool isDrawerOpen = false;

  late Widget _currentScreen;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 250.0).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );

    _currentScreen = HomeScreen(
      onMenuTap: toggleDrawer,
      onNavigateToDestinations: _navigateToDestinations,
      onNavigateToHotels: _navigateToHotels,
      onNavigateToRestaurants: _navigateToRestaurants,
      onNavigateToCircuits: _navigateToCircuits,
    );


  }

  void toggleDrawer() {
    if (!mounted) {
      return;
    }

    if (_drawerController.isDismissed) {
      _drawerController.forward();
      setState(() => isDrawerOpen = true);
    } else {
      _drawerController.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => isDrawerOpen = false);
        }
      });
    }
  }

  void _navigateToDestinations() {
    _switchScreen(DestinationScreen(onMenuTap: toggleDrawer));
  }

  void _navigateToHotels() {
    Provider.of<HotelProvider>(context, listen: false).clearFilters();
    _switchScreen(HotelsScreen(onMenuTap: toggleDrawer));
  }

  void _navigateToRestaurants() {
    Provider.of<RestaurantProvider>(context, listen: false).clearFilters();
    _switchScreen(RestaurantScreen(onMenuTap: toggleDrawer));
  }

  void _navigateToCircuits() {
    _switchScreen(CircuitScreen(onMenuTap: toggleDrawer));
  }

  void _switchScreen(Widget newScreen) {
    setState(() {
      _currentScreen = newScreen;
    });
    if (isDrawerOpen) {
      toggleDrawer();
    }
  }


  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext context, AppTheme theme) async {
    if (isDrawerOpen) {
      toggleDrawer();
      return false;
    }

    if (Platform.isAndroid || Platform.isFuchsia) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.background,
          surfaceTintColor: theme.CardBG,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Quitter l\'application ?',
            style: TextStyle(color: theme.text, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir quitter Carthago Guide ?',
            style: TextStyle(color: theme.text),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Stay in app
              child: Text(
                'Annuler',
                style: TextStyle(color: theme.primary),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                SystemNavigator.pop();
              },
              child: const Text('Oui, Quitter'),
            ),
          ],
        ),
      );

      return false;

    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return WillPopScope(
      onWillPop: () => _onWillPop(context, theme),
      child: Scaffold(
        backgroundColor: theme.secondary,
        body: Stack(
          children: [
            CustomDrawerMenu(
              onThemeSwitch: toggleDrawer,
              toggleDrawer: toggleDrawer,
              switchScreen: _switchScreen,
            ),
            AnimatedBuilder(
              animation: _drawerController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(_slideAnimation.value)
                    ..scale(_scaleAnimation.value),
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(isDrawerOpen ? 30 : 0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: isDrawerOpen
                            ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(-10, 10),
                          )
                        ]
                            : [],
                      ),
                      child: _currentScreen,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDrawerMenu extends StatelessWidget {
  final VoidCallback? onThemeSwitch;
  final VoidCallback? toggleDrawer;
  final void Function(Widget)? switchScreen;


  const CustomDrawerMenu({
    super.key,
    this.onThemeSwitch,
    this.toggleDrawer,
    this.switchScreen
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.currentTheme;
    final textColor = theme.isSpec ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 70, bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Paramétres",
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 35),

          //menu items
          DrawerItem(
            icon: Icons.home_outlined,
            label: "Accueil",
            color: textColor,
            onTap: () {
              switchScreen?.call(HomeScreen(
                onMenuTap: toggleDrawer,
                onNavigateToDestinations: () {
                  switchScreen?.call(DestinationScreen(onMenuTap: toggleDrawer));
                },
                onNavigateToHotels: () {
                  Provider.of<HotelProvider>(context, listen: false).clearFilters();
                  switchScreen?.call(HotelsScreen(onMenuTap: toggleDrawer));
                },
                onNavigateToRestaurants: () {
                  Provider.of<RestaurantProvider>(context, listen: false).clearFilters();
                  switchScreen?.call(RestaurantScreen(onMenuTap: toggleDrawer));
                },
                onNavigateToCircuits: () {
                  switchScreen?.call(CircuitScreen(onMenuTap: toggleDrawer));
                },
              ));
            },
          ),

          DrawerItem(
              icon: Icons.place_outlined,
              label: "Destinations",
              color: textColor,
              onTap: () {
                switchScreen?.call(DestinationScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.hotel,
              label: "Hôtels",
              color: textColor,
              onTap: () {
                Provider.of<HotelProvider>(context, listen: false).clearFilters();
                switchScreen?.call(HotelsScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.apartment_outlined,
              label: "Maisons D'Hôte",
              color: textColor,
              onTap: () {
                Provider.of<GuestHouseProvider>(context, listen: false).clearFilters();
                switchScreen?.call(GuestHouseScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.restaurant_menu,
              label: "Restaurants",
              color: textColor,
              onTap: () {
                Provider.of<RestaurantProvider>(context, listen: false).clearFilters();
                switchScreen?.call(RestaurantScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.local_activity_outlined,
              label: "Activités",
              color: textColor,
              onTap: () {
                switchScreen?.call(ActivitiesScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.event_available_outlined,
              label: "Évènements",
              color: textColor,
              onTap: () {
                switchScreen?.call(EventsScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.account_balance_outlined,
              label: "Cultures",
              color: textColor,
              onTap: () {
                switchScreen?.call(CulturesScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.route_outlined,
              label: "Circuits",
              color: textColor,
              onTap: () {
                switchScreen?.call(CircuitScreen(onMenuTap: toggleDrawer));
              }
          ),

          DrawerItem(
              icon: Icons.star_border,
              label: "Sponsors",
              color: textColor,
              onTap: () {
                switchScreen?.call(SponsorScreen(onMenuTap: toggleDrawer));
              }
          ),

          const Spacer(flex: 9),

          // ----------------- Language Switch ------------------
          Row(
            children: [
              Icon(Icons.language, color: theme.primary),
              const SizedBox(width: 10),
              Text("Français",
                  style: TextStyle(color: theme.primary, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 30),

          // ----------------- Theme Switch Section ------------------
          Text(
            "Choisir Thème",
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          Row(
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () {
                  themeProvider.switchTheme(index);
                  onThemeSwitch?.call();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0
                        ? const Color(0xFF2B7EA8)
                        : index == 1
                        ? const Color(0xFFC17A3A)
                        : index == 2
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF214E34),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              );
            }),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

// items widgets
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(color: color, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}