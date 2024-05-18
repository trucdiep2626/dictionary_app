import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:dictionary_app/domain/repositories/local_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepositoryImpl extends LocalRepository {



  @override
  Future<void> setIsFirstOpen( bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.IS_FIRST_OPEN, value);
  }

  @override
  Future<bool?> getIsFirstOpen( ) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.IS_FIRST_OPEN);
  }
}
