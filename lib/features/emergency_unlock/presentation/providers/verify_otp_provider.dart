import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/emergency_unlock/domain/usecases/verify_otp_usecase.dart';

class VerifyOtpState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? successMessage;

  const VerifyOtpState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.successMessage,
  });

  VerifyOtpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? successMessage,
    bool clearError = false,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class VerifyOtpNotifier extends StateNotifier<VerifyOtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;

  VerifyOtpNotifier(this._verifyOtpUseCase) : super(const VerifyOtpState());

  Future<void> verifyOtp({
    required String appName,
    required String contactId,
    required int otp,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(appName: appName, contactId: contactId, otp: otp),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (message) => state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        successMessage: message,
      ),
    );
  }
}

final verifyOtpProvider =
    StateNotifierProvider.autoDispose<VerifyOtpNotifier, VerifyOtpState>(
      (ref) => VerifyOtpNotifier(getIt<VerifyOtpUseCase>()),
    );
