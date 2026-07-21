import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/hive_service.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/core/services/storage_service.dart';
import 'package:locked_in/core/network/local_storage.dart';
import 'package:locked_in/core/services/logger_service.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthState {
  final AuthStatus status;
  final bool isSubscribed;

  AuthState({
    required this.status,
    this.isSubscribed = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isSubscribed,
  }) {
    return AuthState(
      status: status ?? this.status,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final HiveService _hive;
  final StorageService _storage;
  static const String _boxName = 'settings';
  static const String _authKey = 'is_logged_in';
  static const String _subKey = 'is_subscribed';

  AuthNotifier(this._hive, this._storage)
    : super(AuthState(status: AuthStatus.initial));

  Future<void> checkAuth() async {
    try {
      final token = await _storage.read('token');
      if (token != null) {
        LocalStorage.token = token;
      }

      final isLoggedIn = await _hive.get<bool>(_boxName, _authKey);
      final isSubscribed = await _hive.get<bool>(_boxName, _subKey) ?? false;
      if (isLoggedIn == true) {
        state = AuthState(status: AuthStatus.authenticated, isSubscribed: isSubscribed);
      } else {
        state = AuthState(status: AuthStatus.unauthenticated, isSubscribed: false);
      }
    } catch (e, stack) {
      LoggerService.e('Failed to check auth status', e, stack);
      state = AuthState(status: AuthStatus.unauthenticated, isSubscribed: false);
    }
  }

  Future<void> login({bool isSubscribed = false}) async {
    await _hive.put<bool>(_boxName, _authKey, true);
    await _hive.put<bool>(_boxName, _subKey, isSubscribed);
    state = AuthState(status: AuthStatus.authenticated, isSubscribed: isSubscribed);
  }

  Future<void> updateSubscriptionStatus(bool isSubscribed) async {
    await _hive.put<bool>(_boxName, _subKey, isSubscribed);
    state = state.copyWith(isSubscribed: isSubscribed);
  }

  Future<void> logout() async {
    await _hive.put<bool>(_boxName, _authKey, false);
    await _hive.put<bool>(_boxName, _subKey, false);
    state = AuthState(status: AuthStatus.unauthenticated, isSubscribed: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(getIt<HiveService>(), getIt<StorageService>());
});
