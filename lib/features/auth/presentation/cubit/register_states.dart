abstract class RegisterState {}

class RegisterInitState extends RegisterState {}
class RegisterPasswordVisibilityChanged extends RegisterState {}
class RegisterConfirmPasswordVisibilityChanged extends RegisterState {}
class RegisterLoadingState extends RegisterState {}
class RegisterSuccessState extends RegisterState {}
class RegisterErrorState extends RegisterState {
  final String errorMsg;
  RegisterErrorState(this.errorMsg);
}