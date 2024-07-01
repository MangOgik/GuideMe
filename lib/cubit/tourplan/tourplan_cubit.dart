import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guideme/dto/tourplan.dart';
import 'package:guideme/services/data_services.dart';

part 'tourplan_state.dart';

class TourPlanCubit extends Cubit<TourPlanState> {
  TourPlanCubit() : super(TourPlanInitial());

  Future<void> fetchTourPlans() async {
    final userId = await DataService.getUserId();
    try {
      debugPrint("Processing tourplans data..");
      List<TourPlan> tourPlans;
      tourPlans = await DataService.fetchTourPlans(userId!);
      emit(TourPlanState(tourPlans: tourPlans, filteredTourPlans: const []));
    } catch (e) {
      debugPrint("Error fetched data: $e");
    }
  }

   Future<void> searchTourPlans(String query) async {
    final userId = await DataService.getUserId();
    try {
      List<TourPlan> tourPlans = await DataService.fetchTourPlans(userId!, searchQuery: query);
      emit(TourPlanState(tourPlans: state.tourPlans, filteredTourPlans: tourPlans));
    } catch (e) {
      debugPrint("Error fetched data: $e");
    }
  }
}
