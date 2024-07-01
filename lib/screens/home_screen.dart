import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:guideme/components/guide_card.dart';
import 'package:guideme/cubit/tourguide/tourguide_cubit.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/cubit/location/location_cubit.dart';
import 'package:guideme/dto/location.dart';
import 'package:guideme/screens/find_guide_by_loc.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/services/token_refresh_services.dart';
import 'package:guideme/utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int specialOffersIndex = 0;
  String? userId = "";

  @override
  void initState() {
    super.initState();
    fetchUserId();
    context.read<TourGuideCubit>().fetchTourGuidesByRating();
    context.read<LocationCubit>().fetchLocations();
  }

  void fetchUserId() async {
    userId = await DataService.getUserId();
  }

  void refresh() {
    context.read<LocationCubit>().fetchLocations();
    context.read<UserCubit>().fetchOneCustomer();
    context.read<TourGuideCubit>().fetchTourGuidesByRating();
  }

  void setIndicator(int index, CarouselPageChangedReason reason) {
    setState(() {
      specialOffersIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is UserLoaded) {
          final customer = state.customer;
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: ListView(
              children: [
                Container(
                  height: 190,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      )),
                  child: Column(
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            flex: 12,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search here',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              onPressed: () async {
                                await TokenRefreshService.instantRefresh();
                              },
                              style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              icon: const Icon(
                                Icons.search,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          color: Colors.blue[700],
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    'assets/images/profile.jpg'),
                                image: state.customer?.imageUrl != null
                                    ? NetworkImage(
                                            '${Endpoints.showImage}/${state.customer!.imageUrl}')
                                        as ImageProvider<Object>
                                    : const AssetImage(
                                        'assets/images/profile.jpg'),
                                fit: BoxFit.cover,
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                fadeInCurve: Curves.easeIn,
                                width: 60.0,
                                height: 60.0,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  debugPrint('Error: $error');
                                  return CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey[400],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Welcome back, ',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: customer!.customerUsername,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight
                                              .bold, // Set font weight to bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  dateFormatterHome.format(
                                    DateTime.now(),
                                  ),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 285,
                  // color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: ,
                        children: [
                          Text(
                            'Special Offers',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CarouselSlider.builder(
                        itemCount: 5,
                        itemBuilder: (context, index, realIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: 370,
                              child: Image.asset(
                                  'assets/images/pajangan${index + 1}.jpg'),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 500),
                          autoPlayInterval: const Duration(seconds: 2),
                          scrollPhysics: const BouncingScrollPhysics(),
                          viewportFraction: 1,
                          onPageChanged: setIndicator,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AnimatedSmoothIndicator(
                        effect: ExpandingDotsEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          activeDotColor: Colors.blue.withOpacity(0.8),
                        ),
                        activeIndex: specialOffersIndex,
                        count: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Locations',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.normal),
                        child: BlocBuilder<LocationCubit, LocationState>(
                          builder: (context, state) {
                            final List<Location>? locationList =
                                state.locationList;
                            if (locationList == null) {
                              return const Center(
                                child: Text(
                                  'No Location available',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              );
                            } else {
                              return Row(
                                children: locationList
                                    .map(
                                      (location) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FindGuideByLocScreen(
                                                          location: location
                                                              .locationName),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                                // backgroundColor: Colors.purpleAccent,
                                                elevation: 3,
                                                shadowColor: Colors.black,
                                                backgroundColor: Colors.white,
                                                side: const BorderSide(
                                                    color: Colors.black)),
                                            child: Text(
                                              location.locationName,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 310,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Top Guide',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<TourGuideCubit, TourGuideState>(
                        builder: (context, state) {
                          if (state is TourGuideLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is TourGuideError) {
                            return Center(
                              child: Text('Error: ${state.message}'),
                            );
                          } else if (state is TourGuideLoaded) {
                            if (state.tourGuideByRating != null &&
                                state.tourGuideByRating!.isNotEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.tourGuideByRating!.length < 5
                                      ? state.tourGuideByRating!.length
                                      : 5,
                                  itemBuilder: (context, index) => GuideCard(
                                    tourGuide: state.tourGuideByRating![index],
                                    isFirst: index == 0 ? true : false,
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 5,
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No Tour Guide Available'),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Error loading data'),
          );
        }
      },
    );
  }
}
