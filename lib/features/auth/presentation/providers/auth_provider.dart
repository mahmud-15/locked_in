import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthState {
  final AuthStatus status;
  AuthState({required this.status});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(status: AuthStatus.initial));

  void checkAuth() {
    // Logic to check auth status (e.g. from Secure Storage)
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  void login() {
    state = AuthState(status: AuthStatus.authenticated);
  }

  void logout() {
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
