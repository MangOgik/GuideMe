class Booking {
  final String bookingDate;
  final String bookingId;
  final double bookingPrice;
  final String customerId;
  final bool isCompleted;
  final bool isRejected;
  final bool isAccepted;
  final String tourguideId;
  final String tourguideUsername;

  Booking({
    required this.bookingDate,
    required this.bookingId,
    required this.bookingPrice,
    required this.customerId,
    required this.isCompleted,
    required this.isRejected,
    required this.isAccepted,
    required this.tourguideId,
    required this.tourguideUsername,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingDate: json['booking_date'] as String,
      bookingId: json['booking_id'] as String,
      bookingPrice: double.parse(json['booking_price']),
      customerId: json['customer_id'] as String,
      isCompleted: json['is_completed'] == 1 ? true : false,
      isRejected: json['is_rejected'] == 1 ? true : false,
      isAccepted: json['is_accepted'] == 1 ? true : false,
      tourguideId: json['tourguide_id'] as String,
      tourguideUsername: json['tourguide_username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_date': bookingDate,
      'booking_id': bookingId,
      'booking_price': bookingPrice.toString(),
      'customer_id': customerId,
      'tourguide_id': tourguideId,
      'tourguide_username': tourguideUsername,
    };
  }
}
