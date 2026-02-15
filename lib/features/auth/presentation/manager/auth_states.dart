abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {}

class LoginWithGoogleLoading extends AuthStates {}

class LoginWithGoogleSuccess extends AuthStates {}

class LoginFailure extends AuthStates {
  final String error;
  LoginFailure(this.error);
}

class SignUpLoading extends AuthStates {}

class SignUpSuccess extends AuthStates {}

class SignUpFailure extends AuthStates {
  final String error;
  SignUpFailure(this.error);
}

class SendOtpFailure extends AuthStates {
  final String error;
  SendOtpFailure(this.error);
}

class SendOtpLoading extends AuthStates {}

class SendOtpSuccess extends AuthStates {}

class VerifyOtpFailure extends AuthStates {
  final String error;
  VerifyOtpFailure(this.error);
}

class VerifyOtpLoading extends AuthStates {}

class VerifyOtpSuccess extends AuthStates {}

class ResetPasswordFailure extends AuthStates {
  final String error;
  ResetPasswordFailure(this.error);
}

class ResetPasswordLoading extends AuthStates {}

class ResetPasswordSuccess extends AuthStates {}

class AddUserDataLoading extends AuthStates {}

class AddUserDataSuccess extends AuthStates {}

class AddUserDataFailure extends AuthStates {
  final String error;
  AddUserDataFailure(this.error);
}
