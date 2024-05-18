import 'package:dictionary_app/data/models/word_model.dart';

abstract class DictionaryRepository {
  Future<Map<int, List<WordModel>?>> getWordList(
      {String? keyword, int page = 1, int size = 10});

  Future<void> addNewWord(WordModel newWord);

  Future<List<int>> addNewWordList(List<WordModel> list);

  Future<void> updateWord(WordModel word);

  Future<void> deleteWord(int id);

  Future<WordModel> getDetailWord(int id);

  Future<List<WordModel>> readJsonFile(String path);

  Future<bool> checkDuplicateWord(String word);

  Future<int> getTotalWords();
}
