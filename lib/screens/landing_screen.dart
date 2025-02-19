import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GuideMe',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 250,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 37),
              height: 290,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Travel Now',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Explore the world with GuideMe, your personal guide',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 230,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login-screen');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10)),
                      child: Row(
                        children: [
                          Text(
                            'Get Started',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.keyboard_double_arrow_right_outlined, color: Colors.white, size: 30,)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
