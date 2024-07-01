import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/services/data_services.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(const BookingInitial());

  Future<void> fetchBookings({int page = 1, int perPage = 10}) async {
    try {
      emit(const BookingLoading());
      debugPrint("Processing bookings data..");
      final userId = await DataService.getUserId();

      final List<Future<List<Booking>>> bookingFutures = [
        DataService.fetchBookings(userId!, page: page, perPage: perPage),
        DataService.fetchBookingsNotTourPlan(userId),
        DataService.fetchBookingsHistory(userId, page: page, perPage: perPage),
      ];

      // Wait for all fetches to complete
      await DataService.fetchTourPlans(userId);
      final List<List<Booking>> bookingResults =
          await Future.wait(bookingFutures);

      final List<Booking> bookings = bookingResults[0];
      final List<Booking> bookingsNotTourPlan = bookingResults[1];
      final List<Booking> bookingsHistory = bookingResults[2];

      emit(BookingLoaded(
        bookingList: bookings,
        bookingHistoryList: bookingsHistory,
        bookingNotTourplan: bookingsNotTourPlan,
      ));
    } catch (e) {
      emit(BookingError(message: 'Error fetching data $e'));
      debugPrint("Error fetched data: $e");
    }
  }
}
