import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: AppConstants.WORD_HIVE_TYPE)
class WordModel {
  WordModel({
    this.id,
    this.word,
    this.definition,
    this.example,
  });

  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? word;
  @HiveField(2)
  final String? definition;
  @HiveField(3)
  final String? example;

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'],
      word: json['word'],
      definition: json['definition'],
      example: json['example'],
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'example': example,
        'id': id,
      };

  //copy with method
  WordModel copyWith({
    int? id,
    String? word,
    String? definition,
    String? example,
  }) {
    return WordModel(
      id: id ?? this.id,
      word: word ?? this.word,
      definition: definition ?? this.definition,
      example: example ?? this.example,
    );
  }

  @override
  String toString() {
    return '$word, $example, $definition ';
  }
}
