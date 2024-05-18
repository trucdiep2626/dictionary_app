import 'package:dartz/dartz.dart';
import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:dictionary_app/data/models/failure.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/domain/repositories/dictionary_repository.dart';

class DictionaryUseCase {
  final DictionaryRepository dictionaryRepository;

  DictionaryUseCase({required this.dictionaryRepository});

  //load word list from json file
  Future<Either<Failure, List<WordModel>>> loadWordListFromJsonFile() async {
    try {
      final words =
          await dictionaryRepository.readJsonFile(AppConstants.WORDS_JSON_PATH);
      return Right(words);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //get word list
  Future<Either<Failure, Map<int, List<WordModel>?>>> getWordList({
    String? keyword,
    int size = 10,
    int page = 1,
  }) async {
    try {
      final dictionaryInfo = await dictionaryRepository.getWordList(
        keyword: keyword,
        size: size,
        page: page,
      );
      return Right(dictionaryInfo);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //add new word
  Future<Either<Failure, bool>> addWord(WordModel word) async {
    try {
      await dictionaryRepository.addNewWord(word);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //add new word list
  Future<Either<Failure, bool>> addWordList(List<WordModel> words) async {
    try {
      await dictionaryRepository.addNewWordList(words);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //update word
  Future<Either<Failure, bool>> updateWord(WordModel word) async {
    try {
      await dictionaryRepository.updateWord(word);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //delete word
  Future<Either<Failure, bool>> deleteWord(int id) async {
    try {
      await dictionaryRepository.deleteWord(id);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //check duplicate
  Future<Either<Failure, bool>> checkDuplicateWord(String word) async {
    try {
      final isDuplicate = await dictionaryRepository.checkDuplicateWord(word);
      return Right(isDuplicate);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //get detail word
  Future<Either<Failure, WordModel>> getDetailWord(int id) async {
    try {
      final word = await dictionaryRepository.getDetailWord(id);
      return Right(word);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  //get total word
  Future<Either<Failure, int>> getTotalWords() async {
    try {
      final totalWord = await dictionaryRepository.getTotalWords();
      return Right(totalWord);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }
}
