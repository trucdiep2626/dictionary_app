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
  Future<List<WordModel>> readJsonFile(String path) async {
    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    if (data is List) {
      return data.map((e) => WordModel.fromJson(e)).toList();
    }
    return [];
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
    final keys = hiveServices.wordsBox.keys.cast<int>();
    final values = hiveServices.wordsBox.values.cast<WordModel>();
    final words = <WordModel>[];
    for (var i = 0; i < keys.length; i++) {
      WordModel word = WordModel.fromJson(values.elementAt(i).toJson());
      word = word.copyWith(id: keys.elementAt(i));
      words.add(word);
    }

    //   final words = List<WordModel>.from(hiveServices.wordsBox.values.toList());

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
  Future<int> addNewWord(WordModel newWord) async {
    int id = await hiveServices.wordsBox.add(newWord);
    return id;
  }

  @override
  Future<List<int>> addNewWordList(List<WordModel> list) async {
    return (await hiveServices.wordsBox.addAll(list)).toList();
  }

  @override
  Future<void> updateWord(WordModel word) async {
    await hiveServices.wordsBox.put(word.id, word);
  }

  @override
  Future<void> deleteWord(int id) async {
    await hiveServices.wordsBox.delete(id);
  }

  @override
  Future<WordModel> getDetailWord(int id) async {
    return await hiveServices.wordsBox.get(id);
  }

  //check duplicate
  @override
  Future<bool> checkDuplicateWord(String word) async {
    final words = List<WordModel>.from(hiveServices.wordsBox.values.toList());
    return words.any((element) => element.word == word);
  }

  //get total word
  @override
  Future<int> getTotalWords() async {
    return hiveServices.wordsBox.length;
  }
}
