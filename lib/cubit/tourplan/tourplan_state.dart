part of 'tourplan_cubit.dart';

@immutable
class TourPlanState {
  final List<TourPlan> tourPlans;
  final List<TourPlan>? filteredTourPlans;

  const TourPlanState(
      {required this.tourPlans, required this.filteredTourPlans});
}

final class TourPlanInitial extends TourPlanState {
  TourPlanInitial()
      : super(
          tourPlans: [
            TourPlan(
              bookingId: '',
              customerId: '',
              tourplanDate: DateTime.now(),
              tourplanId: '',
              tourplanName: '',
              locationName: '',
              tourguideName: '',
            )
          ],
          filteredTourPlans: [],
        );
}
