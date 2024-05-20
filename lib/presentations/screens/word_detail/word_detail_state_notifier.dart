import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/injector.dart';
import 'package:dictionary_app/data/models/word_model.dart';
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

  final TextEditingController wordController = TextEditingController();

  final TextEditingController meaningController = TextEditingController();

  final TextEditingController exampleController = TextEditingController();

  //update word
  Future<void> updateWord() async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.updateWord(
        oldWord: state.word?.word ?? '',
        newWord: WordModel(
          word: wordController.text.trim(),
          definition: meaningController.text.trim(),
        ));

    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (success) async {
        AppSnackbar.showSnackbar(
          title: 'Successfully updated information.',
        );
        await getDetailWord(wordController.text.trim());
        //await Future.delayed(const Duration(seconds: 2));
        //  NavigationService.goBack(value: true);
      },
    );

    state = state.copyWith(
      showLoadingIndicator: false,
      isEditing: false,
      shouldRefresh: true,
    );
  }

  void initEditData() {
    if (state.word != null) {
      wordController.text = state.word?.word ?? '';
      meaningController.text = state.word?.definition ?? '';
    }
  }

  void onChangedIsEditing() {
    state = state.copyWith(isEditing: true);
    initEditData();
  }

  void confirmDiscard() {
    if (wordController.text.isNotEmpty ||
        meaningController.text.isNotEmpty ||
        exampleController.text.isNotEmpty) {
      showAppDialog(NavigationService.navigatorKey.currentContext!,
          'Do you want to discard the changes?',
          confirmButtonText: 'Discard',
          cancelButtonText: 'Cancel', confirmButtonCallback: () {
        NavigationService.goBack();
        state = state.copyWith(isEditing: false);
      });
    } else {
      NavigationService.goBack();
    }
  }

  //get detail word
  Future<void> getDetailWord(String id) async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.getDetailWord(id);
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
        state = state.copyWith(showLoadingIndicator: false);
      },
      (word) {
        state = state.copyWith(
            showLoadingIndicator: false, word: word.copyWith(word: id));
      },
    );
  }

  void onChangedShouldRefresh(bool shouldRefresh) {
    state = state.copyWith(shouldRefresh: shouldRefresh);
  }

  //delete word
  Future<void> deleteWord(BuildContext context) async {
    if (state.word?.word == null) return;

    showAppDialog(context, 'Are you sure you want to delete this word?',
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel', confirmButtonCallback: () async {
      await _handleDeleteWord();
    });
  }

  Future<void> _handleDeleteWord() async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.deleteWord(state.word?.word ?? '');
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
