// lib/widgets/booking_detail.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/utils/constants.dart';

class BookingDetailsBottomSheet extends StatefulWidget {
  final Booking booking;
  final bool isCustomer;

  const BookingDetailsBottomSheet({
    super.key,
    required this.booking,
    required this.isCustomer,
  });

  @override
  State<BookingDetailsBottomSheet> createState() => _BookingDetailsBottomSheetState();
}

class _BookingDetailsBottomSheetState extends State<BookingDetailsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Details',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildDetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Booking Date:',
                value: dateFormatter
                    .format(formatDate2.parse(widget.booking.bookingDate)),
              ),
              _buildDetailRow(
                icon: Icons.attach_money_outlined,
                label: 'Total Price:',
                value: '\$${widget.booking.bookingPrice.toInt()}',
              ),
              _buildDetailRow(
                icon: widget.booking.isCompleted
                    ? Icons.check_circle_outline
                    : Icons.remove_circle_outline,
                label: 'Status:',
                value: widget.booking.isCompleted ? 'Completed' : 'Not Completed',
                valueColor: widget.booking.isCompleted ? Colors.green : Colors.red,
              ),
              widget.isCustomer? _buildDetailRow(
                icon: Icons.person_outline,
                label: 'Tour Guide:',
                value: widget.booking.tourguideUsername,
              ) : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: valueColor ?? Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  ':',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: valueColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
