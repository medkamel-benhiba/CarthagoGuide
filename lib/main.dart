import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carthago Guide',
      theme: ThemeData(
        primaryColor: theme.primary,
        scaffoldBackgroundColor: theme.background,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: theme.text,
          displayColor: theme.text,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
