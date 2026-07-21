import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/auth/domain/usecases/change_password_usecase.dart';

enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? errorMessage;

  ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordNotifier(this._changePasswordUseCase)
    : super(ChangePasswordState());

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      state = state.copyWith(
        status: ChangePasswordStatus.error,
        errorMessage: 'New passwords do not match',
      );
      return false;
    }

    state = state.copyWith(status: ChangePasswordStatus.loading);

    final result = await _changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ChangePasswordStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: ChangePasswordStatus.success);
        return true;
      },
    );
  }
}

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
      return ChangePasswordNotifier(getIt<ChangePasswordUseCase>());
    });
