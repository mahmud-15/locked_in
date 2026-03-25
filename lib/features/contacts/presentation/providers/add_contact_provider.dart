import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/contacts/domain/usecases/add_contact_usecase.dart';

class AddContactState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  AddContactState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AddContactState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AddContactState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AddContactNotifier extends StateNotifier<AddContactState> {
  final AddContactUseCase _addContactUseCase;

  AddContactNotifier(this._addContactUseCase) : super(AddContactState());

  Future<void> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    final result = await _addContactUseCase(
      AddContactParams(
        name: name,
        email: email,
        contact: contact,
        relation: relation,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(isLoading: false, isSuccess: true),
    );
  }
}

final addContactProvider =
    StateNotifierProvider.autoDispose<AddContactNotifier, AddContactState>((
      ref,
    ) {
      return AddContactNotifier(getIt<AddContactUseCase>());
    });
