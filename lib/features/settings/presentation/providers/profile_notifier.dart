import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/settings/domain/usecases/profile_usecases.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final UserEntity? user;
  final ProfileStatus status;
  final String? errorMessage;

  ProfileState({
    this.user,
    this.status = ProfileStatus.initial,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserEntity? user,
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileNotifier({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(ProfileState()) {
    getProfile();
  }

  Future<void> getProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);
    final result = await _getProfileUseCase();
    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: ProfileStatus.success, user: user),
    );
  }

  Future<bool> updateProfile(String name) async {
    state = state.copyWith(status: ProfileStatus.loading);
    final result = await _updateProfileUseCase(name);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(status: ProfileStatus.success, user: user);
        return true;
      },
    );
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(
        getProfileUseCase: getIt<GetProfileUseCase>(),
        updateProfileUseCase: getIt<UpdateProfileUseCase>(),
      );
    });
