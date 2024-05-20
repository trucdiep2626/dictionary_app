import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/config/route/route_generator.dart';
import 'package:dictionary_app/common/utils/app_utils.dart';
import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/presentations/screens/word_detail/word_detail_screen.dart';
import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:flutter/material.dart';

class WordItem extends StatelessWidget {
  const WordItem(
      {super.key,
      required this.word,
      this.onRefresh,
      this.isSearch = false,
      this.searchKey});

  final WordModel word;
  final bool isSearch;
  final String? searchKey;
  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await NavigationService.routeTo(
            RouteGenerator.wordDetail,
            arguments: WordDetailArguments(id: word.word ?? ''));

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
          title: !isNullEmpty(searchKey)
              ? _buildTextInSearching()
              : Text(
                  word.word ?? '',
                  style: ThemeText.bodyMedium,
                ),
        ),
      ),
    );
  }

  Widget _buildTextInSearching() {
    final word = (this.word.word ?? '').split(searchKey ?? ' ');

    return Row(
      children: List.generate(
        word.length,
        (index) => RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: word[index],
                style: ThemeText.bodyMedium,
              ),
              if (index < word.length - 1)
                TextSpan(
                  text: searchKey,
                  style: ThemeText.bodyStrong.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
