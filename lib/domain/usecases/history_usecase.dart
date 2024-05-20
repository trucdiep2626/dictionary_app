import 'package:dartz/dartz.dart';
import 'package:dictionary_app/data/models/failure.dart';
import 'package:dictionary_app/data/models/searched_keyword_model.dart';
import 'package:dictionary_app/domain/repositories/history_repository.dart';

class HistoryUsecase {
  final HistoryRepository historyRepository;

  HistoryUsecase({required this.historyRepository});

  Future<Either<Failure, List<SearchedKeywordModel>>>
      getSearchedKeywords() async {
    try {
      final searchedKeywords = await historyRepository.getSearchedKeywords();
      return Right(searchedKeywords);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  Future<Either<Failure, bool>> addSearchedKeyword(
      SearchedKeywordModel keyword) async {
    try {
      await historyRepository.addSearchedKeyword(keyword);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }

  Future<Either<Failure, bool>> deleteSearchedKeyword(int id) async {
    try {
      await historyRepository.deleteSearchedKeyword(id);
      return const Right(true);
    } catch (e) {
      return Left(Failure('Somethings went wrong'));
    }
  }
}
