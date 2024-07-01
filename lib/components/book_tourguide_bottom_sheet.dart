import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/custom_alert_dialog.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/cubit/tourguide/tourguide_cubit.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';

class BookingBottomSheet extends StatefulWidget {
  const BookingBottomSheet({super.key, required this.tourGuide});

  final TourGuide tourGuide;

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime? _selectedDate;
  String? userId = "";

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  void fetchUserId() async {
    userId = await DataService.getUserId();
  }

  void _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
      initialDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void showError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Date Selected'),
          content: const Text('Please choose a date to proceed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDateNotAvailable() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Date Already Booked',
          description:
              'This tour guide is already booked on this date. \n Please choose another date.',
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

  void bookingSuccess() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking Requested'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    context.read<TourGuideCubit>().fetchTourGuides();
    context.read<BookingCubit>().fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: widget.tourGuide.imageUrl != null
                    ? NetworkImage(
                            '${Endpoints.showImage}/${widget.tourGuide.imageUrl}')
                        as ImageProvider<Object>
                    : const AssetImage('assets/images/profile.jpg')
                        as ImageProvider<Object>,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tourGuide.tourguideUsername,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.tourGuide.locationName,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Date :',
                style: GoogleFonts.poppins(),
              ),
              ElevatedButton(
                onPressed: _selectDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.grey.shade400, width: 0.5),
                  fixedSize: const Size(150, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                    const VerticalDivider(
                      width: 14,
                      endIndent: 7,
                      indent: 7,
                    ),
                    Text(
                      _selectedDate != null
                          ? dateFormatter2.format(_selectedDate!)
                          : 'Select Date',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        // fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price:',
                style: GoogleFonts.poppins(),
              ),
              Text('${widget.tourGuide.priceRate.toInt()}\$',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (_selectedDate == null) {
                showError();
              } else {
                final status = await DataService.postBookings(
                  booking: Booking(
                    bookingDate: _selectedDate!.toIso8601String(),
                    bookingId: '',
                    bookingPrice: widget.tourGuide.priceRate,
                    customerId: userId!,
                    isCompleted: false,
                    isAccepted: false,
                    isRejected: false,
                    tourguideId: widget.tourGuide.tourguideId,
                    tourguideUsername: widget.tourGuide.tourguideUsername,
                  ),
                );
                if (status) {
                  bookingSuccess();
                } else {
                  _showDateNotAvailable();
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                fixedSize: const Size(380, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text(
              'Book Now',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
