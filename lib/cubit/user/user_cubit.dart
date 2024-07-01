import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:guideme/dto/customer.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/services/data_services.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserInitial());

  Future<void> fetchCustomer(Map<String, dynamic> data) async {
    emit(const UserLoading());
    try {
      debugPrint("Processing customer data..");
      final customerData = Customer.fromJson(data);
      emit(UserLoaded(customer: customerData));
    } catch (e) {
      debugPrint("Error fetching customer data: $e");
      emit(const UserError("Error fetching customer data"));
    }
  }

  Future<void> fetchOneCustomer() async {
        final userId = await DataService.getUserId();
    emit(const UserLoading());
    try {
      debugPrint("Processing customer data..");
      final customerData = await DataService.fetchCustomer(userId!);
      emit(UserLoaded(customer: customerData));
    } catch (e) {
      debugPrint("Error fetching user customer: $e");
      emit(const UserError("Error fetching user customer"));
    }
  }

  Future<void> fetchOneTourGuide() async {
    emit(const UserLoading());
    final userId = await DataService.getUserId();
    try {
      debugPrint("Processing tour guide data..");
      final tourGuideData = await DataService.fetchTourGuide(userId!);
      emit(UserLoaded(tourGuide: tourGuideData));
    } catch (e) {
      debugPrint("Error fetching user tour guide: $e");
      emit(const UserError("Error fetching user tour guide"));
    }
  }

  Future<void> fetchTourGuide(Map<String, dynamic> data) async {
    emit(const UserLoading());
    try {
      debugPrint("Processing tour guide data..");
      final tourGuideData = TourGuide.fromJson(data);
      emit(UserLoaded(tourGuide: tourGuideData));
    } catch (e) {
      debugPrint("Error fetching tour guide data: $e");
      emit(const UserError("Error fetching tour guide data"));
    }
  }
}

