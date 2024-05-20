import 'dart:async';
import 'package:dictionary_app/common/injector.dart';
import 'package:dictionary_app/data/models/searched_keyword_model.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/domain/usecases/dictionary_usecase.dart';
import 'package:dictionary_app/domain/usecases/history_usecase.dart';
import 'package:dictionary_app/domain/usecases/local_usecase.dart';
import 'package:dictionary_app/presentations/screens/home/home_state.dart';
import 'package:dictionary_app/presentations/widgets/app_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeNotifierProvider =
    StateNotifierProvider.autoDispose<HomeStateNotifier, HomeState>((ref) {
  return HomeStateNotifier(
    dictionaryUseCase: getIt<DictionaryUseCase>(),
    localUsecase: getIt<LocalUsecase>(),
    historyUsecase: getIt<HistoryUsecase>(),
  );
});

class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier({
    required this.dictionaryUseCase,
    required this.localUsecase,
    required this.historyUsecase,
  }) : super(HomeState());

  final DictionaryUseCase dictionaryUseCase;
  final LocalUsecase localUsecase;
  final HistoryUsecase historyUsecase;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _timer;

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
    await getSearchHistory();
  }

  Future<void> loadMore() async {
    if (!state.enableLoadMore) return;

    state = state.copyWith(showLoadMoreIndicator: true, page: state.page + 1);
    await _handleSearchWord();
  }

  Future<void> searchWord({String? keyword}) async {
    state = state.copyWith(
      showLoadingIndicator: true,
      items: [],
      page: 1,
      showHistory: false,
    );

    if (keyword != null) {
      searchController.text = keyword;
    } else {
      await addSearchHistory();
    }

    await _handleSearchWord();
  }

  void onChangedShowHistory(bool showHistory) {
    state = state.copyWith(showHistory: showHistory);
  }

  Future<void> searchWordWithDebounce() async {
    state = state.copyWith(showHistory: true);
    final searchHistory = [...?state.searchedKeywords];

    if (searchHistory.isNotEmpty) {
      searchHistory.removeWhere(
          (element) => !(element.word ?? '').contains(searchController.text));
      state = state.copyWith(displaySearchedKeywords: searchHistory);
    }

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(const Duration(milliseconds: 800), () async {
      state = state.copyWith(showHistory: false);
      await searchWord();
    });
  }

  //add search keyword to history
  Future<void> addSearchHistory() async {
    final keyword = searchController.text;
    if (keyword.isEmpty) return;

    final result = await historyUsecase.addSearchedKeyword(SearchedKeywordModel(
      word: keyword,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ));
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (success) {
        state = state.copyWith(showHistory: false);
      },
    );
    await getSearchHistory();
  }

  //get search history
  Future<void> getSearchHistory() async {
    final result = await historyUsecase.getSearchedKeywords();
    result.fold(
      (failure) {
        AppSnackbar.showSnackbar(title: failure.message, isError: true);
      },
      (keywords) {
        state = state.copyWith(
          searchedKeywords: keywords,
          displaySearchedKeywords: keywords,
        );
      },
    );
  }

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
