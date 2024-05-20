import 'dart:convert';
import 'package:dictionary_app/common/config/hive_services.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/domain/repositories/dictionary_repository.dart';
import 'package:flutter/services.dart';

class DictionaryRepositoryImpl extends DictionaryRepository {
  final HiveServices hiveServices;

  DictionaryRepositoryImpl({required this.hiveServices});

  //read data from json file
  @override
  Future<Map<String, dynamic>> readJsonFile(String path) async {
    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return data;
  }

  Future<void> addWordToHive(String word) async {
    final data = await hiveServices.wordsBox.get('words');
    data.add(word);
    await hiveServices.wordsBox.put('words', data);
  }

  // get word list with id
  @override
  Future<Map<int, List<WordModel>?>> getWordList({
    String? keyword,
    int page = 1,
    int size = 10,
  }) async {
    final result = <WordModel>[];

    final wordsMap = hiveServices.wordsBox.toMap();

    List<WordModel> words = wordsMap.entries.map((entry) {
      var key = entry.key;
      var value = entry.value;
      return WordModel.fromMap({key: value});
    }).toList();

    words.sort((a, b) =>
        (a.word ?? '').toLowerCase().compareTo((b.word ?? '').toLowerCase()));

    if (keyword != null) {
      words.removeWhere((element) => !element.word!.contains(keyword));
    }

    final totalItems = words.length;

    result.addAll(words.skip((page - 1) * size).take(size).toList());
    return {totalItems: result};
  }

  @override
  Future<void> addNewWord(WordModel newWord) async {
    await hiveServices.wordsBox
        .put(newWord.word ?? '', newWord.definition ?? '');
  }

  @override
  Future<void> addNewWordList(Map<String, dynamic> list) async {
    return (await hiveServices.wordsBox.putAll(list));
  }

  @override
  Future<void> updateWord({
    required String oldWord,
    required WordModel newWord,
  }) async {
    if (oldWord != newWord.word) {
      await hiveServices.wordsBox.delete(oldWord);
    }
    await hiveServices.wordsBox.put(
      newWord.word,
      newWord.definition,
    );
  }

  @override
  Future<void> deleteWord(String id) async {
    await hiveServices.wordsBox.delete(id);
  }

  @override
  Future<WordModel> getDetailWord(String id) async {
    final value = await hiveServices.wordsBox.get(id);
    return WordModel(word: id, definition: value);
  }

  //check duplicate
  @override
  Future<bool> checkDuplicateWord(String word) async {
    final words = hiveServices.wordsBox.keys.toList();
    return words.any((element) => element == word);
  }

  //get total word
  @override
  Future<int> getTotalWords() async {
    return hiveServices.wordsBox.length;
  }
}
