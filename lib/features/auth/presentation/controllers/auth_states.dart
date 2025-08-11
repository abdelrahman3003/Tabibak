abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {}

class LoginFailure extends AuthStates {}

class SignUpLoading extends AuthStates {}

class SignUpSuccess extends AuthStates {}

class SendOtpFailure extends AuthStates {}

class SendOtpLoading extends AuthStates {}

class SendOtpSuccess extends AuthStates {}

class VerifyOtpFailure extends AuthStates {}

class VerifyOtpLoading extends AuthStates {}

class VerifyOtpSuccess extends AuthStates {}

class ResetPassordFailure extends AuthStates {}

class ResetPassordLoading extends AuthStates {}

class ResetPassordSuccess extends AuthStates {}
