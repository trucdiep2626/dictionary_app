import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalRepository {
  Future<void> setIsFirstOpen(bool value);

  Future<bool?> getIsFirstOpen();
}
