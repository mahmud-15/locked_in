import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Login Visibility Provider
final loginPasswordVisibleProvider = StateProvider<bool>((ref) => false);

// Register Visibility Provider
final registerPasswordVisibleProvider = StateProvider<bool>((ref) => false);

// Reset Password Visibility Providers
final resetNewPasswordVisibleProvider = StateProvider<bool>((ref) => false);
final resetConfirmPasswordVisibleProvider = StateProvider<bool>((ref) => false);

// OTP Timer Notifier
class OTPTimerNotifier extends StateNotifier<int> {
  Timer? _timer;
  static const int _initialDuration = 180; // 3 minutes

  OTPTimerNotifier() : super(_initialDuration) {
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    state = _initialDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1;
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final otpTimerProvider = StateNotifierProvider<OTPTimerNotifier, int>((ref) {
  return OTPTimerNotifier();
});
