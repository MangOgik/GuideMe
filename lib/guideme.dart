import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/page/drawer.dart';
import 'package:guideme/page/settings/settings.dart';
import 'package:guideme/page/home.dart';
import 'package:guideme/page/notifications.dart';
import 'package:guideme/page/find_guide.dart';
import 'package:guideme/page/tour_plan.dart';

class GuideMe extends StatefulWidget {
  const GuideMe({super.key});

  @override
  State<GuideMe> createState() => _GuideMeState();
}

class _GuideMeState extends State<GuideMe> {
  int pageIndex = 0;

  List<Widget> pageList = [
    const Home(),
    const TourPlans(),
    const FindGuide(),
  ];

  void navigatePage(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: pageIndex == 0 ? const DrawerContent() : null,
      appBar: switch (pageIndex) {
        0 => AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ), // Replace with your desired icon
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            backgroundColor: Colors.blue,
            title: Text(
              'GuideMe',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.blue[700]),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Notifications(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        1 => TourPlans.tourPlanAppBar,
        2 => FindGuide.findGuideAppBar,
        int() => throw UnimplementedError(),
      },
      body: pageList[pageIndex],
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        indicatorColor: Colors.blue.withOpacity(0.15),
        onDestinationSelected: navigatePage,
        selectedIndex: pageIndex,
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions),
            label: 'Tour Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Find Guide',
          ),
        ],
      ),
    );
  }
}
