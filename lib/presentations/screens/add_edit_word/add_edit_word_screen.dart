import 'package:dictionary_app/data/models/word_model.dart';
import 'package:dictionary_app/presentations/screens/add_edit_word/add_edit_word_state_notifier.dart';
import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:dictionary_app/presentations/widgets/app_button.dart';
import 'package:dictionary_app/presentations/widgets/app_text_field.dart';
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
                    _buildTitle('Word'),
                    AppTextField(
                      controller: stateNotifier.wordController,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTitle('Definition'),
                    AppTextField(
                      controller: stateNotifier.meaningController,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTitle('Example'),
                    AppTextField(
                      controller: stateNotifier.exampleController,
                      onEditingComplete: () async {
                        await stateNotifier.onPressedSave(context);
                      },
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

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: ThemeText.bodySemibold,
      ),
    );
  }
}
