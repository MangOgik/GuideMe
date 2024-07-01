import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/edit_item.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/services/data_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController priceRate = TextEditingController();
  TextEditingController description = TextEditingController();
  String? email;
  bool isEdit = false;
  bool isCustomer = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  void fetchAll() {
    final userCubit = context.read<UserCubit>();
    final currentState = userCubit.state;

    if (currentState is UserLoaded) {
      if (currentState.customer != null) {
        setState(() {
          username.text = currentState.customer!.customerUsername;
          phoneNumber.text = currentState.customer!.phoneNumber.toString();
          email = currentState.customer!.customerEmail;
          address.text = currentState.customer!.address;
          userId = currentState.customer!.customerId;
        });
      } else if (currentState.tourGuide != null) {
        setState(() {
          userCubit.fetchOneTourGuide();
          username.text = currentState.tourGuide!.tourguideUsername;
          email = currentState.tourGuide!.tourguideEmail;
          priceRate.text = currentState.tourGuide!.priceRate.toInt().toString();
          description.text = currentState.tourGuide!.description;
          userId = currentState.tourGuide!.tourguideId;
          isCustomer = false;
        });
      }
    }
  }

  void fetchUserData() {
    if (isCustomer) {
      context.read<UserCubit>().fetchOneCustomer().then((_) {
        fetchAll();
      });
    } else {
      context.read<UserCubit>().fetchOneTourGuide().then((_) {
        fetchAll();
      });
    }
  }

  void setEdit() {
    if (isEdit) {
      _updateDataWithImage(context);
      setState(() {
        isEdit = false;
      });
    } else {
      setState(() {
        isEdit = true;
      });
    }
  }

  File? galleryFile;
  final picker = ImagePicker();

  void _showPicker({
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
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    phoneNumber.dispose();
    address.dispose();
  }

  Future<void> _updateDataWithImage(BuildContext context) async {
    final String uri;
    final String? token = await DataService.getAccessToken();
    if (token == null) {
      throw Exception('No access token found');
    }
    if (isCustomer) {
      uri = '${Endpoints.updateCustomer}/$userId';
    } else {
      uri = '${Endpoints.updateTourGuide}/$userId';
    }
    var request = MultipartRequest('PUT', Uri.parse(uri));
    request.headers['Authorization'] = token;

    if (isCustomer) {
      request.fields['customer_username'] = username.text;
      request.fields['phone_number'] = phoneNumber.text;
      request.fields['address'] = address.text;
    }

    if (!isCustomer) {
      request.fields['tourguide_username'] = username.text;
      request.fields['price_rate'] = priceRate.text;
      request.fields['description'] = description.text;
    }

    if (galleryFile != null) {
      var multipartFile = await MultipartFile.fromPath(
        'img',
        galleryFile!.path,
      );
      request.files.add(multipartFile);
    }
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        debugPrint('Data updated successfully!');
        fetchUserData(); // Ensure this function is defined and correctly implemented
      } else {
        debugPrint('Error updating data: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 45,
        width: 140,
        child: FloatingActionButton.extended(
          onPressed: () {
            setEdit();
          },
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: Icon(
            isEdit ? Icons.save_as_outlined : Icons.edit,
            size: 20,
          ),
          label: Text(
            isEdit ? 'Save Changes' : 'Edit Profile',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Profile Screen',
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
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return const Center(
              child: Text(
                'Failed to load profile..',
              ),
            );
          } else if (state is UserLoaded) {
            final userImage = isCustomer
                ? state.customer!.imageUrl
                : state.tourGuide!.imageUrl;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditItem(
                      title: "Photo",
                      widget: Column(
                        children: [
                          ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage('assets/images/profile.jpg'),
                              image: galleryFile != null
                                  ? FileImage(galleryFile!)
                                  : userImage != null
                                      ? NetworkImage(
                                              '${Endpoints.showImage}/$userImage')
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
                          isEdit
                              ? TextButton(
                                  onPressed: () {
                                    _showPicker(context: context);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.lightBlueAccent,
                                  ),
                                  child: Text(
                                    "Upload Image",
                                    style: GoogleFonts.poppins(),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EditItem(
                      title: "Email",
                      widget: Text(email ?? ''),
                    ),
                    const SizedBox(height: 40),
                    EditItem(
                      title: "Name",
                      widget: isEdit
                          ? TextField(
                              maxLength: 15,
                              controller: username,
                            )
                          : Text(username.text),
                    ),
                    const SizedBox(height: 40),
                    isCustomer
                        ? EditItem(
                            title: "Phone Number",
                            widget: isEdit
                                ? TextField(
                                    controller: phoneNumber,
                                  )
                                : Text(phoneNumber.text),
                          )
                        : const SizedBox(),
                    SizedBox(height: isCustomer ? 40 : 0),
                    isCustomer
                        ? EditItem(
                            title: "Address",
                            widget: isEdit
                                ? TextField(
                                    controller: address,
                                  )
                                : Text(address.text),
                          )
                        : const SizedBox(),
                    SizedBox(height: isCustomer ? 40 : 0),
                    !isCustomer
                        ? EditItem(
                            title: "Price Rate",
                            widget: isEdit
                                ? TextField(
                                    controller: priceRate,
                                  )
                                : Text(priceRate.text),
                          )
                        : const SizedBox(),
                    SizedBox(height: !isCustomer ? 40 : 0),
                    !isCustomer
                        ? EditItem(
                            title: "Description",
                            widget: isEdit
                                ? TextField(
                                    controller: description,
                                  )
                                : Text(description.text),
                          )
                        : const SizedBox(),
                    SizedBox(height: !isCustomer ? 40 : 0),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Unknown Error'),
            );
          }
        },
      ),
    );
  }
}
