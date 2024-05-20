import 'package:dictionary_app/common/config/hive_services.dart';
import 'package:dictionary_app/data/models/searched_keyword_model.dart';
import 'package:dictionary_app/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl extends HistoryRepository {
  final HiveServices hiveServices;

  HistoryRepositoryImpl({required this.hiveServices});

  @override
  Future<void> addSearchedKeyword(SearchedKeywordModel searchedKeyword) async {
    await hiveServices.searchedKeywordsBox.add(searchedKeyword);
  }

  @override
  Future<List<SearchedKeywordModel>> getSearchedKeywords() async {
    final keys = hiveServices.searchedKeywordsBox.keys.cast<int>();
    final values =
        hiveServices.searchedKeywordsBox.values.cast<SearchedKeywordModel>();
    final searchedKeywords = <SearchedKeywordModel>[];
    for (var i = 0; i < keys.length; i++) {
      SearchedKeywordModel searchedKeyword =
          SearchedKeywordModel.fromJson(values.elementAt(i).toJson());
      searchedKeyword = searchedKeyword.copyWith(id: keys.elementAt(i));
      searchedKeywords.add(searchedKeyword);
    }

    searchedKeywords
        .sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0));

    return searchedKeywords.toSet().toList();
  }

  @override
  Future<void> deleteSearchedKeyword(int id) async {
    await hiveServices.searchedKeywordsBox.delete(id);
  }
}
