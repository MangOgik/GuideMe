import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/screens/booking_history_list_screen.dart';
import 'package:guideme/screens/booking_list_screen.dart';
import 'package:guideme/services/data_services.dart';

class BookingLogScreen extends StatefulWidget {
  const BookingLogScreen({
    super.key,
    this.isCustomer,
  });

  final bool? isCustomer;

  @override
  State<BookingLogScreen> createState() => _BookingLogScreenState();
}

class _BookingLogScreenState extends State<BookingLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int page = 1;
  int perPage = 7;
  late bool isCustomer;
  String? userId = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    isCustomer = widget.isCustomer ?? true;
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
  }

  Future<bool> setRole() async {
    final role = await DataService.getRoleIsCustomer();
    return role;
  }

  void fetchData() async {
    userId = await DataService.getUserId();
    isCustomer = await setRole();
    if (!isCustomer) {
      fetchUser();
    }
    fetchBookings();
  }

  void fetchUser() {
    context.read<UserCubit>().fetchOneTourGuide();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        page = 1;
      });
      fetchBookings();
    }
  }

  void fetchBookings() {
    debugPrint('Booking data for Booking log..');
    context.read<BookingCubit>().fetchBookings(page: page, perPage: perPage);
  }

  void nextPage() {
    setState(() {
      page++;
      fetchBookings();
    });
  }

  void previousPage() {
    if (page != 1) {
      setState(() {
        page--;
        fetchBookings();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: setRole(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching role'),
          );
        } else {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              persistentFooterAlignment: AlignmentDirectional.center,
              persistentFooterButtons: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: previousPage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      backgroundColor: Colors.blue, // button color
                      foregroundColor: Colors.white, // text color
                      shadowColor: Colors.black,
                      elevation: 5,
                    ),
                    child: Text(
                      'Previous',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Page $page',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      backgroundColor: Colors.blue, // button color
                      foregroundColor: Colors.white, // text color
                      shadowColor: Colors.black,
                      elevation: 5,
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
              appBar: isCustomer
                  ? AppBar(
                      title: Text(
                        'Booking Log',
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
                      bottom: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        tabs: const [
                          Tab(
                            child: Text('On Going'),
                          ),
                          Tab(
                            child: Text('History'),
                          ),
                        ],
                      ),
                    )
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: Container(
                        color: Colors.blue,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          labelStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          tabs: const [
                            Tab(
                              child: Text('On Going'),
                            ),
                            Tab(
                              child: Text('History'),
                            ),
                          ],
                        ),
                      ),
                    ),
              body: BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  debugPrint('Current state: $state');
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingLoaded) {
                    var bookingListHistory = state.bookingHistoryList ?? [];
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        BookingListScreen(
                          isCustomer: isCustomer,
                          page: page,
                          userId: userId!,
                        ),
                        BookingHistoryListScreen(
                          bookings: bookingListHistory,
                          isCustomer: isCustomer,
                        ),
                      ],
                    );
                  } else if (state is BookingError) {
                    return const Center(child: Text('No bookings data'));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }
}
