import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/components/custom_alert_dialog.dart';
import 'package:guideme/components/post_review_bottom_sheet.dart';
import 'package:guideme/cubit/booking/booking_cubit.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/components/booking_details_bottom_sheet.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';

class BookingListScreen extends StatefulWidget {
  final bool isCustomer;
  final int page;
  final String userId;

  const BookingListScreen({
    super.key,
    required this.isCustomer,
    required this.page,
    required this.userId,
  });

  @override
  State<BookingListScreen> createState() => _BookingListState();
}

class _BookingListState extends State<BookingListScreen> {
  void fetchBookings({int? perPage}) async {
    context.read<BookingCubit>().fetchBookings(
          page: widget.page,
        );
  }

  Future<void> _showErrorAlertDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Failed to complete booking',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            'Unable to complete the booking. Please try again later.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.poppins(),
              ),
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
      ),
    );
  }

  void showConfirmCompleteDialog(String bookingId, String tourGuideId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Complete Booking?',
          description: 'Are you sure you want to complete this booking?',
          cancelButtonText: 'Cancel',
          okButtonText: 'Confirm',
          isWarning: false,
          isDelete: false,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onOk: () {
            completeBooking(bookingId, tourGuideId);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showConfirmAcceptDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Accept Booking?',
          description: 'Are you sure you want to accept this booking?',
          cancelButtonText: 'Cancel',
          okButtonText: 'Confirm',
          isWarning: false,
          isDelete: false,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onOk: () {
            acceptBooking(bookingId);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void completeBooking(String bookingId, String tourGuideId) async {
    final status = await DataService.completeBooking(bookingId);
    if (status) {
      fetchBookings();
      postTourGuideReview(tourGuideId);
    } else {
      _showErrorAlertDialog();
    }
  }

  void acceptBooking(String bookingId) async {
    final status = await DataService.acceptBooking(bookingId);
    if (status) {
      fetchBookings();
    } else {
      _showErrorAlertDialog();
    }
  }

  void postTourGuideReview(String tourGuideId) {
    showModalBottomSheet(
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio:
          0.8, // Ratio tinggi => ModalBottomSheet : Screen
      context: context,
      builder: (context) => PostReviewBottomSheet(
        tourGuideId: tourGuideId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.isCustomer.toString());
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is BookingLoaded) {
          var bookingList = state.bookingList ?? [];
          if (bookingList.isEmpty) {
            return const Center(
              child: Text('No Booking Data Yet'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
               fetchBookings(); 
              },
              child: ListView.builder(
                itemCount: bookingList.length,
                itemBuilder: (context, index) {
                  final booking = bookingList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        showBookingDetails(booking);
                      },
                      child: ListTile(
                        title: Text('Booking ID: ${booking.bookingId}'),
                        subtitle: Text(
                            'Booking Date: ${dateFormatter.format(formatDate2.parse(booking.bookingDate))}'),
                        trailing: booking.isRejected
                            ? Text(
                                'Rejected',
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              )
                            : booking.isAccepted &&
                                    !booking.isCompleted &&
                                    widget.isCustomer
                                ? ElevatedButton(
                                    onPressed: () {
                                      showConfirmCompleteDialog(
                                        booking.bookingId,
                                        booking.tourguideId,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    child: Text(
                                      'Complete',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : booking.isAccepted == false && widget.isCustomer
                                    ? Text(
                                        'Pending',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : !widget.isCustomer && !booking.isAccepted
                                        ? ElevatedButton(
                                            onPressed: () {
                                              showConfirmAcceptDialog(
                                                  booking.bookingId);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              padding: const EdgeInsets.all(10),
                                            ),
                                            child: Text(
                                              'Accept',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'Accepted',
                                            style: GoogleFonts.poppins(
                                              color: Colors.green,
                                              fontSize: 12,
                                            ),
                                          ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return const Center(
            child: Text('Error Fetchin Data'),
          );
        }
      },
    );
  }
}
