import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guideme/services/data_services.dart';

part 'role_state.dart';

class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(const RoleInitial()) {
    fetchRole();
  }

  Future<void> fetchRole() async {
    final role = await DataService.getRoleIsCustomer();
    debugPrint('role yang didapat adalah $role');
    if (role) {
      debugPrint('role emitted isCustomer : true');
      emit(const RoleState(isCustomer: true));
    } else {
      debugPrint('role emitted isCustomer : false');
      emit(const RoleState(isCustomer: false));
    }
  }
}
