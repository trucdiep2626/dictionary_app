import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:dictionary_app/presentations/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({
    super.key,
    required this.wordController,
    required this.meaningController,
    required this.onPressedSave,
  });

  final TextEditingController wordController;
  final TextEditingController meaningController;
  final Function(BuildContext) onPressedSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Word'),
        AppTextField(
          controller: wordController,
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
        ),
        const SizedBox(height: 16),
        _buildTitle('Definition'),
        AppTextField(
          controller: meaningController,
          onEditingComplete: () {
            onPressedSave.call(context);
          },
        ),
      ],
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
