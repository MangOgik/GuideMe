import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/book_tourguide_bottom_sheet.dart';
import 'package:guideme/cubit/tourguide/tourguide_cubit.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/screens/tourguide_detail_screen.dart';

class FindGuide extends StatefulWidget {
  const FindGuide({super.key});

  static PreferredSizeWidget get findGuideAppBar {
    return AppBar(
      title: Text(
        'Find Guide',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 25,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      centerTitle: true,
      foregroundColor: Colors.white,
    );
  }

  @override
  State<FindGuide> createState() => _FindGuideState();
}

class _FindGuideState extends State<FindGuide> {
  bool searchFilter = false;
  bool locationFilter = false;
  bool ratingFilter = false;
  String userId = '';

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TourGuideCubit>().fetchTourGuides();
  }

  void setSearchFilter() {
    setState(() {
      if (searchFilter == false) {
        searchFilter = true;
      } else {
        searchFilter = false;
      }
    });
  }

  void setLocationFilter() {
    setState(() {
      if (!locationFilter) {
        locationFilter = true;
        if (ratingFilter) {
          context.read<TourGuideCubit>().fetchTourGuidesByRating(
                searchQuery: searchController.text,
                searchByLocation: locationFilter,
              );
        } else {
          context.read<TourGuideCubit>().fetchTourGuides(
              searchQuery: searchController.text,
              searchByLocation: locationFilter);
        }
      } else if (locationFilter) {
        locationFilter = false;
        if (ratingFilter) {
          context.read<TourGuideCubit>().fetchTourGuidesByRating(
                searchQuery: searchController.text,
                searchByLocation: locationFilter,
              );
        } else {
          context.read<TourGuideCubit>().fetchTourGuides(
                searchQuery: searchController.text,
                searchByLocation: locationFilter,
              );
        }
      }
    });
  }

  void setRatingFilter() {
    setState(() {
      if (ratingFilter == false) {
        ratingFilter = true;
        context.read<TourGuideCubit>().fetchTourGuidesByRating(
              searchQuery: searchController.text,
              searchByLocation: locationFilter,
            );
      } else {
        ratingFilter = false;
        context.read<TourGuideCubit>().fetchTourGuides(
              searchQuery: searchController.text,
              searchByLocation: locationFilter,
            );
      }
    });
  }

  void refresh() {
    context.read<TourGuideCubit>().fetchTourGuidesByRating(
          searchQuery: searchController.text,
          searchByLocation: locationFilter,
        );
    context.read<TourGuideCubit>().fetchTourGuides(
          searchQuery: searchController.text,
          searchByLocation: locationFilter,
        );
  }

  void bookGuide(TourGuide tourGuide) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BookingBottomSheet(tourGuide: tourGuide);
      },
    );
  }

  void searchTourGuide(String searchQuery) {
    if (ratingFilter) {
      context.read<TourGuideCubit>().fetchTourGuidesByRating(
            searchQuery: searchQuery,
            searchByLocation: locationFilter,
          );
    } else {
      context.read<TourGuideCubit>().fetchTourGuides(
            searchQuery: searchQuery,
            searchByLocation: locationFilter,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10) +
              const EdgeInsets.only(bottom: 14),
          height: searchFilter ? 120 : 70,
          decoration: const BoxDecoration(
            color: Colors.blue,
            // border: Border.all(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: locationFilter
                            ? 'Search by location..'
                            : 'Search here..',
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
                      onChanged: (value) {
                        searchTourGuide(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: setSearchFilter,
                    style: IconButton.styleFrom(
                      // backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(
                      Icons.tune_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              searchFilter
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Search By : ',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: OutlinedButton(
                            onPressed: setLocationFilter,
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  locationFilter ? Colors.white : null,
                              side: BorderSide(
                                  color: locationFilter
                                      ? Colors.blue
                                      : Colors.white),
                              foregroundColor:
                                  locationFilter ? Colors.blue : Colors.white,
                            ),
                            child: Text(
                              'Location',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 140,
                          height: 40,
                          child: OutlinedButton(
                            onPressed: setRatingFilter,
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  ratingFilter ? Colors.white : null,
                              side: BorderSide(
                                  color: ratingFilter
                                      ? Colors.blue
                                      : Colors.white),
                              foregroundColor:
                                  ratingFilter ? Colors.blue : Colors.white,
                            ),
                            child: Text(
                              'Highest Rating',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        Expanded(child: BlocBuilder<TourGuideCubit, TourGuideState>(
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
              final List<TourGuide>? tourGuidesList;
              if (ratingFilter) {
                tourGuidesList = state.tourGuideByRating ?? [];
              } else {
                tourGuidesList = state.tourGuide ?? [];
              }
              if (tourGuidesList.isEmpty) {
                return const Center(
                  child: Text('No Tour Guide'),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    refresh();
                  },
                  child: ListView.separated(
                    itemCount: tourGuidesList.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      final tourGuide = tourGuidesList![index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: index == 0 ? 10 : 0,
                        ),
                        height: 124,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: FadeInImage(
                                        placeholder: const AssetImage(
                                          'assets/images/profile.jpg',
                                        ),
                                        image: tourGuide.imageUrl != null
                                            ? NetworkImage(
                                                '${Endpoints.showImage}/${tourGuide.imageUrl}',
                                              ) as ImageProvider<Object>
                                            : const AssetImage(
                                                'assets/images/profile.jpg',
                                              ),
                                        fit: BoxFit.cover,
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        fadeInCurve: Curves.easeIn,
                                        width: 60.0,
                                        height: 60.0,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          debugPrint('Error: $error');
                                          return Container(
                                            color: Colors.grey.shade400,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tourGuide.tourguideUsername,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            tourGuide.rating.toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            tourGuide.locationName,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              TourGuideDetail(
                                            tourGuide: tourGuide,
                                          ),
                                        ),
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 54,
                              padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ) +
                                  const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(147, 207, 216, 220),
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Exp',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${tourGuide.experience} Trip',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(
                                    width: 30,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Price',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${tourGuide.priceRate.toInt()}\$/Trip',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(
                                    width: 30,
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Lang',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        tourGuide.language.join(', '),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      bookGuide(tourGuide);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                    ),
                                    child: Text(
                                      'Book Now',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ))
      ],
    );
  }
}
