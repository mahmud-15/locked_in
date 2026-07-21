import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/auth/domain/usecases/login_usecase.dart';
import 'package:locked_in/features/settings/data/datasources/profile_remote_data_source.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_provider.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Nullable override
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final Ref _ref;

  LoginNotifier(this._loginUseCase, this._ref) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    final params = LoginParams(email: email, password: password);
    final result = await _loginUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) async {
        try {
          // After auth success, fetch profile to check subscription
          final profileDataSource = _ref.read(profileRemoteDataSourceProvider);
          final userProfile = await profileDataSource.getProfile();

          final isSubscribed = userProfile.subscription != null;

          _ref.read(authProvider.notifier).login(isSubscribed: isSubscribed);

          state = state.copyWith(
            isLoading: false,
            isSuccess: true,
            errorMessage: null,
          );
        } catch (e) {
          // If profile fetch fails, still login but assume not subscribed or show error
          _ref.read(authProvider.notifier).login(isSubscribed: false);
          state = state.copyWith(
            isLoading: false,
            isSuccess: true,
            errorMessage: null,
          );
        }
      },
    );
  }
}

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
      return LoginNotifier(getIt<LoginUseCase>(), ref);
    });
