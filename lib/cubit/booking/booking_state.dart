// booking_state.dart
part of 'booking_cubit.dart';

@immutable
abstract class BookingState {
  final List<Booking>? bookingList;
  final List<Booking>? bookingListNotTourPlan;
  final List<Booking>? bookingHistoryList;
  final String? message;

  const BookingState({this.bookingList, this.bookingHistoryList, this.message, this.bookingListNotTourPlan});
}

final class BookingInitial extends BookingState {
  const BookingInitial() : super();
}

final class BookingLoading extends BookingState {
  const BookingLoading() : super();
}

final class BookingLoaded extends BookingState {
  const BookingLoaded({
    required List<Booking> bookingList,
    required List<Booking> bookingHistoryList,
    required List<Booking> bookingNotTourplan
  }) : super(bookingList: bookingList, bookingHistoryList: bookingHistoryList, bookingListNotTourPlan: bookingNotTourplan);
}

final class BookingError extends BookingState {
  const BookingError({required String message}) : super(message: message);
}
