import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: AppConstants.WORD_HIVE_TYPE)
class WordModel {
  WordModel({
    this.word,
    this.definition,
  });

  @HiveField(0)
  final String? word;
  @HiveField(1)
  final String? definition;

  factory WordModel.fromMap(Map<String, String> map) {
    return WordModel(
      word: map.keys.first,
      definition: map.values.first,
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
      };

  //copy with method
  WordModel copyWith({
    String? word,
    String? definition,
  }) {
    return WordModel(
      word: word ?? this.word,
      definition: definition ?? this.definition,
    );
  }

  @override
  String toString() {
    return '$word,  $definition ';
  }
}
