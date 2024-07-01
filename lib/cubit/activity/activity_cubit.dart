import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guideme/dto/activity.dart';
import 'package:guideme/services/data_services.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  void fetchActivity(String tourPlanId) async {
    try {
      debugPrint("Processing all activity data..");
      final activityList = await DataService.fetchActivity(tourPlanId);
      emit(ActivityState(activityList: activityList));
    } catch (e) {
      debugPrint("Error fetching all activity data: $e");
    }
  }
}
