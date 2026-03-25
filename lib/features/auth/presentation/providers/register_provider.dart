import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/auth/domain/usecases/register_usecase.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? registeredEmail;

  RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.registeredEmail,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? registeredEmail,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Nullable override
      isSuccess: isSuccess ?? this.isSuccess,
      registeredEmail: registeredEmail ?? this.registeredEmail,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterNotifier(this._registerUseCase) : super(RegisterState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    final params = RegisterParams(name: name, email: email, password: password);
    final result = await _registerUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          errorMessage: null,
          registeredEmail: email,
        );
      },
    );
  }
}

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) {
    return RegisterNotifier(getIt<RegisterUseCase>());
  },
);
