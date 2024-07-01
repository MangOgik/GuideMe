part of 'activity_cubit.dart';

@immutable
class ActivityState {
  final List<Activity> activityList;

  const ActivityState({required this.activityList});
}

final class ActivityInitial extends ActivityState {
  ActivityInitial() : super(activityList: []);
}
