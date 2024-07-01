import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/cubit/activity/activity_cubit.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/cubit/comment/comment_cubit.dart';
import 'package:guideme/cubit/role/role_cubit.dart';
import 'package:guideme/cubit/tourguide/tourguide_cubit.dart';
import 'package:guideme/cubit/tourplan/tourplan_cubit.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/guideme_alt.dart';
import 'package:guideme/screens/about_us_screen.dart';
import 'package:guideme/screens/booking_log_screen.dart';
import 'package:guideme/screens/landing_screen.dart';
import 'package:guideme/screens/login_screen.dart';
import 'package:guideme/screens/profile_screen.dart';
import 'package:guideme/cubit/location/location_cubit.dart';
import 'package:guideme/firebase_options.dart';
import 'package:guideme/guideme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:guideme/services/auth_wrapper.dart';
import 'package:guideme/services/data_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? storedBaseURL = await DataService.getURL();
  if (storedBaseURL != null) {
    Endpoints.setBaseURL(storedBaseURL);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(),
        ),
        BlocProvider<TourGuideCubit>(
          create: (context) => TourGuideCubit(),
        ),
        BlocProvider<TourPlanCubit>(
          create: (context) => TourPlanCubit(),
        ),
        BlocProvider<ActivityCubit>(
          create: (context) => ActivityCubit(),
        ),
        BlocProvider<BookingCubit>(
          create: (context) => BookingCubit(),
        ),
        BlocProvider<CommentCubit>(
          create: (context) => CommentCubit(),
        ),
        BlocProvider<RoleCubit>(
          create: (context) => RoleCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStatePropertyAll(
              GoogleFonts.poppins(
                fontSize: 12,
              ),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<bool>(
                future: DataService.getRoleIsCustomer(),
                builder: (context, roleSnapshot) {
                  context.read<RoleCubit>().fetchRole();
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (roleSnapshot.hasError) {
                    return Text('Error: ${roleSnapshot.error}');
                  } else {
                    final role = roleSnapshot.data;
                    if (role!) {
                      return const AuthWrapper(
                        child: GuideMe(),
                      );
                    } else {
                      return const AuthWrapper(
                        child: GuideMeAlt(),
                      );
                    }
                  }
                },
              );
            }
            return const LoginScreen();
          },
        ),
        routes: {
          '/landing': (context) => const Landing(),
          '/guideme-screen': (context) => const GuideMe(),
          '/guidemealt-screen': (context) => const GuideMeAlt(),
          '/profile-screen': (context) => const ProfileScreen(),
          '/login-screen': (context) => const LoginScreen(),
          '/aboutus-screen': (context) => const AboutUsScreen(),
          '/bookinglog-screen': (context) => const BookingLogScreen(),
        },
      ),
    );
  }
}
