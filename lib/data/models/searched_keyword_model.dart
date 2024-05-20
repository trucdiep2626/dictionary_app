import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'searched_keyword_model.g.dart';

@HiveType(typeId: AppConstants.SEARCHED_KEYWORD_HIVE_TYPE)
class SearchedKeywordModel {
  SearchedKeywordModel({
    this.id,
    this.word,
    this.createdAt,
  });

  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? word;
  @HiveField(2)
  final int? createdAt;

  factory SearchedKeywordModel.fromJson(Map<String, dynamic> json) {
    return SearchedKeywordModel(
      id: json['id'],
      word: json['word'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'id': id,
        'created_at': createdAt,
      };

  //copy with method
  SearchedKeywordModel copyWith({
    int? id,
    String? word,
    int? createdAt,
  }) {
    return SearchedKeywordModel(
      id: id ?? this.id,
      word: word ?? this.word,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '$word, $createdAt ';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchedKeywordModel &&
          runtimeType == other.runtimeType &&
          word == other.word;

  @override
  int get hashCode => word.hashCode;
}
