import 'package:flutter/material.dart';

class Customer {
  final String customerId;
  final String customerUsername;
  final String customerEmail;
  final String phoneNumber;
  final String address;
  final String firebaseUid;
  final String? imageUrl;

  const Customer({
    required this.customerId,
    required this.customerUsername,
    required this.customerEmail,
    required this.phoneNumber,
    required this.address,
    required this.firebaseUid,
    required this.imageUrl,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    debugPrint(json['customer_image']);
    return Customer(
      customerId: json['customer_id'],
      customerUsername: json['customer_username'],
      customerEmail: json['customer_email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      // birthDate: DateTime.parse(json['birth_date']),
      firebaseUid: json['firebase_uid'],
      imageUrl: json['customer_image'],
    );
  }
}
