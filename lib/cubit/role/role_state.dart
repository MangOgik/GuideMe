part of 'role_cubit.dart';

@immutable
class RoleState {
  final bool isCustomer;
  const RoleState({required this.isCustomer});
}

final class RoleInitial extends RoleState {
  const RoleInitial() : super(isCustomer: true);
}
