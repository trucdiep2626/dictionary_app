import 'package:dictionary_app/data/models/word_model.dart';

class WordDetailState {
  final bool showLoadingIndicator;
  final WordModel? word;
  final bool shouldRefresh;
  final bool isEditing;

  WordDetailState({
    this.showLoadingIndicator = false,
    this.word,
    this.shouldRefresh = false,
    this.isEditing = false,
  });

  WordDetailState copyWith({
    bool? showLoadingIndicator,
    WordModel? word,
    bool? shouldRefresh,
    bool? isEditing,
  }) {
    return WordDetailState(
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      word: word ?? this.word,
      shouldRefresh: shouldRefresh ?? this.shouldRefresh,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
