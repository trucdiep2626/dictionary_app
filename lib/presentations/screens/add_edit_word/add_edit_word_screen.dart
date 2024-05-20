import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/presentations/screens/add_edit_word/add_edit_word_state_notifier.dart';
import 'package:dictionary_app/presentations/screens/add_edit_word/components/form_widget.dart';
import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:dictionary_app/presentations/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditWordArguments {
  final WordModel? wordModel;

  AddEditWordArguments({
    this.wordModel,
  });
}

class AddEditWordScreen extends ConsumerStatefulWidget {
  const AddEditWordScreen({Key? key}) : super(key: key);

  @override
  _AddEditWordScreenState createState() => _AddEditWordScreenState();
}

class _AddEditWordScreenState extends ConsumerState<AddEditWordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is AddEditWordArguments) {
        ref.read(addEditWordNotifierProvider.notifier).initData(arg.wordModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEditWordNotifierProvider);
    final stateNotifier = ref.read(addEditWordNotifierProvider.notifier);

    final isEdit = state.oldWord != null;

    return WillPopScope(
      onWillPop: () async {
        stateNotifier.confirmDiscard();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              stateNotifier.confirmDiscard();
            },
          ),
          centerTitle: false,
          backgroundColor: Colors.blue,
          title: Text(
            isEdit ? 'Edit Word' : 'Add New Word',
            style: ThemeText.bodyStrong.s20.white,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormWidget(
                      wordController: stateNotifier.wordController,
                      meaningController: stateNotifier.meaningController,
                      onPressedSave: stateNotifier.onPressedSave,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            isOutlineButton: true,
                            onPressed: () {
                              stateNotifier.onClear();
                            },
                            title: 'Clear',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppButton(
                            enable: state.enableButton,
                            onPressed: () {
                              stateNotifier.onPressedSave(context);
                            },
                            title: 'Save',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (state.showLoadingIndicator)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
