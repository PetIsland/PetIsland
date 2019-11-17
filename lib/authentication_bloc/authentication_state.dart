part of petisland.authentication;

abstract class AuthenticationState {
  @override
  String toString() => "$runtimeType";
}

/// App init
class AuthenticationUninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

/// App no auth
class Unauthenticated extends AuthenticationState {}

/// App logout
class UnAuthenticating extends AuthenticationState {}
