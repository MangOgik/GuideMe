import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/comment.dart';
import 'package:guideme/endpoints/endpoints.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/profile.jpg'),
                  image: comment.customerImage != null
                      ? NetworkImage(
                              '${Endpoints.showImage}/${comment.customerImage}')
                          as ImageProvider<Object>
                      : const AssetImage('assets/images/profile.jpg'),
                  fit: BoxFit.cover,
                  width: 40.0,
                  height: 40.0,
                  fadeInDuration: const Duration(milliseconds: 500),
                  fadeInCurve: Curves.easeIn,
                  imageErrorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading image: $error');
                    return Container(
                      color: Colors.grey.shade400,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.customerUsername,
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    comment.customerEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBar(
                    itemSize: 20,
                    ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      half: const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                      ),
                      empty: const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                    onRatingUpdate: (double rating) {},
                    ignoreGestures: true,
                    initialRating: comment.rating.toDouble(),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Review: ',
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.black45,
                      ),
                    ),
                    TextSpan(
                      text: comment.comment,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 150,
              width: 250,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/profile.jpg'),
                image: comment.commentImage != null
                    ? NetworkImage(
                            '${Endpoints.showImage}/${comment.commentImage}')
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
    );
  }
}
