import 'package:dictionary_app/data/models/word_model.dart';

abstract class DictionaryRepository {
  Future<Map<int, List<WordModel>?>> getWordList(
      {String? keyword, int page = 1, int size = 10});

  Future<void> addNewWord(WordModel newWord);

  Future<void> addNewWordList(Map<String, dynamic> list);

  Future<void> updateWord({
    required String oldWord,
    required WordModel newWord,
  });

  Future<void> deleteWord(String id);

  Future<WordModel> getDetailWord(String id);

  Future<Map<String, dynamic>> readJsonFile(String path);

  Future<bool> checkDuplicateWord(String word);

  Future<int> getTotalWords();
}
