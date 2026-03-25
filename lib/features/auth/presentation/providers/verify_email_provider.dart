import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:locked_in/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_provider.dart';

class VerifyEmailState {
  final bool isLoading;
  final bool isResending;
  final String? errorMessage;
  final String? resendMessage;
  final bool isSuccess;

  VerifyEmailState({
    this.isLoading = false,
    this.isResending = false,
    this.errorMessage,
    this.resendMessage,
    this.isSuccess = false,
  });

  VerifyEmailState copyWith({
    bool? isLoading,
    bool? isResending,
    String? errorMessage,
    String? resendMessage,
    bool? isSuccess,
  }) {
    return VerifyEmailState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      errorMessage: errorMessage, // Nullable override
      resendMessage: resendMessage, // Nullable override
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final Ref _ref;

  VerifyEmailNotifier(
    this._verifyEmailUseCase,
    this._resendOtpUseCase,
    this._ref,
  ) : super(VerifyEmailState());

  Future<void> verify({
    required String email,
    required String oneTimeCode,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    final params = VerifyEmailParams(email: email, oneTimeCode: oneTimeCode);
    final result = await _verifyEmailUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) {
        _ref.read(authProvider.notifier).login();
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> resendOtp(String email) async {
    state = state.copyWith(
      isResending: true,
      resendMessage: null,
      errorMessage: null,
    );

    final result = await _resendOtpUseCase(email);

    result.fold(
      (failure) {
        state = state.copyWith(
          isResending: false,
          errorMessage: failure.message,
        ); // Will act as an error
      },
      (_) {
        state = state.copyWith(
          isResending: false,
          resendMessage: "OTP sent successfully",
        );
      },
    );
  }
}

final verifyEmailProvider =
    StateNotifierProvider.autoDispose<VerifyEmailNotifier, VerifyEmailState>((
      ref,
    ) {
      return VerifyEmailNotifier(
        getIt<VerifyEmailUseCase>(),
        getIt<ResendOtpUseCase>(),
        ref,
      );
    });
