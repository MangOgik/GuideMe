import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:guideme/dto/location.dart';
import 'package:guideme/services/data_services.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationInitial());

  Future<void> fetchLocations() async {
    try {
      debugPrint("Processing locations data..");
      List<Location> locations;
      locations = await DataService.fetchLocations();
      debugPrint(locations.toString());
      emit(LocationState(locationList: locations));
    } catch (e) {
      debugPrint("Error fetched data: $e");
    }
  }
}

