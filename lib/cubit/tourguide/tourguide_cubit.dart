import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:guideme/dto/tourguide.dart';
import 'package:guideme/services/data_services.dart';

part 'tourguide_state.dart';

class TourGuideCubit extends Cubit<TourGuideState> {
  TourGuideCubit() : super(const TourGuideInitial());

  Future<void> fetchTourGuides({String searchQuery = '', bool searchByLocation = false}) async {
    emit(const TourGuideLoading());
    try {
      debugPrint("Processing all tourguides data..");
      final tourGuidesData = await DataService.fetchTourGuides(
          searchQuery: searchQuery, searchByLocation: searchByLocation);
      emit(TourGuideLoaded(
        tourGuide: tourGuidesData,
        tourGuideByRating: state.tourGuideByRating ?? [],
      ));
    } catch (e) {
      debugPrint("Error fetching all tourguide data: $e");
      emit(TourGuideError(message: e.toString()));
    }
  }

  Future<void> fetchTourGuidesByRating({String searchQuery = '', bool searchByLocation = false}) async {
    emit(const TourGuideLoading());
    try {
      debugPrint("Processing all tourguides data by rating..");
      final tourGuidesData = await DataService.fetchTourGuidesByRating(
          searchQuery: searchQuery, searchByLocation: searchByLocation);
      emit(TourGuideLoaded(
        tourGuide: state.tourGuide ?? [],
        tourGuideByRating: tourGuidesData,
      ));
    } catch (e) {
      debugPrint("Error fetching all tourguide data by rating: $e");
      emit(TourGuideError(message: e.toString()));
    }
  }
}
