// lib/widgets/booking_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guideme/components/booking_details_bottom_sheet.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';
import 'package:ionicons/ionicons.dart';

class BookingHistoryListScreen extends StatefulWidget {
  final List<Booking> bookings;
  final bool isCustomer;

  const BookingHistoryListScreen(
      {super.key, required this.bookings, required this.isCustomer});

  @override
  State<BookingHistoryListScreen> createState() => _BookingListState();
}

class _BookingListState extends State<BookingHistoryListScreen> {
  void fetchBookings() async {
    context.read<BookingCubit>().fetchBookings();
  }

  Future<void> _showErrorAlertDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Failed to complete booking'),
          content: const Text(
              'Unable to complete the booking. Please try again later.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showBookingDetails(Booking booking) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) => BookingDetailsBottomSheet(
              booking: booking,
              isCustomer: widget.isCustomer,
            ));
  }

  void refresh() {
    fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookings.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: ListView.builder(
          itemCount: widget.bookings.length,
          itemBuilder: (context, index) {
            final booking = widget.bookings[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  showBookingDetails(booking);
                },
                child: ListTile(
                    title: Text('Booking ID: ${booking.bookingId}'),
                    subtitle: Text(
                        'Booking Date: ${dateFormatter.format(formatDate2.parse(booking.bookingDate))}'),
                    trailing: booking.isCompleted != true
                        ? IconButton(
                            onPressed: () async {
                              final status = await DataService.completeBooking(
                                  booking.bookingId);
                              status
                                  ? fetchBookings()
                                  : _showErrorAlertDialog();
                            },
                            icon: const Icon(
                              Ionicons.checkmark_circle,
                              color: Colors.green,
                              size: 30,
                            ))
                        : const SizedBox()),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: Text('No Booking Datass'),
      );
    }
  }
}
