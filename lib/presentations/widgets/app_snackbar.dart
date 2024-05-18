import 'package:dictionary_app/common/utils/layout_extension.dart';
import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:flutter/material.dart';

class AppSnackbar with LayoutExtension {
  const AppSnackbar._();

  static GlobalKey<ScaffoldMessengerState> snackBarKey =
      GlobalKey<ScaffoldMessengerState>();

  static Widget _buildSnackbarFrame(
      {bool isError = false, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200),
        color: !(isError)
            ? AppColors.green.withOpacity(0.1)
            : AppColors.red.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }

  static void showSnackbar({
    required String title,
    double? margin,
    bool? isError,
    double? padding,
  }) {
    snackBarKey.currentState?.showSnackBar(
      SnackBar(
        margin: EdgeInsets.symmetric(vertical: margin ?? 0),
        content: _buildSnackbarFrame(
          isError: isError ?? false,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: ThemeText.bodyMedium.grey4.copyWith(
                color: (isError ?? false) ? AppColors.red : AppColors.green),
            maxLines: 3,
          ),
        ),
        backgroundColor: AppColors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        elevation: 0,
      ),
    );
  }
}
