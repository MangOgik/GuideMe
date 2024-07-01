import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/create_tourplan_bottom_sheet.dart';
import 'package:guideme/components/custom_alert_dialog.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/cubit/tourplan/tourplan_cubit.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/dto/tourplan.dart';
import 'package:guideme/screens/tourplan_detail_screen.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class TourPlans extends StatefulWidget {
  const TourPlans({super.key, this.isCustomer});
  final bool? isCustomer;

  static PreferredSizeWidget get tourPlanAppBar {
    return AppBar(
      title: Text(
        'Tour Plan',
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
  State<TourPlans> createState() => _TourPlansState();
}

class _TourPlansState extends State<TourPlans> {
  DateTime? pickedDate;
  List<Booking>? bookingList;
  late bool isCustomer;
  String? userId = '';

  final tourNameController = TextEditingController();
  final locationController = TextEditingController();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isCustomer = widget.isCustomer ?? true;
    fetchUserId();
    fetchAll();
  }

  void fetchUserId() async {
    userId = await DataService.getUserId();
  }

  void fetchAll() {
    context.read<TourPlanCubit>().fetchTourPlans();
    context.read<BookingCubit>().fetchBookings();
  }

  @override
  void dispose() {
    super.dispose();
    tourNameController.dispose();
    locationController.dispose();
  }



  void pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      initialDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        this.pickedDate = pickedDate;
      });
    }
  }

  void addTourPlan() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => TourPlanBottomSheet(
        bookingList:
            context.read<BookingCubit>().state.bookingListNotTourPlan ?? [],
      ),
    );
    fetchAll();
  }

    void _showNoBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'No Tour Guide Available',
          description: 'You have no available Tour Guide. \n Please book a Tour Guide first!',
          cancelButtonText: 'Cancel',
          okButtonText: 'OK',
          isWarning: true,
          isDelete: false,
          onCancel: () {},
          onOk: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showConfirmDialog(String idTourplan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Delete Tour Plan?',
          description: 'Are you sure you want to delete this tour plan?',
          cancelButtonText: 'Cancel',
          okButtonText: 'Delete',
          isWarning: false,
          isDelete: true,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onOk: () {
            deleteTourPlan(idTourplan);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tour Plan Deleted'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  void deleteTourPlan(String idTourplan) async {
    await DataService.deleteTourPlan(idTourplan);
    fetchAll();
  }

  void searchTourPlan(String searchQuery) {
    context.read<TourPlanCubit>().searchTourPlans(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isCustomer
          ? SizedBox(
              height: 45,
              width: 140,
              child: FloatingActionButton.extended(
                onPressed: () {
                  final bookingListNotTourPlan =
                      context.read<BookingCubit>().state.bookingListNotTourPlan;
                  if (bookingListNotTourPlan != null &&
                      bookingListNotTourPlan.isNotEmpty) {
                    addTourPlan();
                  } else {
                    _showNoBookingDialog();
                  }
                },
                backgroundColor: Colors.blue[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                icon: const Icon(
                  Icons.add,
                  size: 20,
                ),
                label: Text(
                  'Add Tour Plan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : null,
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10) +
                  const EdgeInsets.only(bottom: 14),
              height: 70,
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search here',
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
                      onChanged: (value) {
                        searchTourPlan(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {
                        searchTourPlan(searchController.text);
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<TourPlanCubit, TourPlanState>(
              builder: (context, state) {
                final List<TourPlan>? tourPlans;
                if (searchController.text.isNotEmpty) {
                  tourPlans = state.filteredTourPlans;
                } else {
                  tourPlans = state.tourPlans;
                }
                if (tourPlans!.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 300),
                    child: const Text('You have no tour plans yet'),
                  );
                } else {}
                return Expanded(
                  child: ListView.separated(
                    itemCount: tourPlans.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      final tourPlan = tourPlans![index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TourPlanDetailScreen(
                              tourPlan: tourPlan,
                              isCustomer: isCustomer,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: index == tourPlans.length - 1 ? 80 : 0,
                          ),
                          child: Slidable(
                            enabled: isCustomer,
                            endActionPane: ActionPane(
                              extentRatio: 0.25,
                              motion: const ScrollMotion(),
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            showConfirmDialog(
                                                tourPlan.tourplanId);
                                          },
                                          flex: 1,
                                          icon: Icons.delete,
                                          backgroundColor: Colors.red,
                                          label: 'Delete',
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          padding: const EdgeInsets.all(15),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              height: 90,
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 217, 217, 217),
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Icon(
                                        Icons.flag,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        tourPlan.tourplanName,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
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
                                            tourPlan.locationName,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black45,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.calendar_month_outlined,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            // 'Monday, April 8th, 2024',
                                            dateFormatter
                                                .format(tourPlan.tourplanDate),
                                            style: GoogleFonts.poppins(
                                              color: Colors.black45,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
