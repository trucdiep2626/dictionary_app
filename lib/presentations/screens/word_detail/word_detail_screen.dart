import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/config/route/route_generator.dart';
import 'package:dictionary_app/presentations/screens/add_edit_word/add_edit_word_screen.dart';
import 'package:dictionary_app/presentations/screens/word_detail/word_detail_state_notifier.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordDetailArguments {
  final int id;

  WordDetailArguments({
    required this.id,
  });
}

class WordDetailScreen extends ConsumerStatefulWidget {
  const WordDetailScreen({Key? key}) : super(key: key);

  @override
  _WordDetailScreenState createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is WordDetailArguments) {
        ref.read(wordDetailNotifierProvider.notifier).getDetailWord(arg.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordDetailNotifierProvider);
    final stateNotifier = ref.read(wordDetailNotifierProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        NavigationService.goBack(value: state.shouldRefresh);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          title: const Text(' '),
          actions: [
            IconButton(
              onPressed: () async {
                await stateNotifier.deleteWord(context);
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await NavigationService.routeTo(
                    RouteGenerator.addEditWord,
                    arguments: AddEditWordArguments(wordModel: state.word));
                if (result is bool && result) {
                  await stateNotifier.getDetailWord(state.word?.id ?? 0);
                  stateNotifier.onChangedShouldRefresh(true);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: state.showLoadingIndicator
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.word?.word ?? '',
                        style: ThemeText.bodySemibold.s24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.word?.definition ?? '',
                        style: ThemeText.bodyMedium.s16,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.word?.example ?? '',
                        style: ThemeText.bodyRegular.italic,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
