import 'package:dictionary_app/data/models/searched_keyword_model.dart';
import 'package:dictionary_app/data/models/word_model.dart';

class HomeState {
  final bool showLoadingIndicator;
  final List<WordModel> items;
  final bool showLoadMoreIndicator;
  final int page;
  final int totalItems;
  final bool enableLoadMore;
  final List<SearchedKeywordModel>? searchedKeywords;
  final List<SearchedKeywordModel>? displaySearchedKeywords;
  final bool showHistory;

  HomeState({
    this.showLoadingIndicator = true,
    this.items = const <WordModel>[],
    this.showLoadMoreIndicator = false,
    this.page = 1,
    this.totalItems = 0,
    this.enableLoadMore = true,
    this.searchedKeywords,
    this.showHistory = false,
    this.displaySearchedKeywords,
  });

  HomeState copyWith({
    bool? showLoadingIndicator,
    List<WordModel>? items,
    bool? showLoadMoreIndicator,
    int? page,
    int? totalItems,
    bool? enableLoadMore,
    List<SearchedKeywordModel>? searchedKeywords,
    bool? showHistory,
    List<SearchedKeywordModel>? displaySearchedKeywords,
  }) {
    return HomeState(
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      items: items ?? this.items,
      showLoadMoreIndicator:
          showLoadMoreIndicator ?? this.showLoadMoreIndicator,
      page: page ?? this.page,
      totalItems: totalItems ?? this.totalItems,
      enableLoadMore: enableLoadMore ?? this.enableLoadMore,
      searchedKeywords: searchedKeywords ?? this.searchedKeywords,
      showHistory: showHistory ?? this.showHistory,
      displaySearchedKeywords:
          displaySearchedKeywords ?? this.displaySearchedKeywords,
    );
  }
}
