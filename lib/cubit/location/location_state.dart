part of 'location_cubit.dart';

@immutable
class LocationState {
  final List<Location>? locationList;
  const LocationState({required this.locationList});
}

final class LocationInitial extends LocationState {
  const LocationInitial() : super(locationList: null);
}
