part of 'tourguide_cubit.dart';

@immutable
abstract class TourGuideState {
  final List<TourGuide>? tourGuide;
  final List<TourGuide>? tourGuideByRating;

  const TourGuideState({this.tourGuide, this.tourGuideByRating});
}

class TourGuideInitial extends TourGuideState {
  const TourGuideInitial() : super();
}

class TourGuideLoading extends TourGuideState {
  const TourGuideLoading() : super();
}

class TourGuideLoaded extends TourGuideState {
  const TourGuideLoaded(
      {required List<TourGuide> tourGuide,
      required List<TourGuide> tourGuideByRating})
      : super(
          tourGuide: tourGuide,
          tourGuideByRating: tourGuideByRating,
        );
}

class TourGuideError extends TourGuideState {
  final String message;

  const TourGuideError({required this.message});
}
