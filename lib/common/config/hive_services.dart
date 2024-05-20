import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:dictionary_app/data/models/searched_keyword_model.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  late Box<dynamic> wordsBox;
  late Box<dynamic> searchedKeywordsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(WordModelAdapter())
      ..registerAdapter(SearchedKeywordModelAdapter());
    wordsBox = await Hive.openBox(AppConstants.WORDS_BOX);
    searchedKeywordsBox =
        await Hive.openBox(AppConstants.SEARCHED_KEYWORDS_BOX);
  }

  void dispose() {
    wordsBox.compact();
    searchedKeywordsBox.compact();
    Hive.close();
  }
}
