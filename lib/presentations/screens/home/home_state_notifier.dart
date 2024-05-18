import 'package:dictionary_app/common/injector.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/domain/usecases/dictionary_usecase.dart';
import 'package:dictionary_app/domain/usecases/local_usecase.dart';
import 'package:dictionary_app/presentations/screens/home/home_state.dart';
import 'package:dictionary_app/presentations/widgets/app_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeNotifierProvider =
    StateNotifierProvider.autoDispose<HomeStateNotifier, HomeState>((ref) {
  return HomeStateNotifier(
      dictionaryUseCase: getIt<DictionaryUseCase>(),
      localUsecase: getIt<LocalUsecase>());
});

class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier({
    required this.dictionaryUseCase,
    required this.localUsecase,
  }) : super(HomeState());

  final DictionaryUseCase dictionaryUseCase;
  final LocalUsecase localUsecase;

  final TextEditingController searchController = TextEditingController();

  Future<void> initData() async {
    state = state.copyWith(showLoadingIndicator: true, page: 1, items: []);
    final isFirstOpenApp = await localUsecase.getIsFirstOpen();

    if (isFirstOpenApp) {
      await localUsecase.setIsFirstOpen(false);
      final result = await dictionaryUseCase.loadWordListFromJsonFile();
      result.fold(
        (failure) {
          AppSnackbar.showSnackbar(title: failure.message, isError: true);
          state = state.copyWith(
            showLoadingIndicator: false,
          );
        },
        (words) async {
          await dictionaryUseCase.addWordList(words);

          await searchWord();
        },
      );
    } else {
      await searchWord();
    }
  }

  Future<void> loadMore() async {
    if (!state.enableLoadMore) return;

    state = state.copyWith(showLoadMoreIndicator: true, page: state.page + 1);
    await _handleSearchWord();
  }

  Future<void> searchWord() async {
    state = state.copyWith(showLoadingIndicator: true, items: [], page: 1);

    await _handleSearchWord();
  }

  //delete data

  Future<void> _handleSearchWord() async {
   // await Future.delayed(const Duration(seconds: 3));

    final result = await dictionaryUseCase.getWordList(
      keyword: searchController.text,
      page: state.page,
      size: 10,
    );

    result.fold((failure) {
      AppSnackbar.showSnackbar(title: failure.message, isError: true);
      state = state.copyWith(
        showLoadingIndicator: false,
        showLoadMoreIndicator: false,
      );
    }, (words) {
      final wordList = [
        ...state.items,
        ...(words.values.first ?? <WordModel>[])
      ];
      state = state.copyWith(
        showLoadingIndicator: false,
        showLoadMoreIndicator: false,
        items: wordList,
        totalItems: words.keys.first,
        enableLoadMore: wordList.length < words.keys.first,
      );
    });
  }

  //get total words in hive
  Future<void> getTotalWords() async {
    final result = await dictionaryUseCase.getTotalWords();
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (total) {
        state = state.copyWith(totalItems: total);
      },
    );
  }
}
