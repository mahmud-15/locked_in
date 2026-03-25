import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/hive_service.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/core/services/storage_service.dart';
import 'package:locked_in/core/network/local_storage.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthState {
  final AuthStatus status;
  AuthState({required this.status});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final HiveService _hive;
  final StorageService _storage;
  static const String _boxName = 'settings';
  static const String _authKey = 'is_logged_in';

  AuthNotifier(this._hive, this._storage)
    : super(AuthState(status: AuthStatus.initial)) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await _storage.read('token');
    if (token != null) {
      LocalStorage.token = token;
    }

    final isLoggedIn = await _hive.get<bool>(_boxName, _authKey);
    if (isLoggedIn == true) {
      state = AuthState(status: AuthStatus.authenticated);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login() async {
    await _hive.put<bool>(_boxName, _authKey, true);
    state = AuthState(status: AuthStatus.authenticated);
  }

  Future<void> logout() async {
    await _hive.put<bool>(_boxName, _authKey, false);
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(getIt<HiveService>(), getIt<StorageService>());
});
