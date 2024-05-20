import 'package:dictionary_app/common/config/hive_services.dart';
import 'package:dictionary_app/data/repositories/dictionary_repository.dart';
import 'package:dictionary_app/data/repositories/history_repository.dart';
import 'package:dictionary_app/data/repositories/local_repository.dart';
import 'package:dictionary_app/domain/repositories/dictionary_repository.dart';
import 'package:dictionary_app/domain/repositories/history_repository.dart';
import 'package:dictionary_app/domain/repositories/local_repository.dart';
import 'package:dictionary_app/domain/usecases/dictionary_usecase.dart';
import 'package:dictionary_app/domain/usecases/history_usecase.dart';
import 'package:dictionary_app/domain/usecases/local_usecase.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void configLocator() {
  /// UseCases
  getIt.registerFactory<DictionaryUseCase>(() => DictionaryUseCase(
        dictionaryRepository: getIt<DictionaryRepository>(),
      ));
  getIt.registerFactory<LocalUsecase>(() => LocalUsecase(
        localRepository: getIt<LocalRepository>(),
      ));
  getIt.registerFactory<HistoryUsecase>(
      () => HistoryUsecase(historyRepository: getIt<HistoryRepository>()));

  /// Repositories
  getIt.registerFactory<DictionaryRepository>(() => DictionaryRepositoryImpl(
        hiveServices: getIt<HiveServices>(),
      ));
  getIt.registerFactory<HistoryRepository>(
      () => HistoryRepositoryImpl(hiveServices: getIt<HiveServices>()));

  getIt.registerFactory<LocalRepository>(() => LocalRepositoryImpl());

  // Common
  getIt.registerLazySingleton<HiveServices>(() => HiveServices());
}
