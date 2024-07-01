import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/cubit/location/location_cubit.dart';
import 'package:guideme/cubit/tourguide/tourguide_cubit.dart';
import 'package:guideme/cubit/tourplan/tourplan_cubit.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/screens/drawer.dart';
import 'package:guideme/screens/home_screen.dart';
import 'package:guideme/screens/notifications_screen.dart';
import 'package:guideme/screens/find_guide_screen.dart';
import 'package:guideme/screens/tourplan_screen.dart';
import 'package:guideme/services/data_services.dart';

class GuideMe extends StatefulWidget {
  const GuideMe({super.key});

  @override
  State<GuideMe> createState() => _GuideMeState();
}

class _GuideMeState extends State<GuideMe> {
  int pageIndex = 0;
  String? userId = "";

  List<Widget> pageList = [
    const HomeScreen(),
    const TourPlans(),
    const FindGuide(),
  ];

  @override
  void initState() {
    super.initState();
    fetchUserId();
    BlocProvider.of<LocationCubit>(context).fetchLocations();
    BlocProvider.of<TourGuideCubit>(context).fetchTourGuides();
    BlocProvider.of<TourGuideCubit>(context).fetchTourGuidesByRating();
    BlocProvider.of<UserCubit>(context).fetchOneCustomer();
    BlocProvider.of<TourPlanCubit>(context).fetchTourPlans();
    BlocProvider.of<BookingCubit>(context).fetchBookings();
  }

  void fetchUserId() async {
    userId = await DataService.getUserId();
  }

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
                ), 
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
                  Navigator.of(context).pushNamed('/profile-screen');
                },
                icon: const Icon(
                  Icons.person,
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
