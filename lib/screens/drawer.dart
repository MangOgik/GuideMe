import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/drawer_menu.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/dto/customer.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/screens/comment_screen.dart';
import 'package:guideme/services/data_services.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({
    super.key,
  });

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  Future<bool> setRole() async {
    final role = await DataService.getRoleIsCustomer();
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: setRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching role'),
          );
        } else {
          final isCustomer = snapshot.data ?? false;
          return Drawer(
            width: 325,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Column(
                  children: [
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is UserLoaded) {
                          final user = state.customer ?? state.tourGuide;
                          String? imageUrl;
                          if (user is Customer) {
                            imageUrl = user.imageUrl;
                          } else if (user is TourGuide) {
                            imageUrl = user.imageUrl;
                          }

                          return Row(
                            children: [
                              ClipOval(
                                clipBehavior: Clip.antiAlias,
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/images/profile.jpg'),
                                  image: imageUrl != null
                                      ? NetworkImage(
                                              '${Endpoints.showImage}/$imageUrl')
                                          as ImageProvider<Object>
                                      : const AssetImage(
                                          'assets/images/profile.jpg'),
                                  fit: BoxFit.cover,
                                  width: 70.0,
                                  height: 70.0,
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                  fadeInCurve: Curves.easeIn,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    debugPrint('Error loading image: $error');
                                    return Container(
                                      color: Colors.grey.shade400,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user is Customer
                                        ? user.customerUsername
                                        : (user as TourGuide).tourguideUsername,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                  Text(
                                    user is Customer
                                        ? user.customerEmail
                                        : (user as TourGuide).tourguideEmail,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          );
                        } else if (state is UserError) {
                          return const Center(
                              child: Text('Error loading user data'));
                        }

                        // Handle any additional states if needed
                        return const Center(child: Text('Unknown state'));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      endIndent: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                            const DrawerMenu(
                              destination: '/profile-screen',
                              icons: Icon(Icons.manage_accounts),
                              title: 'Manage Account',
                            ),
                            isCustomer
                                ? const DrawerMenu(
                                    destination: '/bookinglog-screen',
                                    icons: Icon(Icons.history),
                                    title: 'Booking Log',
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: isCustomer ? 20 : 0,
                            ),
                            !isCustomer
                                ? ListTile(
                                    onTap: () {
                                      final state =
                                          context.read<UserCubit>().state;
                                      if (state is UserLoaded) {
                                        final tourGuide = state.tourGuide;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                                tourGuide: tourGuide!),
                                          ),
                                        );
                                      } else {
                                        // Tangani kondisi di mana state bukan UserLoaded
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('User not loaded')),
                                        );
                                      }
                                    },
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.message_outlined),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Review',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.navigate_next),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Text(
                              'Support',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                            const DrawerMenu(
                              destination: '/aboutus-screen',
                              icons: Icon(Icons.error),
                              title: 'About Us',
                            ),
                            const DrawerMenu(
                              icons: Icon(Icons.logout),
                              title: 'Log Out',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
