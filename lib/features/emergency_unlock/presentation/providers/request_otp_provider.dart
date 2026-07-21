import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/emergency_unlock/domain/usecases/request_otp_usecase.dart';

class RequestOtpState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? successMessage;

  const RequestOtpState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.successMessage,
  });

  RequestOtpState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? successMessage,
    bool clearError = false,
  }) {
    return RequestOtpState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class RequestOtpNotifier extends StateNotifier<RequestOtpState> {
  final RequestOtpUseCase _requestOtpUseCase;

  RequestOtpNotifier(this._requestOtpUseCase) : super(const RequestOtpState());

  Future<void> sendRequest({
    required String appName,
    required String contactId,
    required String message,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);

    final result = await _requestOtpUseCase(
      RequestOtpParams(
        appName: appName,
        contactId: contactId,
        message: message,
      ),
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

final requestOtpProvider =
    StateNotifierProvider.autoDispose<RequestOtpNotifier, RequestOtpState>(
      (ref) => RequestOtpNotifier(getIt<RequestOtpUseCase>()),
    );
