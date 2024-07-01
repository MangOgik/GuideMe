import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/book_tourguide_bottom_sheet.dart';
import 'package:guideme/cubit/comment/comment_cubit.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/screens/comment_screen.dart';

class TourGuideDetail extends StatefulWidget {
  const TourGuideDetail({super.key, required this.tourGuide});

  final TourGuide tourGuide;

  @override
  State<TourGuideDetail> createState() => _TourGuideDetailState();
}

class _TourGuideDetailState extends State<TourGuideDetail> {
  @override
  void initState() {
    super.initState();
    context.read<CommentCubit>().fetchComments(widget.tourGuide.tourguideId);
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
          'Tour Guide Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/profile.jpg'),
                        image: widget.tourGuide.imageUrl != null
                            ? NetworkImage(
                                    '${Endpoints.showImage}/${widget.tourGuide.imageUrl}')
                                as ImageProvider<Object>
                            : const AssetImage('assets/images/profile.jpg'),
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 500),
                        fadeInCurve: Curves.easeIn,
                        width: 80.0,
                        height: 80.0,
                        imageErrorBuilder: (context, error, stackTrace) {
                          debugPrint('Error: $error');
                          return Container(
                            color: Colors.grey.shade400,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      widget.tourGuide.tourguideUsername,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow[700]),
                        const SizedBox(width: 4),
                        widget.tourGuide.rating == 0
                            ? Text(
                                'Not rated yet',
                                style: GoogleFonts.poppins(fontSize: 12),
                              )
                            : Text(
                                widget.tourGuide.rating.toString(),
                                style: GoogleFonts.poppins(fontSize: 18),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.tourGuide.description,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 32,
                          ),
                          Text(
                            "Experience",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${widget.tourGuide.experience} Trip",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 32,
                          ),
                          Text(
                            "Price Rate",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\$ ${widget.tourGuide.priceRate.toInt()} / Trip",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 32,
                          ),
                          Text(
                            "Languages",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.tourGuide.language.join(", "),
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 32,
                          ),
                          Text(
                            "Location",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.tourGuide.locationName,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            // color: Colors.blue,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CommentScreen(tourGuide: widget.tourGuide),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(380, 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.blue)),
                      ),
                      child: Text(
                        'Lihat Review',
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        bookGuide(widget.tourGuide);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(380, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
