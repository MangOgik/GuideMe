import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/comment.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/services/data_services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class PostReviewBottomSheet extends StatefulWidget {
  const PostReviewBottomSheet(
      {super.key, this.comment, required this.tourGuideId});

  final Comment? comment;
  final String tourGuideId;

  @override
  State<PostReviewBottomSheet> createState() => _PostReviewBottomSheetState();
}

class _PostReviewBottomSheetState extends State<PostReviewBottomSheet> {
  final TextEditingController _descController = TextEditingController();

  double? rating;
  String? userId = '';

  File? galleryFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    userId = await DataService.getUserId();
  }

  void ratingUpdate(double userRating) {
    setState(() {
      rating = userRating;
    });
  }

  _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nothing is selected'),
            ),
          );
        }
      },
    );
  }

  Future<void> _postIssue(BuildContext context) async {
    MultipartRequest request;
    final String? token = await DataService.getAccessToken();
    if (token == null) {
      throw Exception('No access token found');
    }

    if (widget.comment != null) {
      request = MultipartRequest(
        'POST',
        Uri.parse('${Endpoints.postComment}/${widget.comment!.commentId}'),
      );
    } else {
      debugPrint('post bukan update');
      request = MultipartRequest(
        'POST',
        Uri.parse(Endpoints.postComment),
      );
    }

    request.fields['tourguide_id'] = widget.tourGuideId;
    request.fields['customer_id'] = userId!;
    request.fields['comment'] = _descController.text;
    request.fields['rating'] =
        rating != null ? rating!.toInt().toString() : 1.toString();
    request.headers['Authorization'] = token;

    if (galleryFile != null) {
      var multipartFile = await MultipartFile.fromPath(
        'img',
        galleryFile!.path,
      );
      request.files.add(multipartFile);
    }

    int statusCode = widget.comment == null ? 201 : 200;
    String message = widget.comment == null
        ? 'Review posted successfully!'
        : 'Review updated successfuly!';

    request.send().then(
      (response) {
        if (response.statusCode == statusCode) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          debugPrint('Error posting data: ${response.statusCode}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 900,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Berikan pendapat tentang Tour Guide ini!',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(
                height: 50,
                endIndent: 30,
                indent: 30,
              ),
              Text(
                'Berikan review anda!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descController,
                maxLength: 200,
                maxLines: 4,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                  hintText: "Masukkan pendapat anda..",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {},
              ),
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        _showPicker(context: context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        side: const BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.grey,
                          width: 3,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/profile.jpg'),
                          image: galleryFile != null
                              ? FileImage(galleryFile!)
                              : widget.comment?.commentImage != null
                                  ? NetworkImage(
                                          '${Endpoints.showImage}/${widget.comment!.commentImage}')
                                      as ImageProvider<Object>
                                  : const AssetImage(
                                      'assets/images/profile.jpg'),
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeInCurve: Curves.easeIn,
                          width: 120.0,
                          height: 120.0,
                          imageErrorBuilder: (context, error, stackTrace) {
                            debugPrint('Error: $error');
                            return Container(
                              color: Colors.grey.shade400,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.comment == null ? 'Tambahkan Gambar' : 'Ubah Gambar',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rate your Tour Guide!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar(
                    minRating: 1,
                    maxRating: 5,
                    allowHalfRating: false,
                    initialRating: widget.comment != null
                        ? widget.comment!.rating.toDouble()
                        : 1,
                    ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      half: const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                      ),
                      empty: const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                      ),
                    ),
                    onRatingUpdate: ratingUpdate,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    _postIssue(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    widget.comment == null ? 'Post' : 'Edit',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
