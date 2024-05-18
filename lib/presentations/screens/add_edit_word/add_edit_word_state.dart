import 'package:dictionary_app/data/models/word_model.dart';

class AddEditWordState {
  final bool showLoadingIndicator;
  final bool showError;
  final String? errorMessage;
  final WordModel? oldWord;
  final bool enableButton;

  AddEditWordState({
    this.showLoadingIndicator = false,
    this.showError = false,
    this.errorMessage,
    this.oldWord,
    this.enableButton = false,
  });

  AddEditWordState copyWith({
    bool? showLoadingIndicator,
    bool? showError,
    String? errorMessage,
    WordModel? oldWord,
    bool? enableButton,
  }) {
    return AddEditWordState(
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      showError: showError ?? this.showError,
      errorMessage: errorMessage ?? this.errorMessage,
      oldWord: oldWord ?? this.oldWord,
      enableButton: enableButton ?? this.enableButton,
    );
  }
}
