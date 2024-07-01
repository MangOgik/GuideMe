import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/screens/tourguide_detail_screen.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({super.key, required this.tourGuide, required this.isFirst});
  final bool isFirst;

  final TourGuide tourGuide;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourGuideDetail(tourGuide: tourGuide),
          )),
      child: Padding(
        padding: EdgeInsets.only(left: isFirst ? 20 : 0),
        child: SizedBox(
          width: 200,
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 100,
                          width: 172,
                          child: FadeInImage(
                            placeholder:
                                const AssetImage('assets/images/profile.jpg'),
                            image: tourGuide.imageUrl != null
                                ? NetworkImage(
                                        '${Endpoints.showImage}/${tourGuide.imageUrl}')
                                    as ImageProvider<Object>
                                : const AssetImage('assets/images/profile.jpg'),
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeInCurve: Curves.easeIn,
                            width: 60.0,
                            height: 60.0,
                            imageErrorBuilder: (context, error, stackTrace) {
                              debugPrint('Error: $error');
                              return Container(
                                color: Colors.grey.shade400,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tourGuide.tourguideUsername,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                tourGuide.locationName,
                                style: GoogleFonts.poppins(
                                  color: Colors.black45,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.star_outlined,
                                size: 20,
                                color: Colors.yellow[700],
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              SizedBox(
                                child: Text(
                                  tourGuide.rating.toString(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    endIndent: 5,
                    indent: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '\$${tourGuide.priceRate.toInt()}/Trip',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TourGuideDetail(tourGuide: tourGuide),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              backgroundColor: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
