import 'package:flutter/material.dart';
import 'package:guideme/dto/activity.dart';
import 'package:guideme/dto/booking.dart';
import 'package:guideme/dto/comment.dart';
import 'package:guideme/dto/customer.dart';
import 'package:guideme/dto/location.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/dto/tourplan.dart';
import 'package:guideme/services/token_refresh_services.dart';
import 'package:guideme/utils/secure_storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:guideme/endpoints/endpoints.dart';

class DataService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const _secureStorage = SecureStorageUtil.storage;

  static Future<String?> getAccessToken() async {
    final token = await _secureStorage.read(key: 'id_token');
    return token;
  }

  static Future<String?> getUserId() async {
    final userId = await _secureStorage.read(key: 'user_id');
    return userId;
  }

  static Future<String?> getURL() async {
    final url = await _secureStorage.read(key: 'url');
    return url;
  }

  static Future<bool> getRoleIsCustomer() async {
    final role = await _secureStorage.read(key: 'role');
    if (role == 'customer') {
      return true;
    } else {
      return false;
    }
  }

  static Future<dynamic> loginFirebase(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.loginFirebase),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String?>{'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data.containsKey('id_token')) {
          // Simpan token di Secure Storage
          await _secureStorage.write(key: 'id_token', value: data['id_token']);
          await _secureStorage.write(
              key: 'user_id',
              value:
                  data['user']['customer_id'] ?? data['user']['tourguide_id']);
          await _secureStorage.write(
              key: 'role',
              value: data['user']['customer_id'] == null
                  ? 'tourguide'
                  : 'customer');

          await _auth.signInWithCustomToken(data['custom_token']);

          TokenRefreshService.start();

          return data['user'];
        } else {
          debugPrint('Unexpected data format in response');
          return null;
        }
      } else {
        debugPrint('Failed to log in: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<bool> registerCustomer({
    required String customerEmail,
    required String customerUsername,
    required String password,
    required String phoneNumber,
    required String address,
  }) async {
    final url = Uri.parse(Endpoints.registerCustomerFirebase);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'customer_email': customerEmail,
      'customer_username': customerUsername,
      'password': password,
      'phone_number': phoneNumber,
      'address': address,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        debugPrint('Register successful');
        return true;
      } else {
        debugPrint('Register failed : ${response.statusCode}');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> registerTourGuide({
    required String locationName,
    required String tourguideEmail,
    required String tourguideUsername,
    required String password,
    required String priceRate,
    required String desc,
    required List<dynamic> language,
  }) async {
    final url = Uri.parse(Endpoints.registerTourGuideFirebase);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'tourguide_email': tourguideEmail,
      'tourguide_username': tourguideUsername,
      'tourguide_password': password,
      'price_rate': priceRate,
      'description': desc,
      'language': language,
      'location_name': locationName
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        debugPrint('Register successful');
        return true;
      } else {
        debugPrint('Register failed : ${response.statusCode}');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> logoutFirebase() async {
    try {
      await _auth.signOut();
      TokenRefreshService.stop();
      await _secureStorage.deleteAll();
      debugPrint("User logged out and secure storage cleared");
    } catch (e) {
      debugPrint("Error logging out: $e");
    }
  }

  static Future<bool> verifyAccessToken(String token) async {
    final response = await http.post(
      Uri.parse(Endpoints.verifToken),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      // Token is valid
      return true;
    } else {
      // Token is invalid
      return false;
    }
  }

  static Future<List<Location>> fetchLocations() async {
    final response = await http.get(
      Uri.parse(Endpoints.location),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Location> datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => Location.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get location");
      throw Exception('Failed to load locations');
    }
  }

  static Future<List<TourGuide>> fetchTourGuides(
      {String searchQuery = '', bool searchByLocation = false}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final Uri uri = Uri.parse(Endpoints.tourguide).replace(
      queryParameters: {
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (searchByLocation) 'location': 'true',
      },
    );
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final List<TourGuide> datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => TourGuide.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get tourguides");
      throw Exception('Failed to load tourguides');
    }
  }

  static Future<List<TourGuide>> fetchTourGuidesByRating(
      {String searchQuery = '', bool searchByLocation = false}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final Uri uri = Uri.parse(Endpoints.tourguideByRating).replace(
      queryParameters: {
        if (searchQuery.isNotEmpty) 'search': searchQuery,
        if (searchByLocation) 'location': 'true',
      },
    );
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final List<TourGuide> datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => TourGuide.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get tourguides");
      throw Exception('Failed to load tourguides');
    }
  }

  static Future<List<TourPlan>> fetchTourPlans(String userId,
      {String searchQuery = ''}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final url = Uri.parse("${Endpoints.tourplan}/$userId")
        .replace(queryParameters: {'search': searchQuery});
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => TourPlan.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get tourplans");
      throw Exception('Failed to load tourplans');
    }
  }

  static Future<List<Activity>> fetchActivity(String tourPlanId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${Endpoints.activity}/$tourPlanId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => Activity.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get activity");
      throw Exception('Failed to load activity');
    }
  }

  static Future<Customer> fetchCustomer(String userId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${Endpoints.customer}/$userId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = jsonResponse['datas'] as List<dynamic>;
      if (datas.isNotEmpty) {
        return Customer.fromJson(datas[0] as Map<String, dynamic>);
      } else {
        throw Exception('No customer data found');
      }
    } else {
      debugPrint("Failed to get user data (customer)");
      throw Exception('Failed to load user data (customer)');
    }
  }

  static Future<TourGuide> fetchTourGuide(String userId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${Endpoints.tourguide}/$userId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = jsonResponse['datas'] as List<dynamic>;
      if (datas.isNotEmpty) {
        return TourGuide.fromJson(datas[0] as Map<String, dynamic>);
      } else {
        throw Exception('No tourguide data found');
      }
    } else {
      debugPrint("Failed to get user data (Tour Guide)");
      throw Exception('Failed to load user data (Tour Guide)');
    }
  }

  static Future<List<Booking>> fetchBookings(String userId,
      {int page = 1, int perPage = 2}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${Endpoints.booking}/$userId?page=$page&per_page=$perPage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => Booking.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get bookings");
      throw Exception('Failed to load bookings');
    }
  }

  static Future<List<Booking>> fetchBookingsHistory(String userId,
      {int page = 1, int perPage = 2}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse(
          "${Endpoints.bookingHistory}/$userId?page=$page&per_page=$perPage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => Booking.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get bookings history");
      throw Exception('Failed to load bookings history');
    }
  }

  static Future<List<Booking>> fetchBookingsNotTourPlan(String userId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${Endpoints.bookingNotTourplan}/$userId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(jsonResponse['datas'].toString());
      final datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => Booking.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get bookings");
      throw Exception('Failed to load bookings');
    }
  }

  static Future<void> postTourPlan(
      {required String userId,
      required String bookingId,
      required String tourPlanName,
      required DateTime tourPlanDate}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.post(
      Uri.parse(Endpoints.postTourplan),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(<String, dynamic>{
        'booking_id': bookingId,
        'customer_id': userId,
        'tourplan_name': tourPlanName,
        'tourplan_date': tourPlanDate.toIso8601String(),
      }),
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(jsonResponse['message']);
      debugPrint(jsonResponse['id_tourplan']);
    } else {
      debugPrint("Failed to post tourplan");
    }
  }

  static Future<http.Response> postActivity(
      {required String tourplanId,
      required String activityTitle,
      required String miniDesc}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.post(
      Uri.parse(Endpoints.postActivity),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(<String, dynamic>{
        'tourplan_id': tourplanId,
        'activity_title': activityTitle,
        'description': miniDesc,
      }),
    );
    if (response.statusCode == 201) {
      return response;
    } else {
      debugPrint("Failed to post activity");
      return response;
    }
  }

  static Future<bool> postBookings({required Booking booking}) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.post(
      Uri.parse(Endpoints.postBookings),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(booking.toJson()),
    );
    debugPrint(jsonEncode(booking.toJson()));
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(jsonResponse['message']);
      debugPrint(jsonResponse['id_booking']);
      return true;
    } else {
      debugPrint("Failed to book");
      return false;
    }
  }

  static Future<bool> deleteTourPlan(String tourPlanId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final url = Uri.parse('${Endpoints.deleteTourplan}/$tourPlanId');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('Failed to delete tour plan: ${response.statusCode}');
      return false;
    }
  }

  static Future<bool> deleteActivity(String activityId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final url = Uri.parse('${Endpoints.deleteActivity}/$activityId');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('Failed to delete activity: ${response.statusCode}');
      return false;
    }
  }

  static Future<bool> completeBooking(String bookingId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final url = Uri.parse('${Endpoints.completeBooking}/$bookingId');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 201) {
      debugPrint('Booking marked as complete: $bookingId');
      return true;
    } else {
      debugPrint('Failed to complete booking: ${response.body}');
      return false;
    }
  }

    static Future<bool> acceptBooking(String bookingId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final url = Uri.parse('${Endpoints.acceptBooking}/$bookingId');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 201) {
      debugPrint('Booking is accepted: $bookingId');
      return true;
    } else {
      debugPrint('Failed to accept booking: ${response.body}');
      return false;
    }
  }

  static Future<bool> completeActivity(String activityId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }

    final url = Uri.parse('${Endpoints.completeActivity}/$activityId');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      debugPrint('Activity marked as complete/not complete: $activityId');
      return true;
    } else {
      debugPrint('Failed to complete/undone activity: ${response.body}');
      return false;
    }
  }

  static Future<List<Comment>> fetchComment(String tourguideId) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse("${Endpoints.comment}/$tourguideId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final datas = (jsonResponse['datas'] as List<dynamic>)
          .map((item) => Comment.fromJson(item))
          .toList();
      return datas;
    } else {
      debugPrint("Failed to get comment data");
      throw Exception('Failed to load comment data');
    }
  }
}
