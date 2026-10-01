import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/features/auth/presentation/cubit/register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitState());
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  bool isPasswordSecure = true;
  bool isConfirmPasswordSecure = true;
  void changePasswordSecure() {
    isPasswordSecure = !isPasswordSecure;
    emit(RegisterPasswordVisibilityChanged());
  }
  void changeConfirmPasswordSecure() {
    isConfirmPasswordSecure = !isConfirmPasswordSecure;
    emit(RegisterConfirmPasswordVisibilityChanged());
  }
}