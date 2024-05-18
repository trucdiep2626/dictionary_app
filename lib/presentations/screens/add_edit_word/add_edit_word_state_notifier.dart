import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/injector.dart';
import 'package:dictionary_app/common/utils/app_utils.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/domain/usecases/dictionary_usecase.dart';
import 'package:dictionary_app/presentations/screens/add_edit_word/add_edit_word_state.dart';
import 'package:dictionary_app/presentations/widgets/app_dialog.dart';
import 'package:dictionary_app/presentations/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addEditWordNotifierProvider = StateNotifierProvider.autoDispose<
    AddEditWordStateNotifier, AddEditWordState>((ref) {
  return AddEditWordStateNotifier(
    dictionaryUseCase: getIt<DictionaryUseCase>(),
  );
});

class AddEditWordStateNotifier extends StateNotifier<AddEditWordState> {
  AddEditWordStateNotifier({
    required this.dictionaryUseCase,
  }) : super(AddEditWordState()) {
    wordController.addListener(checkButtonEnable);
    meaningController.addListener(checkButtonEnable);
    exampleController.addListener(checkButtonEnable);
  }

  final DictionaryUseCase dictionaryUseCase;

  final TextEditingController wordController = TextEditingController();

  final TextEditingController meaningController = TextEditingController();

  final TextEditingController exampleController = TextEditingController();

  void onClear() {
    wordController.clear();
    meaningController.clear();
    exampleController.clear();
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
        NavigationService.goBack();
      });
    } else {
      NavigationService.goBack();
    }
  }

  void checkButtonEnable() {
    if (wordController.text.isNotEmpty && meaningController.text.isNotEmpty) {
      state = state.copyWith(enableButton: true);
    } else {
      state = state.copyWith(enableButton: false);
    }
  }

  void initData(WordModel? wordModel) {
    if (wordModel != null) {
      wordController.text = wordModel.word ?? '';
      meaningController.text = wordModel.definition ?? '';
      exampleController.text = wordModel.example ?? '';
      state = state.copyWith(oldWord: wordModel);
    }
  }

  Future<void> addWord() async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.addWord(WordModel(
      word: wordController.text.trim(),
      definition: meaningController.text.trim(),
      example: exampleController.text.trim(),
    ));
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (success) async {
        AppSnackbar.showSnackbar(
          title: 'Successfully added information.',
        );
       // await Future.delayed(const Duration(seconds: 2));
        NavigationService.goBack(value: true);
      },
    );

    state = state.copyWith(
      showLoadingIndicator: false,
    );
  }

  //update word
  Future<void> updateWord() async {
    state = state.copyWith(showLoadingIndicator: true);
    final result = await dictionaryUseCase.updateWord(WordModel(
      id: state.oldWord?.id,
      word: wordController.text.trim(),
      definition: meaningController.text.trim(),
      example: exampleController.text.trim(),
    ));
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (success) async {
        AppSnackbar.showSnackbar(
          title: 'Successfully updated information.',
        );
        //await Future.delayed(const Duration(seconds: 2));
        NavigationService.goBack(value: true);
      },
    );

    state = state.copyWith(
      showLoadingIndicator: false,
    );
  }

  //on pressed save
  Future<void> onPressedSave(BuildContext context) async {
    hideKeyboard();
    if (state.enableButton) {
      if (state.oldWord != null) {
        await updateWord();
      } else {
        await checkDuplicate(context);
      }
    }
  }

  //check duplicate
  Future<void> checkDuplicate(BuildContext context) async {
    final result =
        await dictionaryUseCase.checkDuplicateWord(wordController.text.trim());
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (success) async {
        if (success) {
          showAppDialog(context, 'This word is already exist.',
              confirmButtonText: 'Save',
              cancelButtonText: 'Check Word', confirmButtonCallback: () async {
            NavigationService.goBack();
            await addWord();
          });
        } else {
          await addWord();
        }
      },
    );
  }
}
