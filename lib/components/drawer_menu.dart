import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/services/data_services.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    this.destination,
    required this.icons,
    required this.title,
  });

  final String? destination;
  final String title;
  final Icon icons;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (destination != null) {
          Navigator.of(context).pushNamed(destination!);
        } else {
          DataService.logoutFirebase();
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      },
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icons,
          const SizedBox(
            width: 20,
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          const Spacer(),
          const Icon(Icons.navigate_next),
        ],
      ),
    );
  }
}