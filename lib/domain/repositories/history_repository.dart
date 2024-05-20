import 'package:dictionary_app/data/models/searched_keyword_model.dart';

abstract class HistoryRepository {
  Future<List<SearchedKeywordModel>> getSearchedKeywords();

  Future<void> addSearchedKeyword(SearchedKeywordModel keyword);

  Future<void> deleteSearchedKeyword(int id);
}
