import 'package:dictionary_app/common/constants/app_constants.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  late Box<dynamic> wordsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WordModelAdapter());
    wordsBox = await Hive.openBox(AppConstants.WORDS_BOX);
  }

  void dispose() {
    wordsBox.compact();
    Hive.close();
  }
}
