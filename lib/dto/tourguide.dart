import 'package:flutter/material.dart';

class TourGuide {
  final String tourguideId;
  final String tourguideEmail;
  final String tourguideUsername;
  final String firebaseUid;
  final String locationId;
  final String locationName;
  final double priceRate;
  final List<String> language;
  final String description;
  final String? imageUrl;
  final int? experience;
  final int? rating;

  const TourGuide({
    required this.tourguideId,
    required this.tourguideEmail,
    required this.tourguideUsername,
    required this.firebaseUid,
    required this.locationId,
    required this.locationName,
    required this.priceRate,
    required this.language,
    required this.description,
    required this.rating,
    required this.experience,
    this.imageUrl,
  });

  factory TourGuide.fromJson(Map<String, dynamic> json) {
    debugPrint(json['tourguide_image']);
    return TourGuide(
      tourguideId: json['tourguide_id'] as String,
      tourguideEmail: json['tourguide_email'] as String,
      tourguideUsername: json['tourguide_username'] as String,
      firebaseUid: json['firebase_uid'] as String,
      locationId: json['location_id'] as String,
      locationName: json['location_name'] as String,
      priceRate:
          double.parse(json['price_rate'] as String), // Ensure proper parsing
      language:
          (json['language'] as List<dynamic>).cast<String>(), // Type safety
      description: json['description'] as String,
      experience: json['experience'] as int? ?? 0, // Handle null values
      rating: json['rating'] as int? ?? 0, // Handle null values
      imageUrl: json['tourguide_image'] as String?
    );
  }
}
