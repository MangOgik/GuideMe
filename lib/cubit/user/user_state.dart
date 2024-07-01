part of 'user_cubit.dart';

@immutable
abstract class UserState {
  const UserState();
}

final class UserInitial extends UserState {
  const UserInitial();
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserLoaded extends UserState {
  final Customer? customer;
  final TourGuide? tourGuide;
  const UserLoaded({this.customer, this.tourGuide});
}

final class UserError extends UserState {
  final String error;
  const UserError(this.error);
}
