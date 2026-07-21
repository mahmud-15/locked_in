import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/injection.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';
import 'package:locked_in/features/contacts/domain/usecases/get_contacts_usecase.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class ContactsState {
  final List<ContactEntity> contacts;
  final bool isLoading; // initial/first-page load
  final bool isLoadingMore; // pagination load
  final bool hasReachedMax;
  final String? errorMessage;
  final int currentPage;

  const ContactsState({
    this.contacts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
    this.currentPage = 0,
  });

  ContactsState copyWith({
    List<ContactEntity>? contacts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? errorMessage,
    int? currentPage,
    bool clearError = false,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ContactsNotifier extends StateNotifier<ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  static const int _limit = 10;

  ContactsNotifier(this._getContactsUseCase) : super(const ContactsState()) {
    fetchContacts();
  }

  /// Initial fetch / pull-to-refresh
  Future<void> fetchContacts() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      hasReachedMax: false,
    );

    final result = await _getContactsUseCase(page: 1, limit: _limit);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        isLoading: false,
        contacts: data.contacts,
        currentPage: 1,
        hasReachedMax: !data.hasNextPage,
      ),
    );
  }

  /// Pagination — load next page
  Future<void> fetchMore() async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;

    final result = await _getContactsUseCase(page: nextPage, limit: _limit);

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        isLoadingMore: false,
        contacts: [...state.contacts, ...data.contacts],
        currentPage: nextPage,
        hasReachedMax: !data.hasNextPage,
      ),
    );
  }

  /// Called after a new contact is added — inserts at top & clears stale cache
  void onContactAdded(ContactEntity contact) {
    state = state.copyWith(contacts: [contact, ...state.contacts]);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final contactsProvider = StateNotifierProvider<ContactsNotifier, ContactsState>(
  (ref) {
    return ContactsNotifier(getIt<GetContactsUseCase>());
  },
);
