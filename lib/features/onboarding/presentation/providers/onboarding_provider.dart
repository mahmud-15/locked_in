import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/hive_service.dart';
import 'package:locked_in/core/services/injection.dart';

class OnboardingNotifier extends StateNotifier<bool> {
  final HiveService _hiveService;
  static const String _boxName = 'settings';
  static const String _key = 'onboarding_completed';

  OnboardingNotifier(this._hiveService) : super(false) {
    checkOnboarding();
  }

  Future<void> checkOnboarding() async {
    final completed = await _hiveService.get<bool>(_boxName, _key);
    state = completed ?? false;
  }

  Future<void> completeOnboarding() async {
    await _hiveService.put<bool>(_boxName, _key, true);
    state = true;
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((
  ref,
) {
  return OnboardingNotifier(getIt<HiveService>());
});
