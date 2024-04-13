import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/page/landing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStatePropertyAll(
            GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ),
      ),
      home: const Landing(),
    );
  }
}
