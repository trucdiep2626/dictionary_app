import 'package:dictionary_app/data/models/word_model.dart';

class HomeState {
  final bool showLoadingIndicator;
  final List<WordModel> items;
  final bool showLoadMoreIndicator;
  final int page;
  final int totalItems;
  final bool enableLoadMore;

  HomeState({
    this.showLoadingIndicator = false,
    this.items = const <WordModel>[],
    this.showLoadMoreIndicator = false,
    this.page = 1,
    this.totalItems = 0,
    this.enableLoadMore = true,
  });

  HomeState copyWith({
    bool? showLoadingIndicator,
    List<WordModel>? items,
    bool? showLoadMoreIndicator,
    int? page,
    int? totalItems,
    bool? enableLoadMore,
  }) {
    return HomeState(
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      items: items ?? this.items,
      showLoadMoreIndicator:
          showLoadMoreIndicator ?? this.showLoadMoreIndicator,
      page: page ?? this.page,
      totalItems: totalItems ?? this.totalItems,
      enableLoadMore: enableLoadMore ?? this.enableLoadMore,
    );
  }
}
