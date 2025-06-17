abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {}

class LoginFailure extends AuthStates {}

class SignUpLoading extends AuthStates {}

class SignUpSuccess extends AuthStates {}
