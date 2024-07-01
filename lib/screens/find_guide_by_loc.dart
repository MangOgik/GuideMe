import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/book_tourguide_bottom_sheet.dart';
import 'package:guideme/cubit/tourguide/tourguide_cubit.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/screens/tourguide_detail_screen.dart';

class FindGuideByLocScreen extends StatefulWidget {
  const FindGuideByLocScreen({super.key, required this.location});

  final String location;

  @override
  State<FindGuideByLocScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<FindGuideByLocScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<TourGuideCubit>()
        .fetchTourGuides(searchQuery: widget.location, searchByLocation: true);
  }

  void refresh() {
    context
        .read<TourGuideCubit>()
        .fetchTourGuides(searchQuery: widget.location, searchByLocation: true);
  }

  void bookGuide(TourGuide tourGuide) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BookingBottomSheet(tourGuide: tourGuide);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.location}\'s Tour Guide',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TourGuideCubit>().fetchTourGuidesByRating();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<TourGuideCubit, TourGuideState>(
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
              final tourguideList = state.tourGuide?? [];
              if (tourguideList.isEmpty) {
                return Center(
                  child: Text('No Tour Guide Located at ${widget.location}'),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    refresh();
                  },
                  child: ListView.separated(
                    itemCount: tourguideList.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[300],
                      thickness: 5,
                    ),
                    itemBuilder: (context, index) {
                      final tourGuide = tourguideList[index];
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
                                                  tourGuide: tourGuide),
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
            }
            return Container();
          },
        ));
  }
}
