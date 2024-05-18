import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/config/route/route_generator.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/presentations/screens/word_detail/word_detail_screen.dart';
import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:flutter/material.dart';

class WordItem extends StatelessWidget {
  const WordItem({super.key, required this.word, this.onRefresh});

  final WordModel word;

  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await NavigationService.routeTo(
            RouteGenerator.wordDetail,
            arguments: WordDetailArguments(id: word.id ?? 0));

        if (result is bool && result) {
          onRefresh?.call();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [AppColors.boxShadow],
        ),
        child: ListTile(
          title: Text(
            word.word ?? '',
            style: ThemeText.bodyMedium,
          ),
        ),
      ),
    );
  }
}
