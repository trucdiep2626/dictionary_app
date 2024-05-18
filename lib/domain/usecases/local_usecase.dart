import 'package:dictionary_app/domain/repositories/local_repository.dart';

class LocalUsecase {
  final LocalRepository localRepository;

  LocalUsecase({required this.localRepository});

  Future<bool> getIsFirstOpen() async {
    return await localRepository.getIsFirstOpen() ?? true;
  }

  Future<void> setIsFirstOpen(bool value) async {
    await localRepository.setIsFirstOpen(value);
  }
}
