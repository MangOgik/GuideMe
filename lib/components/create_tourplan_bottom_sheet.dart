import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/cubit/tourplan/tourplan_cubit.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';

class TourPlanBottomSheet extends StatefulWidget {
  const TourPlanBottomSheet({super.key, required this.bookingList});

  final List<Booking> bookingList;

  @override
  State<TourPlanBottomSheet> createState() => _TourPlanBottomSheetState();
}

class _TourPlanBottomSheetState extends State<TourPlanBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _tourPlanNameController = TextEditingController();
  String? _selectedBookingId;
  String? id;
  String? userId = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _tourPlanNameController.dispose();
  }

  void fetchUserData() async {
    userId = await DataService.getUserId();
  }

  DateTime getTourPlanDate(String? id) {
    final date = formatDate2.parse(
        widget.bookingList.firstWhere((e) => e.bookingId == id).bookingDate);
    return date;
  }

  void _submitForm(String userId) async {
    if (_formKey.currentState!.validate()) {
      final tourPlanName = _tourPlanNameController.text;
      final tourPlanDate = getTourPlanDate(id);
      final bookingId = _selectedBookingId;

      debugPrint("$tourPlanName, $tourPlanDate, $bookingId, $userId");

      if (bookingId != null && tourPlanName.isNotEmpty) {
        // Call DataService only when bookingId and tourPlanName are valid
        await DataService.postTourPlan(
          userId: userId,
          tourPlanDate: tourPlanDate,
          bookingId: bookingId,
          tourPlanName: tourPlanName,
        ).then((value) {
          debugPrint('Tour plan submitted successfully!');
          fetchData();
        }).catchError((error) {
          debugPrint('Error submitting tour plan: $error');
        });
      }
    }
  }

  void fetchData() {
    debugPrint('Fetching data after successful submission...');
    context.read<TourPlanCubit>().fetchTourPlans();
    context.read<BookingCubit>().fetchBookings();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        setState(() {
          // This will force the widget to rebuild and fetch the latest booking data
        });
      },
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _tourPlanNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a tour plan name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.next_plan,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        label: Text(
                          'Tour Plan Name',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.book_online_outlined),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      value: _selectedBookingId,
                      hint: Text(
                        'Select Booked Date',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBookingId = newValue;
                          id = newValue;
                        });
                      },
                      items: widget.bookingList
                          .map((e) => DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: e.bookingId,
                                child: Text(
                                  '${e.tourguideUsername}, (${dateFormatter.format(formatDate2.parse(e.bookingDate))})',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.book_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Create Tour Plan',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      onPressed: () {
                        _submitForm(userId!);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10.0),
                          fixedSize: const Size(180, 50),
                          textStyle: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          backgroundColor: Colors.blue,
                          elevation: 15,
                          shadowColor: Colors.blue,
                          side:
                              const BorderSide(color: Colors.black87, width: 2),
                          alignment: Alignment.center),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
