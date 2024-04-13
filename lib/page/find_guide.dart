import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/page/tourguidedetail.dart';

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
  bool destinationFilter = false;
  bool ratingFilter = false;

  void setSearchFilter() {
    setState(() {
      if (searchFilter == false) {
        searchFilter = true;
      } else {
        searchFilter = false;
      }
    });
  }

  void setDestinationFilter() {
    setState(() {
      if (destinationFilter == false) {
        destinationFilter = true;
      } else {
        destinationFilter = false;
      }
    });
  }

  void setRatingFilter() {
    setState(() {
      if (ratingFilter == false) {
        ratingFilter = true;
      } else {
        ratingFilter = false;
      }
    });
  }

  void bookGuide() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Expanded(
        child: Container(
          child: const Center(
            child: Text('Halaman Untuk Book', style: TextStyle(fontSize: 20),),
          ),
        ),
      ),
    );
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
                      decoration: InputDecoration(
                        hintText: destinationFilter
                            ? 'Search by destination..'
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
                            onPressed: setDestinationFilter,
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  destinationFilter ? Colors.white : null,
                              side: BorderSide(
                                  color: destinationFilter
                                      ? Colors.blue
                                      : Colors.white),
                              foregroundColor: destinationFilter
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            child: Text(
                              'Destination',
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
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: 124,
              decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              'assets/images/Ganjar.png',
                              fit: BoxFit.cover,
                            ),
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Karangasem',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
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
                                    const TourGuideDetail(),
                              ),
                            );
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.blue),
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
                            vertical: 5, horizontal: 10) +
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
                              '186 Hrs',
                              style: GoogleFonts.poppins(
                                // color: Colors.black,
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
                              '\$10/h',
                              style: GoogleFonts.poppins(
                                // color: Colors.black,
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
                              'Lang',
                              style: GoogleFonts.poppins(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Eng, Esp, Fr',
                              style: GoogleFonts.poppins(
                                // color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: bookGuide,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)),
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
            ),
          ),
        )
      ],
    );
  }
}
