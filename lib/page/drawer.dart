import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/page/settings/profile.dart';
import 'package:guideme/page/test_api.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 325,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: ListView(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/images/Ganjar.png',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mang Ogik',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          // fontWeight: FontWeight.w200,
                        ),
                      ),
                      Text(
                        'mangogik@gmail.com',
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                endIndent: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Profile',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                // tileColor: Colors.blue,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.manage_accounts),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Manage Account',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ),
              ListTile(
                // tileColor: Colors.blue,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.history),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Travel History',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Support',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
              ListTile(
                // tileColor: Colors.blue,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.support_agent),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Help Center',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ),
              ListTile(
                // tileColor: Colors.blue,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.help),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'FAQs',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ),
              ListTile(
                // tileColor: Colors.blue,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.error),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'About Us',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TestApi(),
                    ),
                  );
                },
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.api_rounded),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'API',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
