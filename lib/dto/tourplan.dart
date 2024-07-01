import 'package:guideme/utils/constants.dart';

class TourPlan {
  final String bookingId;
  final String customerId;
  final DateTime tourplanDate;
  final String tourplanId;
  final String tourplanName;
  final String locationName;
  final String tourguideName;

  TourPlan({
    required this.bookingId,
    required this.customerId,
    required this.tourplanDate,
    required this.tourplanId,
    required this.tourplanName,
    required this.locationName,
    required this.tourguideName,
  });

  factory TourPlan.fromJson(Map<String, dynamic> json) {
    return TourPlan(
      bookingId: json['booking_id'],
      customerId: json['customer_id'],
      tourplanDate: formatDate2.parse(json['tourplan_date']),
      tourplanId: json['tourplan_id'],
      tourplanName: json['tourplan_name'],
      locationName: json['location_name'],
      tourguideName: json['tourguide_username'],
    );
  }

  // Method to convert a TourPlanDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'customer_id': customerId,
      'tourplan_date': tourplanDate.toIso8601String(),
      'tourplan_id': tourplanId,
      'tourplan_name': tourplanName,
    };
  }
}
