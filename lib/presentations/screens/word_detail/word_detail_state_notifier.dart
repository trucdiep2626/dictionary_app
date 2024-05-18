import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/injector.dart';
import 'package:dictionary_app/domain/usecases/dictionary_usecase.dart';
import 'package:dictionary_app/presentations/screens/word_detail/word_detail_state.dart';
import 'package:dictionary_app/presentations/widgets/app_dialog.dart';
import 'package:dictionary_app/presentations/widgets/app_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordDetailNotifierProvider =
    StateNotifierProvider.autoDispose<WordDetailStateNotifier, WordDetailState>(
        (ref) {
  return WordDetailStateNotifier(
    dictionaryUseCase: getIt<DictionaryUseCase>(),
  );
});

class WordDetailStateNotifier extends StateNotifier<WordDetailState> {
  WordDetailStateNotifier({
    required this.dictionaryUseCase,
  }) : super(WordDetailState());

  final DictionaryUseCase dictionaryUseCase;

  //get detail word
  Future<void> getDetailWord(int id) async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.getDetailWord(id);
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
        state = state.copyWith(showLoadingIndicator: false);
      },
      (word) {
        state = state.copyWith(
            showLoadingIndicator: false, word: word.copyWith(id: id));
      },
    );
  }

  void onChangedShouldRefresh(bool shouldRefresh) {
    state = state.copyWith(shouldRefresh: shouldRefresh);
  }

  //delete word
  Future<void> deleteWord(BuildContext context) async {
    if (state.word?.id == null) return;

    showAppDialog(context, 'Are you sure you want to delete this word?',
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel', confirmButtonCallback: () async {
      await _handleDeleteWord();
    });
  }

  Future<void> _handleDeleteWord() async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.deleteWord(state.word?.id ?? 0);
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (isSuccess) {
        if (isSuccess) {
          AppSnackbar.showSnackbar(title: 'Deleted word success');
          NavigationService.goBack();
          NavigationService.goBack(value: true);
        } else {
          AppSnackbar.showSnackbar(title: 'Deleted word failed', isError: true);
        }
      },
    );
    state = state.copyWith(showLoadingIndicator: false);
  }
}
