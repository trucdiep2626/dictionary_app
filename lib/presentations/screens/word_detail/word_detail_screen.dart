import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/presentations/screens/add_edit_word/components/form_widget.dart';
import 'package:dictionary_app/presentations/screens/word_detail/word_detail_state_notifier.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordDetailArguments {
  final String id;

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
          leading: state.isEditing
              ? IconButton(
                  onPressed: () => stateNotifier.confirmDiscard(),
                  icon: const Icon(Icons.clear),
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    NavigationService.goBack(value: state.shouldRefresh);
                  },
                ),
          actions: [
            IconButton(
              onPressed: () async {
                await stateNotifier.deleteWord(context);
              },
              icon: const Icon(Icons.delete),
            ),
            (state.isEditing)
                ? IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      await stateNotifier.updateWord();
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      stateNotifier.onChangedIsEditing();
                    },
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: state.showLoadingIndicator
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final state = ref.watch(wordDetailNotifierProvider);
    final stateNotifier = ref.read(wordDetailNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: state.isEditing
          ? FormWidget(
              wordController: stateNotifier.wordController,
              meaningController: stateNotifier.meaningController,
              onPressedSave: (context) => stateNotifier.updateWord(),
            )
          : Column(
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
              ],
            ),
    );
  }
}
