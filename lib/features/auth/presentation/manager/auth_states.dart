abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {}

class LoginWithGoogleLoading extends AuthStates {}

class LoginWithGoogleSuccess extends AuthStates {}

class LoginFailure extends AuthStates {}

class SignUpLoading extends AuthStates {}

class SignUpSuccess extends AuthStates {}

class SendOtpFailure extends AuthStates {}

class SendOtpLoading extends AuthStates {}

class SendOtpSuccess extends AuthStates {}

class VerifyOtpFailure extends AuthStates {}

class VerifyOtpLoading extends AuthStates {}

class VerifyOtpSuccess extends AuthStates {}

class ResetPasswordFailure extends AuthStates {}

class ResetPasswordLoading extends AuthStates {}

class ResetPasswordSuccess extends AuthStates {}

class AddUserDataLoading extends AuthStates {}

class AddUserDataSuccess extends AuthStates {}

class AddUserDataFailure extends AuthStates {}
