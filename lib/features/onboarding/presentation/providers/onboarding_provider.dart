import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/hive_service.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/core/network/local_storage.dart';
import 'package:locked_in/core/services/logger_service.dart';

class OnboardingNotifier extends StateNotifier<bool> {
  final HiveService _hiveService;
  static const String _boxName = 'settings';
  static const String _baseKey = 'onboarding_completed';

  String get _key => '${LocalStorage.userId ?? 'guest'}_$_baseKey';

  OnboardingNotifier(this._hiveService) : super(false) {
    checkOnboarding();
  }

  Future<void> checkOnboarding() async {
    try {
      final completed = await _hiveService.get<bool>(_boxName, _key);
      state = completed ?? false;
    } catch (e, stack) {
      LoggerService.e('Failed to check onboarding status', e, stack);
      state = false;
    }
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
